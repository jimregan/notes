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
import torch
import whisper
from pydub import AudioSegment
from string import punctuation


_HELP_MSG = """
Transcribe a directory of .wav files for use with MFA.

Transcribes all .wav files in the wav_input directory
using Whisper, placing the resulting text and resampled
audio in wav_txt_output for use with MFA.
"""


PUNCT = set(punctuation)


AD_PARAMS=["-ac", "1", "-acodec", "pcm_s16le", "-ar", "16000"]


def clean_sentence(text):
    words = []
    text = text.replace("—", " ")
    for word in text.split(" "):
        while word[0:1] in PUNCT:
            word = word[1:]
        while word[-1:] in PUNCT:
            word = word[:-1]
        words.append(word.lower())
    return " ".join(words)


def fix_nonwords(text):
    words = []
    for word in text.split(" "):
        if word.startswith("[") and word.endswith("]"):
            words.append("[bracketed]")
        else:
            words.append(word)
    return " ".join(words)


def get_args():
    parser = argparse.ArgumentParser(_HELP_MSG)

    parser.add_argument("wav_input", type=Path)
    parser.add_argument("wav_txt_output", type=Path)

    args = parser.parse_args()
    return args


def main():
    args = get_args()

    device = "cuda" if torch.cuda.is_available() else "cpu"

    indir = args.wav_input
    outdir = args.wav_txt_output

    model = whisper.load_model("medium.en", device=device)

    for wav_file in indir.glob("*.wav"):
        # convert the wav so MFA can read it
        wav = AudioSegment.from_wav(str(wav_file))
        out_wav_name = outdir / wav_file.name
        out_txt_name = outdir / f"{wav_file.stem}.txt"
        wav.export(out_wav_name, format="wav", parameters=AD_PARAMS)

        # use the same output wav file with whisper
        res = model.transcribe(out_wav_name, language="en")
        text = clean_sentence(res["text"])
        text = fix_nonwords(text)

        with open(out_txt_name, "w") as of:
            of.write(text + '\n')


if __name__ == '__main__':
        main()
