import json
from pathlib import Path
import argparse
from transformers import pipeline

base_dir = Path("/shared/joregan/librispeech-textgrids/LibriSpeech/train-clean-500/")
out_dir = Path("/shared/joregan/librispeech-phones")
MODEL = "jimregan/wav2vec2-xls-r-300m-phoneme-timit"
pipe = pipeline(model=MODEL)

#for set in {1..9}; do
#    sbatch --parsable
#      --partition="gpu"
#      --ntasks=1
#      --cpus-per-task=4
#      --time=7-00:00:00
#      --gpus-per-task=1
#      --output=ls_phone_${set}_%j.out
#      --error=ls_phone_${set}_%j.err
#      --wrap="/home/joregan/miniconda3/bin/python /nfs/tts2/home/joregan/ls_phone.py $set"; done

def get_args():
    parser = argparse.ArgumentParser("Transcribe a directory of audio files")
    parser.add_argument("set", type=str)
    args = parser.parse_args()
    return args

def main():
    args = get_args()

    for audio in base_dir.glob(f"{args.set}*/**/*.flac"):
        fileid = audio.stem
        output_file = out_dir / f"{fileid}.json"
        if output_file.exists():
            continue
        output = pipe(str(audio))
        with open(output_file, "w") as of:
            json.dump(output, of, indent=2)


if __name__ == '__main__':
    main()