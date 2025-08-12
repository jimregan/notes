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
        serializable_sample = convert_for_json(sample_copy)
        jsonl_file.write(json.dumps(serializable_sample, ensure_ascii=False) + "\n")
```
