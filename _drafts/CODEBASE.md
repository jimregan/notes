# VoXtream2 Codebase

## Overview

VoXtream2 is a streaming, zero-shot text-to-speech system with dynamic speaking-rate control. Given a 3–10 second audio prompt, it synthesizes speech in the same voice with low latency (74ms first-packet on a consumer GPU) and faster-than-real-time throughput (RTF ~0.256 on RTX 3090). Speaking rate can be adjusted mid-utterance at runtime. The system supports acoustic prompts in any language via prompt text masking ("translingual" zero-shot).

The codebase is structured as a Python package (`voxtream`) with four CLI entry points, a Gradio web UI, a WebSocket server, and a PyTorch Lightning training pipeline.

---

## Repository Layout

```
voxtream/
├── voxtream/                  # Main package
│   ├── config.py              # SpeechGeneratorConfig dataclass
│   ├── model.py               # Neural network (Model)
│   ├── generator.py           # High-level inference (SpeechGenerator)
│   ├── dataset.py             # Training data loading (TrainDataset)
│   ├── train.py               # Hydra-based training entry point
│   ├── trainer.py             # PyTorch Lightning module
│   ├── run.py                 # `voxtream` CLI
│   ├── app.py                 # `voxtream-app` Gradio UI
│   ├── server.py              # `voxtream-server` WebSocket server
│   ├── client.py              # WebSocket client
│   ├── benchmark.py           # RTF / first-packet latency measurement
│   └── utils/
│       ├── model.py           # Sampling and masking helpers
│       ├── sampling.py        # Top-k / top-p sampling
│       ├── trainer.py         # LinearWarmupDecayScheduler
│       ├── sink_attention.py  # SinkAttention (streaming context)
│       ├── sidon_se.py        # Optional speech enhancement
│       ├── generator/         # Generation sub-utilities
│       │   ├── context.py     # GenerationContext, FrameState
│       │   ├── setup.py       # Model loader helpers
│       │   ├── prompt.py      # Prompt audio encoding
│       │   ├── runtime.py     # Per-frame decoding and index updates
│       │   ├── text.py        # Streaming text processing
│       │   └── helpers.py     # DTYPE_MAP, set_seed, etc.
│       ├── text/              # Text normalisation and phonemization
│       │   ├── phonemizer.py  # ESpeak wrapper
│       │   ├── normalizer.py  # Text normalisation
│       │   ├── number_norm.py # Number expansion
│       │   ├── time_norm.py   # Time expression expansion
│       │   └── punctuation.py # Punctuation handling
│       ├── aligner/           # Forced phoneme alignment (dataset prep)
│       ├── dataset/           # Dataset preparation scripts
│       └── test/              # Evaluation utilities (ASR, MOS, SV)
├── configs/
│   ├── generator.json         # Inference configuration (~55 fields)
│   ├── train.yaml             # Hydra training config
│   └── speaking_rate.json     # Speaking rate level definitions
├── tests/
│   └── test_run_output_regression.py
└── assets/                    # Example audio and test fixtures
```

---

## Model Architecture (`voxtream/model.py`)

The core `Model(nn.Module)` contains three stacked transformers.

### Phone Former (6 layers, 8 heads, 1024 dims)

Encodes phoneme token sequences. Uses a set of dynamic look-ahead masks (5 levels) to control how far ahead in the phoneme stream the model can see, enabling a range from fully causal to partially non-causal attention during training and inference.

### Temporal Former (12 layers, 16 heads)

The main autoregressive model. Accepts interleaved phone embeddings and audio embeddings and predicts the next *semantic* (primary codebook) audio token. During inference this transformer is cached and fed one frame at a time.

### Depth Former (4 layers, 8 heads)

Given the predicted semantic token, autoregressively predicts the remaining 15 Mimi codebook tokens for that frame. During training, it only runs over a 1/16 random subset of time steps (amortized computation).

### Embeddings and projections

- Phone embedding: vocab size 125
- Audio embedding: vocab size 2051 (2050 + 1 padding)
- Speaker embedding projection: 192 → 1024 dims
- Semantic head: linear projection to audio vocab
- Audio head: linear projection for the 15 dependent codebooks

### Key model methods

- `extract_phoneme_embeddings()`: Runs the Phone Former with a selected look-ahead mask.
- `generate_frame()`: Single inference step. Runs the Temporal Former on cached context, applies classifier-free guidance (CFG), samples the semantic token using distribution matching, then runs the Depth Former loop for the remaining codebook tokens.
- `forward_audio()`: Training forward pass. Runs the Temporal Former over a full sequence and the amortized Depth Former.
- `forward()`: Wraps `forward_audio()` and handles punctuation removal.

