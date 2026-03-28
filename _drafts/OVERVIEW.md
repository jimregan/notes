## NeMo Speech Data Processor (SDP) Overview

**Purpose:** A NVIDIA framework for building composable pipelines that prepare speech datasets for ASR/TTS model training. The core abstraction is a chain of *processor* classes that transform NeMo-style JSONL manifest files.

---

### Architecture

**Entry point:** `main.py` → Hydra CLI → `sdp/run_processors.py` orchestrates a sequential processor chain defined in YAML configs.

**Manifest format** (JSONL, one entry per line):
```json
{"audio_filepath": "/path/to/audio.wav", "text": "hello world", "duration": 2.5}
```

---

### Key Abstractions (`sdp/processors/`)

| Layer | Purpose |
|---|---|
| `base_processor.py` | `BaseProcessor` and `BaseParallelProcessor` — abstract base classes all processors inherit from |
| `datasets/` | 15+ dataset-specific manifest creators (LibriSpeech, MCV, MLS, VoxPopuli, etc.) |
| `modify_manifest/` | Text/field transformations (`SubRegex`, `AddConstantFields`) and filters (`DropHighWER`, `DropDuplicates`) |
| `inference/` | Runs models inline — ASR (NeMo, Whisper, HF), NLP, LLM (vLLM), quality estimation |
| `manage_files/` | Audio conversion (SoX/FFmpeg), archive extraction, file cleanup |
| `tts/` | Specialized 10-step TTS pipeline: diarization → alignment → quality metrics |
| `langs/` | Language-specific processors |

---

### Processor Pattern

- Each processor takes `input_manifest_file` → writes `output_manifest_file`
- `process_dataset_entry()` runs in parallel (Dask distributed or Joblib multiprocessing)
- Returns `List[DataEntry]` — one entry can produce many outputs (e.g., audio splitting)
- YAML `test_cases` provide runtime validation before full execution

---

### Configuration

Hydra-based YAML with `${var}` interpolation. The `processors_to_run` field supports slice notation (`"0:"`, `"1:3"`, `"2"`) to re-run partial pipelines:

```yaml
processors:
  - _target_: sdp.processors.CreateInitialManifestLibrispeech
    output_manifest_file: ${workspace_dir}/initial_manifest.json
  - _target_: sdp.processors.SoxConvert
    input_manifest_file: ${workspace_dir}/initial_manifest.json
    output_manifest_file: ${workspace_dir}/converted.json
```

Pre-built configs for 14+ languages live in `dataset_configs/`.

---

### Extending SDP

To add a new processor: subclass `BaseParallelProcessor`, implement `process_dataset_entry()`, register it, and reference it in a YAML config via `_target_`.
