import json
from pathlib import Path
import argparse
from transformers import pipeline

base_dir = Path("/shared/joregan/librispeech-textgrids/LibriSpeech/train-clean-100/")
out_dir = Path("/shared/joregan/librispeech-phones")
MODEL = "jimregan/wav2vec2-xls-r-300m-phoneme-timit"
pipe = pipeline(model=MODEL)

def get_args():
    parser = argparse.ArgumentParser("Transcribe a directory of audio files")
    parser.add_argument("set", type=str)
    args = parser.parse_args()
    return args

def main():
    args = get_args()

    for audio in base_dir.glob(f"{args.set}*/**/*.flac"):
        output_file = out_dir / f"{fileid}.json"
        if output_file.exists():
            continue
        output = pipe(audio)
        fileid = audio.stem
        with open(output_file, "w") as of:
            json.dump(output, of, indent=2)
