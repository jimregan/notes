#!/bin/bash
#SBATCH --job-name=kaldi_apptainer
#SBATCH --output=kaldi_apptainer_%j.out
#SBATCH --error=kaldi_apptainer_%j.err
#SBATCH --nodelist=deepspeech
#SBATCH --gres=gpu:8
#SBATCH --cpus-per-task=16
#SBATCH --mem=1M
#SBATCH --time=365-00:00:00

# Optional: load Apptainer module if needed on your system
module load apptainer  # or singularity if that's the older name

echo "Job started on $SLURMD_NODENAME at $(date)"
echo "Using GPU(s): ${SLURM_STEP_GPUS:-$SLURM_JOB_GPUS}"

# Run the container with GPU access and mounted volumes
apptainer exec --nv \
  --bind /shared/joregan/kaldi_swe/data:/opt/kaldi/egs/sprakbanken_swe/s5/data \
  --bind /shared/joregan/kaldi_swe/exp:/opt/kaldi/egs/sprakbanken_swe/s5/exp \
  --bind /shared/joregan/kaldi_swe/mfcc:/opt/kaldi/egs/sprakbanken_swe/s5/mfcc \
  /home/joregan/kaldi.sif \
  bash -c "cd /opt/kaldi/egs/sprakbanken_swe/s5 && ./run.sh"

echo "Job finished at $(date)"