---

## Generation Pipeline (`voxtream/generator.py`)

`SpeechGenerator` is the main user-facing class. It owns and initialises all runtime dependencies:

- Mimi codec (Kyutai `moshi` library) for encoding/decoding audio at 12.5 fps, 16 codebooks
- Speaker encoder (IDRnD/ReDimNet, 192-dim embeddings at 16 kHz)
- Voice Activity Detection (Silero VAD, optional)
- Speech enhancement (SidonSE, optional)
- ESpeak phonemizer and text normaliser

### `generate_stream(prompt_audio, text, ...)`

The central method. It:

1. Resamples the prompt audio, runs VAD to trim silence, optionally runs speech enhancement.
2. Encodes the prompt with Mimi → audio tokens; encodes with the speaker encoder → speaker embedding.
3. Normalises and phonemizes `text` (which may be a string or a generator for streaming text input).
4. Runs a frame-by-frame generation loop (up to 750 frames / ~60 seconds):
   - Selects context via `SinkAttention` (prompt sink + sliding window).
   - Calls `Model.generate_frame()`.
   - Decodes the resulting Mimi codes back to a PCM waveform.
   - Yields the audio frame alongside timing metadata.
5. Adjusts the output distribution on every frame when speaking-rate control is requested.

Optional `torch.compile` and CUDA Graph patching are supported and roughly halve the RTF.

---

## Classifier-Free Guidance

The model supports two-branch CFG inference. When enabled, both a *conditioned* pass (normal inputs) and an *unconditioned* pass (speaker embedding zeroed, text replaced with `<UNK>`) are run as a batch of 2. The final logits are:

```
logits = cond * γ + (1 - γ) * uncond
```

Separate γ values are used for semantic tokens (`cfg_gamma=1.5`) and acoustic tokens (`cfg_ac_gamma=3.0`).

---

## Speaking-Rate Control

Speaking-rate control is implemented via *distribution matching*. Each output frame prediction is a distribution over 6 duration states (how many audio frames correspond to the current phone). `configs/speaking_rate.json` defines 7 rate levels (1–7 syllables per second), each with a target state distribution and associated weight β and cfg_gamma. At inference time:

1. The current model output distribution is compared to the target distribution.
2. Token probabilities are reweighted: `exp(β * (log(P_target) - log(P_current))) * P_current`.
3. Rate level can be fractional (linear interpolation between adjacent levels).
4. The rate can change mid-utterance by updating `target_spk_rate_cnt` between frames.

---

## Text Processing (`voxtream/utils/text/`)

Pipeline: raw text → normalise → phonemize → extract punctuation → convert to token indices → interpolate.

- **Normaliser**: expands numbers, times, abbreviations.
- **ESpeak**: wraps `espeak-ng` for grapheme-to-phoneme conversion; outputs IPA or X-SAMPA.
- **Punctuation module**: extracts punctuation insertion/deletion indices and tokens separately from the phoneme sequence, allowing the model to handle punctuation as a soft signal injected at specific positions rather than as part of the phone vocabulary.

---

## Streaming Context: Sink Attention (`voxtream/utils/sink_attention.py`)

For long-form generation, `SinkAttention` maintains an efficient context by combining:

- A **sink**: the cached prompt embeddings (audio + phone) always kept in context.
- A **sliding window**: the most recent 625 frames of generated audio.

This gives O(1) memory overhead per frame while preserving prompt-speaker consistency throughout generation. When the local position index exceeds the window, the Temporal Former's KV cache is rebuilt from the sink + latest window.

---

## Training (`voxtream/train.py`, `voxtream/trainer.py`)

### Data (`voxtream/dataset.py`)

`TrainDataset` consumes per-sample numpy arrays:

| Array | Description |
|---|---|
| `audio_codes` | Mimi tokens, shape `[16, T]` |
| `phoneme_sequence` | Token indices |
| `phoneme_embedding_index` | Maps each audio frame to a phone index |
| `semantic_label_shifts` | Duration state per frame (6 states) |
| `speaker_template` | 192-dim speaker embedding |

Each `__getitem__` call:

