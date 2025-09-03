---
toc: true
layout: post
description: To do again
title: Run phonetic recognition on SLURM
categories: [rixvox2, slurm]
---

The python is a nothing script, the kind I usually would do in the repl or a notebook, but it needs to run on slurm.

`run_phone.py`

```python
from transformers import pipeline
import json
import os
import sys

MODEL = "jimregan/wav2vec2-swedish-phonetic-waxholm"
pipe = pipeline(model=MODEL, device=0)

with open(sys.argv[1]) as filelist:
    for file in filelist.readlines():
        file = file.strip()
        outfile = file.replace(".wav", ".phn.json")
        output = pipe(file, chunk_length_s=10, return_timestamps="word")
        with open(outfile, "w") as of:
            json.dump(output, of)
```

I didn't really intend to run **this** many jobs, but someone else was clogging up the GPU queue, so I split it into 1000 shards of 24 files each. Middle finger extended.

`run_phone.slurm`

```bash
#!/bin/bash
#SBATCH --job-name=w2phones
#SBATCH --output=w2phones_%j.out
#SBATCH --error=w2phones_%j.err
#SBATCH -p gpu
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --array=0-999%24
#SBATCH --cpus-per-task=16
#SBATCH --mem=1M
#SBATCH --time=365-00:00:00

echo "Job started on $SLURMD_NODENAME at $(date)"
echo "Using GPU(s): ${SLURM_STEP_GPUS:-$SLURM_JOB_GPUS}"

CONDA_ROOT="/nfs/tts2/home/joregan/miniconda3"
eval "$("$CONDA_ROOT/bin/conda" shell.bash hook)"

conda activate /nfs/tts2/home/joregan/miniconda3/envs/hf

SHARD=$(printf "shard_%04d" $SLURM_ARRAY_TASK_ID)

export HF_DATASETS_CACHE="/shared/joregan/rixvox-v2/cache/"
python /nfs/tts2/home/joregan/run_phone.py /nfs/tts2/home/joregan/phone_shards/$SHARD
echo "Job finished on $SLURMD_NODENAME at $(date)"
```
