---
toc: true
layout: post
description: ...because I need to re-do this.
title: How I downloaded Rixvox-v2
categories: [rixvox2, huggingface]
---

<!-- Basically, the dataset is too large to download directly, so I used the Hugging Face CLI to download it into a local cache directory. -->

Basically, the dataset is too large to download to local storage, so I used the Hugging Face CLI to download it to a NAS directory.

(Also, I typed "basically" and copilot wrote the rest of the sentence for me, which is nice, though I had to correct the intention.)

What I hadn't known is that my supervisor was going to replace the NAS device, so I need to re-do this.

```bash
mkdir cache
huggingface-cli download --repo-type dataset KBLab/rixvox-v2 --cache-dir ./cache
```

Re-written for SLURM:

```bash
#!/bin/bash
#SBATCH --job-name=rv_download
#SBATCH --output=rv_download_%j.out
#SBATCH --error=rv_download_%j.err
#SBATCH --nodelist=deepspeech
#SBATCH --cpus-per-task=16
#SBATCH --mem=1M
#SBATCH --time=365-00:00:00

echo "Job started on $SLURMD_NODENAME at $(date)"

/home/joregan/.local/bin/huggingface-cli download --repo-type dataset KBLab/rixvox-v2 --cache-dir /shared/joregan/rixvox-v2/cache
```