1. Randomly crops a 625-frame window.
2. Applies prompt text masking: replaces the first 3–10 seconds of phone tokens with `<UNK>` (simulates zero-shot prompting).
3. Inserts/removes punctuation tokens at designated positions.
4. Encodes semantic labels with shift information.
5. Adds BOS/EOS and padding delays.

### Trainer (Lightning module)

Two losses are optimised jointly:

- **Semantic loss**: CrossEntropy over the 6-state semantic label at each frame.
- **Audio loss**: CrossEntropy over the 15 dependent codebook tokens at 1/16 of positions (amortized depth former).

Top-10 accuracy for both losses is logged. The learning rate schedule is `LinearWarmupDecayScheduler`: linear warmup for 1 epoch from 1e-5 to 2e-4, then cosine decay to 0.

Key training hyperparameters:

| | |
|---|---|
| Batch size | 64 |
| Learning rate | 2e-4 |
| Max epochs | 10 |
| Gradient clip | 0.5 |
| Precision | bfloat16 mixed |
| Strategy | DDP |
| CFG dropout prob | 0.1 |

The depth former can be frozen during fine-tuning with `freeze_dep_former: true`.

---

## Configuration

### `configs/generator.json`

A ~55-field JSON file consumed as `SpeechGeneratorConfig`. Key sections:

- Special tokens (`sil`, `bos`, `eos`, `unk`, punctuation tokens)
- HuggingFace repo IDs for all model weights
- Mimi codec parameters (sample rate 24 kHz, 16 codebooks, 80ms frames)
- Speaker encoder parameters (16 kHz, ReDimNet-M)
- Inference tuning (temperature 0.9, top-k 5, top-p 0.9, cfg_gamma 1.5, cfg_ac_gamma 3.0)
- Input limits (max prompt 20 sec, max phone tokens 2000)
- Speaking rate parameters and phoneme index map

### `configs/train.yaml`

Hydra configuration for training. Specifies datasets (Emilia, HiFiTTS2), model architecture choices (`phone_former`, `temp_former`, `dep_former_csm`), and all training hyperparameters.

### `configs/speaking_rate.json`

Seven speaking-rate levels (1–7 sps), each with a `duration_state` probability vector over 6 states, a weight β, and a cfg_gamma override.

---

## Entry Points

| Command | Module | Purpose |
|---|---|---|
| `voxtream` | `run.py` | CLI: synthesize to WAV |
| `voxtream-app` | `app.py` | Gradio web UI with streaming playback |
| `voxtream-server` | `server.py` | FastAPI WebSocket server |
| `voxtream-benchmark` | `benchmark.py` | RTF and first-packet latency measurement |

`voxtream-server` exposes a WebSocket endpoint at `/voxtream` on port 7860. The client sends JSON with prompt audio (base64) and text, and the server streams back binary audio frames.

---

## Evaluation Utilities (`voxtream/utils/test/`)

| Module | Metric |
|---|---|
| `asr.py` | WER via OpenAI Whisper |
| `utmos.py` | MOS prediction |
| `ecapa_tdnn.py` | Speaker verification (ECAPA-TDNN) |
| `spk_sim.py` | Speaker similarity score |

`utils/test/run.py` orchestrates batch evaluation across a test set.

---

## Dependencies

**Core ML**: `torch==2.4.0`, `torchaudio==2.4.0`, `torchtune==0.4.0` (Llama3.2 transformer primitives), `transformers==4.50.0`, `lightning==2.4.0`

**Audio**: `moshi==0.2.11` (Mimi codec), `librosa`, `soundfile`, `silero-vad==6.2.0`

**Text**: `g2p-en==2.1.0`, `inflect==7.5.0`, `nltk==3.9.1`

**Web**: `gradio==4.44.1`, `fastapi`, `uvicorn`, `websockets`

**Config/utils**: `hydra-core==1.3.2`, `pydantic==2.10.6`, `torchao==0.9.0`

**External models** (downloaded automatically via HuggingFace / `torch.hub`):

- `herimor/voxtream2` — generator weights (~2 GB)
- `kyutai/moshiko-pytorch-bf16` — Mimi codec
- `IDRnD/ReDimNet` — speaker encoder

---

## Tests

A single regression test (`tests/test_run_output_regression.py`) runs the full pipeline on a test prompt and asserts numerical equality (rtol=1e-5) against reference frames stored in `assets/test/reference_frames.npy`. This guards against silent changes in generation output.

---

## Licensing

Dual-licensed under MIT and Apache 2.0. Dataset attributions (for training data) are tracked separately in `ATTRIBUTION.md`.
