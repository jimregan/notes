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
OUTPUT_BASE_DIR = "/shared/joregan/rixvox-v2/audio_files/"
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

os.makedirs(OUTPUT_BASE_DIR, exist_ok=True)
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

```conda
name: rv_convert
channels:
  - defaults
dependencies:
  - _libgcc_mutex=0.1=main
  - _openmp_mutex=5.1=1_gnu
  - bzip2=1.0.8=h5eee18b_6
  - ca-certificates=2025.7.15=h06a4308_0
  - expat=2.7.1=h6a678d5_0
  - ld_impl_linux-64=2.40=h12ee557_0
  - libffi=3.4.4=h6a678d5_1
  - libgcc-ng=11.2.0=h1234567_1
  - libgomp=11.2.0=h1234567_1
  - libstdcxx-ng=11.2.0=h1234567_1
  - libuuid=1.41.5=h5eee18b_0
  - libxcb=1.17.0=h9b100fa_0
  - ncurses=6.5=h7934f7d_0
  - openssl=3.0.17=h5eee18b_0
  - pip=25.1=pyhc872135_2
  - pthread-stubs=0.3=h0ce48e5_1
  - python=3.10.18=h1a3bd86_0
  - readline=8.3=hc2a1206_0
  - sqlite=3.50.2=hb25bd0a_1
  - tk=8.6.14=h993c535_1
  - xorg-libx11=1.8.12=h9b100fa_1
  - xorg-libxau=1.0.12=h9b100fa_0
  - xorg-libxdmcp=1.1.5=h9b100fa_0
  - xorg-xorgproto=2024.1=h5eee18b_1
  - xz=5.6.4=h5eee18b_1
  - zlib=1.2.13=h5eee18b_1
  - pip:
    - aiohappyeyeballs==2.6.1
    - aiohttp==3.12.15
    - aiosignal==1.4.0
    - async-timeout==5.0.1
    - attrs==25.3.0
    - certifi==2025.8.3
    - cffi==1.17.1
    - charset-normalizer==3.4.3
    - filelock==3.18.0
    - frozenlist==1.7.0
    - fsspec==2025.3.0
    - idna==3.10
    - jinja2==3.1.6
    - markupsafe==3.0.2
    - mpmath==1.3.0
    - multidict==6.6.4
    - networkx==3.4.2
    - numpy==2.2.6
    - nvidia-cublas-cu12==12.8.4.1
    - nvidia-cuda-cupti-cu12==12.8.90
    - nvidia-cuda-nvrtc-cu12==12.8.93
    - nvidia-cuda-runtime-cu12==12.8.90
    - nvidia-cudnn-cu12==9.10.2.21
    - nvidia-cufft-cu12==11.3.3.83
    - nvidia-cufile-cu12==1.13.1.3
    - nvidia-curand-cu12==10.3.9.90
    - nvidia-cusolver-cu12==11.7.3.90
    - nvidia-cusparse-cu12==12.5.8.93
    - nvidia-cusparselt-cu12==0.7.1
    - nvidia-nccl-cu12==2.27.3
    - nvidia-nvjitlink-cu12==12.8.93
    - nvidia-nvtx-cu12==12.8.90
    - packaging==25.0
    - pandas==2.3.1
    - pillow==11.3.0
    - propcache==0.3.2
    - pycparser==2.22
    - python-dateutil==2.9.0.post0
    - pytz==2025.2
    - pyyaml==6.0.2
    - regex==2025.7.34
    - requests==2.32.4
    - safetensors==0.6.2
    - setuptools==78.1.1
    - six==1.17.0
    - soundfile==0.13.1
    - sympy==1.14.0
    - torch==2.8.0
    - torchaudio==2.8.0
    - torchvision==0.23.0
    - tqdm==4.67.1
    - triton==3.4.0
    - typing-extensions==4.14.1
    - tzdata==2025.2
    - urllib3==2.5.0
    - wheel==0.45.1
    - yarl==1.20.1
prefix: /home/joregan/miniconda3/envs/rv_convert
```

```bash
#!/bin/bash
#SBATCH --job-name=rv_convert
#SBATCH --output=rv_convert_%j.out
#SBATCH --error=rv_convert_%j.err
#SBATCH --nodelist=deepspeech
#SBATCH --cpus-per-task=16
#SBATCH --mem=1M
#SBATCH --time=365-00:00:00

echo "Job started on $SLURMD_NODENAME at $(date)"

if [ ! -d $HOME/miniconda3 ]; then
    echo "MiniConda3 not found, please install it first."
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
fi
CONDA_ROOT="$HOME/miniconda3"
eval "$("$CONDA_HOME/bin/conda" shell.bash hook)"

conda activate /nfs/tts2/home/joregan/miniconda3/envs/rv_convert

python /nfs/tts2/home/joregan/rv_convert.py
echo "Job finished on $SLURMD_NODENAME at $(date)"
```
