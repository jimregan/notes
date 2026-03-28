# Fine-tuning VoXtream2

This document covers how to fine-tune VoXtream2 on a custom dataset. The process has two main phases: dataset preparation and training.

---

## Environment

Training requires the Docker container from the repository:

```bash
docker-compose -f .devcontainer/docker-compose.yaml build voxtream
```

All subsequent commands are run inside the container. Use `GPU_IDS` to select which GPUs are visible:

```bash
GPU_IDS=0,1 docker-compose -f .devcontainer/docker-compose.yaml run voxtream <command>
```

The workspace directory is mounted at `/workspace` inside the container. The HuggingFace cache from `~/.cache` on the host is also mounted, so model weights downloaded once are reused across runs.

---

## Dataset Preparation

The training pipeline consumes a set of pre-computed numpy arrays per dataset split. These are produced by running five scripts in sequence. All scripts read from a metadata Parquet file.

### Metadata format

Your metadata file must be a Parquet file with at minimum these columns:

| Column | Type | Description |
|---|---|---|
| `text_norm` | str | Normalised transcript for each utterance |
| `full_path` | str | Absolute path to the audio file |
| `paths` | str | `^`-separated audio file paths (for Mimi encoding and speaker embedding; typically same as `full_path`) |

The `paths` column supports `^`-separated lists for concatenating multiple audio segments into one sample (used in the original training data). For single-file utterances, set it to the same value as `full_path`.

### Step 1: Extract phonemes

```bash
python voxtream/utils/dataset/extract_phonemes.py \
    --meta-path /path/to/metadata.parquet \
    --output-dir /path/to/output \
    --num-proc 8
```

Reads `text_norm` from the metadata, phonemizes each utterance with eSpeak, and separates out punctuation. Writes `phonemes.parquet` to the output directory with columns: `phones`, `punct_symbs`, `punct_pos`, `words_pos`.

The script runs in parallel using `--num-proc`. Use a value close to your CPU count.

### Step 2: Get phoneme timestamps (forced alignment)

```bash
python voxtream/utils/dataset/clap_ipa_aligner.py \
    --meta-path /path/to/phonemes.parquet \
    --gpu 0 \
    --batch-size 32 \
    --num-workers 4
```

Runs the ClapIPA forced aligner on each utterance to produce frame-level phoneme timestamps. Reads `phones` and `full_path` from the input Parquet file. Adds an `alignment` column to the same file and writes it back in place.

Requires a GPU. Adjust `--batch-size` to fit your VRAM.

### Step 3: Align phonemes to Mimi frames

```bash
python voxtream/utils/dataset/align.py \
    --meta /path/to/phonemes.parquet \
    --group-meta /path/to/group_meta.parquet \
    --output-dir /path/to/output \
    --num-phones 2 \
    --num-frames 688 \
    --shift 2 \
    --num-proc 8
```

Maps the per-phoneme timestamps onto the Mimi frame grid (12.5 fps). Produces four numpy files in the output directory:

| File | Shape | Description |
|---|---|---|
| `phone_tokens.npy` | `[N]` object array | Per-sample phoneme token index sequences |
| `sem_label_shifts.npy` | `[N, num_frames]` uint8 | Duration state label per frame |
| `phone_emb_indices.npy` | `[N, num_frames, num_phones]` uint16 | Phone embedding index per frame |
| `punctuation.npy` | `[N]` object array | Punctuation insertion/deletion indices and tokens |

The `--group-meta` file is a Parquet with an `indices` column that groups metadata rows into samples (used when one sample concatenates multiple utterances).

Key arguments:
- `--num-phones 2`: Number of phone indices tracked per frame (keep at 2 to match the model).
- `--num-frames 688`: Maximum frames per sample (55 seconds at 12.5 fps).
- `--shift 2`: Maximum allowed phoneme alignment shift.

### Step 4: Extract Mimi tokens

```bash
python voxtream/utils/dataset/mimi.py \
    --meta-path /path/to/metadata.parquet \
    --output-dir /path/to/output \
    --batch-size 32 \
    --num-workers 4 \
    --gpu 0 \
    --num-codebooks 16 \
    --target-length-sec 55
```

Encodes audio with the Mimi codec (downloaded automatically from `kyutai/moshiko-pytorch-bf16`). Reads the `paths` column from the metadata. Writes `mimi_codes_16cb.npy` of shape `[N, 16, T]` (uint16).

For chunked processing of large datasets, use `--chunk <id>` to process a slice of the metadata at a time.

### Step 5: Extract speaker embeddings

```bash
python voxtream/utils/dataset/speaker_encoder.py \
    --meta-path /path/to/metadata.parquet \
    --output-dir /path/to/output \
    --batch-size 64 \
    --num-workers 4 \
    --gpu 0 \
    --target-length-sec 3
```

Encodes the first 3 seconds of each audio file with the ReDimNet-M speaker encoder (downloaded automatically via `torch.hub`). Reads the first `^`-separated path from the `paths` column. Writes `spk_templates.npy` of shape `[N, 192]` (float32, L2-normalised).

### Output directory structure

After all five steps, your dataset directory should contain:

```
/path/to/output/
    mimi_codes_16cb.npy      → rename to mimi_codes.npy
    phone_tokens.npy
    sem_label_shifts.npy
    phone_emb_indices.npy
    punctuation.npy
    spk_templates.npy
```

The training config expects the Mimi codes file to be named `mimi_codes.npy`. Rename it:

```bash
mv /path/to/output/mimi_codes_16cb.npy /path/to/output/mimi_codes.npy
```

