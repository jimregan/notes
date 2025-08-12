---
toc: true
layout: post
description: ...because I need to re-do this.
title: How I converted Rixvox-v2
categories: [rixvox2, huggingface]
---



```python
from datasets import load_dataset
dataset = load_dataset(
    "parquet",
	data_files="./cache/datasets--KBLab--rixvox-v2/snapshots/1f5f37f5ec8740eae318eeae7bf190074454d0d1/data/",
	split="train"
	}
import os
output_audio_dir = "audio_files"
import json
import soundfile as sf
output_jsonl_path = "metadata.jsonl"
os.makedirs(output_audio_dir, exist_ok=True)
with open(output_jsonl_path, "w", encoding="utf-8") as jsonl_file:
    for i, sample in enumerate(dataset):
        # Save audio to .wav
        audio = sample["audio"]
        audio_path = os.path.join(output_audio_dir, f"{i}.wav")
        sf.write(audio_path, audio["array"], audio["sampling_rate"])
```
