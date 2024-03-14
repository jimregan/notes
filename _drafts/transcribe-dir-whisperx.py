# coding=utf-8
# Copyright 2024 Jim O'Regan for Språkbanken Tal
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Lint as: python3
from pathlib import Path
import argparse
import whisperx
import torch


def get_args():
    parser = argparse.ArgumentParser("Transcribe a directory of wav files")

    parser.add_argument("wav_directory", type=Path)
    parser.add_argument("tsv_directory", nargs="?", type=Path)

    args = parser.parse_args()
    return args


def main():
    args = get_args()

    device = "cuda" if torch.cuda.is_available() else "cpu"

    indir = args.wav_directory
    if args.tsv_directory:
        outdir = args.tsv_directory
    else:
        outdir = indir

    model = whisperx.load_model("medium.en", device=device)

    for wav in indir.glob("*.wav"):
        audio = whisperx.load_audio(str(wav))
        output = model.transcribe(audio, language="en")
        model_a, metadata = whisperx.load_align_model(language_code="en", device=device)
        result = whisperx.align(output["segments"], model_a, metadata, audio, device, return_char_alignments=False)
        outfile = outdir / f"{wav.stem}.tsv"
        with open(outfile, "w") as of:
            if "word_segments" in result:
                for res in result["word_segments"]:
                    of.write(f'{res["start"]}\t{res["end"]}\t{res["word"]}\n')


if __name__ == '__main__':
        main()
