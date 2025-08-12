---
toc: true
layout: post
description: ...because I need to re-do this.
title: Re-running Rixvox-v2 conversion
categories: [rixvox2, huggingface]
---

Based on [this]({% post_url 2025-07-25-how-I-converted-rixvox2 %}) post.

`rv_convert.py`:

```python
from datasets import load_dataset
import os
import json
import soundfile as sf
import pandas as pd
from datetime import datetime
import numpy as np

PARQUET_DIR = "/shared/joregan/rixvox-v2/cache/datasets--KBLab--rixvox-v2/snapshots/1f5f37f5ec8740eae318eeae7bf190074454d0d1/data/"
OUTPUT_DIR = "/shared/joregan/rixvox-v2/audio_files/wav/"
OUTPUT_JSONL = "/shared/joregan/rixvox-v2/audio_files/metadata.jsonl"

def convert_for_json(obj):
    """Recursively convert objects to JSON serializable formats."""
    if isinstance(obj, (pd.Timestamp, datetime, np.datetime64)):
        return str(obj)
    elif isinstance(obj, (np.integer)):
        return int(obj)
    elif isinstance(obj, (np.floating)):
        return float(obj)
    elif isinstance(obj, (np.ndarray, list)):
        return [convert_for_json(v) for v in obj]
    elif isinstance(obj, dict):
        return {k: convert_for_json(v) for k, v in obj.items()}
    else:
        return obj

dataset = load_dataset(
    "parquet",
	data_files=PARQUET_DIR,
	split="train"
	}

os.makedirs(OUTPUT_DIR, exist_ok=True)

with open(OUTPUT_JSONL, "w", encoding="utf-8") as jsonl_file:
    for i, sample in enumerate(dataset):
        audio = sample["audio"]
        audio_path = os.path.join(OUTPUT_DIR, f"{i}.wav")
        sf.write(audio_path, audio["array"], audio["sampling_rate"])
        sample_copy = dict(sample)
        sample_copy.pop("audio", None)
        sample_copy["audio_filepath"] = audio_path
        serializable_sample = convert_for_json(sample_copy)
        jsonl_file.write(json.dumps(serializable_sample, ensure_ascii=False) + "\n")
```
