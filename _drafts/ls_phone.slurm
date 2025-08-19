#!/bin/bash
#SBATCH --job-name=ls_phone
#SBATCH --partition=gpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gpus-per-task=1
#SBATCH --time=7-00:00:00
#SBATCH --array=1-9
#SBATCH --output=ls_phone_%A_%a.out
#SBATCH --error=ls_phone_%A_%a.err

echo "Running set $SLURM_ARRAY_TASK_ID on $(hostname)"

# Call your Python script with the array index as argument
/home/joregan/miniconda3/bin/python /nfs/tts2/home/joregan/ls_phone.py "$SLURM_ARRAY_TASK_ID"