---

## Training Configuration

Training is configured via `configs/train.yaml` using Hydra. Any field can be overridden on the command line as `key=value`.

### Loading pre-trained weights

Fine-tuning starts from the released VoXtream2 checkpoint. There are two ways to point to it:

**Option A — download automatically from HuggingFace:**

Leave `model_weight_path: null` and `dep_former_weight_path: null` in the config. The Depth Former weights are downloaded automatically using `dep_former_name: dep_former_csm.safetensors` from `model_repo: herimor/voxtream2`.

To also load the full model, you need Option B.

**Option B — local checkpoint:**

```yaml
model_weight_path: /path/to/voxtream2_checkpoint.ckpt
dep_former_weight_path: /path/to/dep_former_csm.safetensors  # optional if included in model checkpoint
```

A Lightning checkpoint saved by a previous training run has the format expected by `model_weight_path`. The loader strips the `model.` prefix from Lightning's `state_dict` automatically.

### Freezing the Depth Former

`freeze_dep_former: true` (the default) freezes the Depth Former and its associated audio embeddings and head. This is the recommended setting for fine-tuning: the Temporal Former (the main sequence model) adapts while the Depth Former (codebook prediction) remains fixed.

Set `freeze_dep_former: false` only if you have enough data and want to fully retrain both components.

### Pointing to your dataset

```yaml
dataset_base_dir: /path/to/datasets
```

The `dataset_base_dir` is the parent directory. Under it, create one subdirectory per dataset, each containing the numpy files produced in the preparation steps:

```
/path/to/datasets/
    my_dataset/
        mimi_codes.npy
        phone_tokens.npy
        phone_emb_indices.npy
        sem_label_shifts.npy
        punctuation.npy
        spk_templates.npy
```

Register the dataset under `dataset.datasets` in `train.yaml`:

```yaml
dataset:
  datasets:
    my_dataset:
      audio_codes: mimi_codes.npy
      phoneme_sequence_map: phone_tokens.npy
      phoneme_embedding_indices: phone_emb_indices.npy
      semantic_label_shifts: sem_label_shifts.npy
      spk_templates: spk_templates.npy
      punctuation: punctuation.npy
```

Multiple datasets can be listed; they are concatenated automatically.

### Batch size and memory

| GPU | Recommended batch size |
|---|---|
| H200 (80 GB) | 64 (default) |
| RTX 3090 (24 GB) | 12 |

Use gradient accumulation if your per-GPU batch is smaller than desired:

```bash
# effective batch of 32 on a single RTX 3090
python voxtream/train.py batch_size=8 accumulate_grad_batches=4
```

Note: `accumulate_grad_batches` is passed through to the Lightning `Trainer` but is not listed in `train.yaml` by default — add it or pass it on the command line.

### Recommended fine-tuning hyperparameters

For a small custom dataset (a few hours), start with:

```yaml
max_epochs: 5
lr: 5e-5
initial_lr: 1e-6
warmup_epochs: 1
freeze_dep_former: true
```

For a larger dataset approaching the scale of the original training data, the default values are appropriate:

```yaml
max_epochs: 10
lr: 2e-4
initial_lr: 1e-5
warmup_epochs: 1
```

---

## Running Fine-tuning

### Single GPU

```bash
GPU_IDS=0 docker-compose -f .devcontainer/docker-compose.yaml run voxtream \
    python voxtream/train.py \
    batch_size=12 \
    dataset_base_dir=/path/to/datasets \
    model_weight_path=/path/to/checkpoint.ckpt \
    exp_name=my_finetune \
    gpus=1
```

### Multiple GPUs

```bash
GPU_IDS=0,1,2,3 docker-compose -f .devcontainer/docker-compose.yaml run voxtream \
    python voxtream/train.py \
    batch_size=32 \
    dataset_base_dir=/path/to/datasets \
    model_weight_path=/path/to/checkpoint.ckpt \
    exp_name=my_finetune
```

`gpus: -1` (the default) uses all visible GPUs with DDP. Training uses bfloat16 mixed precision by default.

### Output

Results are saved to `experiments/{exp_name}/`. Each run produces:

```
experiments/my_finetune/
    hydra_config.yaml          # full config snapshot
    version_0/
        checkpoints/
            epoch=0.ckpt
            epoch=1.ckpt
            ...
        events.out.tfevents.*  # TensorBoard logs
```

Monitor training with TensorBoard:

```bash
tensorboard --logdir experiments/my_finetune
```

Key metrics logged: `semantic_loss`, `audio_loss`, `train_loss`, `train_semantic_acc_top10`, `train_audio_acc_top10`, `lr-AdamW`.

---

## Using a Fine-tuned Checkpoint for Inference

The Lightning checkpoint saved during training can be loaded directly by `SpeechGenerator` by converting it to a plain state dict. The easiest approach is to point the inference config at the checkpoint via a custom `generator.json`:

```python
from voxtream.generator import SpeechGenerator, SpeechGeneratorConfig
import json, torch

with open('configs/generator.json') as f:
    config = SpeechGeneratorConfig(**json.load(f))

generator = SpeechGenerator(config)

# Load fine-tuned weights on top
ckpt = torch.load('experiments/my_finetune/version_0/checkpoints/epoch=4.ckpt', map_location='cpu')
state_dict = {k.replace('model.', ''): v for k, v in ckpt['state_dict'].items()}
generator.model.load_state_dict(state_dict, strict=True)
```

After loading, use the generator normally as described in the README.
