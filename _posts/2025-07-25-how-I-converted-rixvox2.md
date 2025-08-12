---
toc: true
layout: post
description: ...because I need to re-do this.
title: How I converted Rixvox-v2
categories: [rixvox2, huggingface]
---

Loading needed to be done as a directory of parquet files:

```python
from datasets import load_dataset
dataset = load_dataset(
    "parquet",
	data_files="./cache/datasets--KBLab--rixvox-v2/snapshots/1f5f37f5ec8740eae318eeae7bf190074454d0d1/data/",
	split="train"
	}
```

Make the output directory:

```python
import os
output_audio_dir = "audio_files"
os.makedirs(output_audio_dir, exist_ok=True)
```

Some of the metadata is not JSON serializable, so we need to convert it:

```python
def make_json_serializable(record):
    """Convert non-serializable fields like timestamps to strings."""
    def convert(value):
        if isinstance(value, (datetime, pd.Timestamp, np.datetime64)):
            return str(value)
        elif isinstance(value, list):
            return [convert(v) for v in value]
        elif isinstance(value, dict):
            return {k: convert(v) for k, v in value.items()}
        else:
            return value
        return {k: convert(v) for k, v in record.items()}
```

Now run the conversion loop:

```python
import json
import soundfile as sf
import pandas as pd
from datetime import datetime
import numpy as np
output_jsonl_path = "metadata.jsonl"
with open(output_jsonl_path, "w", encoding="utf-8") as jsonl_file:
    for i, sample in enumerate(dataset):
        audio = sample["audio"]
        audio_path = os.path.join(output_audio_dir, f"{i}.wav")
        sf.write(audio_path, audio["array"], audio["sampling_rate"])
        sample_copy = dict(sample)
        sample_copy.pop("audio", None)
        sample_copy["audio_filepath"] = audio_path
        serializable_sample = make_json_serializable(sample_copy)
        jsonl_file.write(json.dumps(serializable_sample, ensure_ascii=False) + "\n")
```
