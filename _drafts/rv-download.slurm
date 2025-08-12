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
