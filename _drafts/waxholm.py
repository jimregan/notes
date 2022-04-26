# coding=utf-8
# Copyright 2021 The TensorFlow Datasets Authors and the HuggingFace Datasets Authors.
# Copyright 2022 Jim O'Regan
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
"""Datasets loader for Waxholm speech corpus"""

import os
import soundfile as sf

import datasets
from datasets.tasks import AutomaticSpeechRecognition


TRAIN_LIST = "alloktrainfiles"
TEST_LIST = "testfiles"


_DESCRIPTION = """\
The Waxholm corpus was collected in 1993 - 1994 at the department of Speech, Hearing and Music (TMH), KTH.
"""


_CITATION = """
@article{bertenstam1995spoken,
  title={Spoken dialogue data collected in the {W}axholm project},
  author={Bertenstam, Johan and Blomberg, Mats and Carlson, Rolf and Elenius, Kjell and Granstr{\"o}m, Bj{\"o}rn and Gustafson, Joakim and Hunnicutt, Sheri and H{\"o}gberg, Jesper and Lindell, Roger and Neovius, Lennart and Nord, Lennart and de~Serpa-Leitao, Antonio and Str{\"o}m, Nikko},
  journal={STH-QPSR, KTH},
  volume={1},
  pages={49--74},
  year={1995}
}
@inproceedings{bertenstam1995waxholm,
  title={The {W}axholm application database.},
  author={Bertenstam, J and Blomberg, Mats and Carlson, Rolf and Elenius, Kjell and Granstr{\"o}m, Bj{\"o}rn and Gustafson, Joakim and Hunnicutt, Sheri and H{\"o}gberg, Jesper and Lindell, Roger and Neovius, Lennart and Nord, Lennart and de~Serpa-Leitao, Antonio and Str{\"o}m, Nikko},
  booktitle={EUROSPEECH},
  year={1995}
}"""


_URL = "http://www.speech.kth.se/waxholm/waxholm2.html"


class WaxholmDataset(datasets.GeneratorBasedBuilder):
    """Dataset script for Waxholm."""

    VERSION = datasets.Version("1.1.0")

    BUILDER_CONFIGS = [
        datasets.BuilderConfig(name="waxholm"),
    ]

    def _info(self):
        features = datasets.Features(
            {
                "id": datasets.Value("string"),
                "text": datasets.Value("string"),
                "audio": datasets.Audio(sampling_rate=16_000)
            }
        )

        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=features,
            supervised_keys=None,
            homepage=_URL,
            citation=_CITATION,
            task_templates=[
                AutomaticSpeechRecognition(audio_file_path_column="path", transcription_column="text")
            ],
        )

    def _split_generators(self, dl_manager):
        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
                gen_kwargs={
                    "split": "train",
                    "files": TRAIN_LIST
                },
            ),
            datasets.SplitGenerator(
                name=datasets.Split.TEST,
                gen_kwargs={
                    "split": "test",
                    "files": TEST_LIST
                },
            ),
        ]

    def _generate_examples(self, split, files):
        with open(f"./waxholm/{files}") as input_file:
            for line in input_file.readlines():
                line = line.strip()
                parts = line.split(".")
                subdir = parts[0]
                audio_file = f"./waxholm/scenes_formatted/{subdir}/{line}"
                if not os.path.exists(audio_file):
                    print(f"{audio_file} does not exist: skipping")
                    continue
                text_file = f"{audio_file}.mix"
                if not os.path.exists(text_file):
                    print(f"{text_file} does not exist: skipping")
                    continue
                mix = Mix(text_file)
                samples, sr = smp_read_sf(audio_file)
                yield line, {
                    "id": line,
                    "text": mix.text,
                    "audio": {
                        "path": audio_file,
                        "bytes": samples.tobytes()
                    }
                }


def fix_text(text: str) -> str:
    replacements = text.maketrans("{}|\\", "äåöÖ")
    return text.translate(replacements)


class FR:
    def __init__(self, text: str):
        if not text.startswith("FR"):
            raise IOError("Unknown line type (does not begin with 'FR'): " + text)
        parts = text.split("\t")
        if len(parts) == 5:
            self.type = 'B'
        if len(parts) == 4:
            self.type = 'I'
        if len(parts) == 3:
            self.type = 'E'
            if parts[1].strip() != "OK":
                raise IOError("Unexpected line: " + text)
        self.frame = parts[0][2:].strip()
        if len(parts) > 3:
            self.phone_type = parts[1].strip()[0:1]
            self.phone = parts[1].strip()[1:]
            if not parts[2].strip().startswith(">pm "):
                raise IOError("Unexpected line: " + text)
            self.pm_type = parts[2].strip()[4:5]
            self.pm = parts[2].strip()[5:]
        if len(parts) == 5:
            if not parts[3].strip().startswith(">w "):
                raise IOError("Unexpected line: " + text)
            self.word = fix_text(parts[3].strip()[3:])
        if parts[-1].strip().endswith(" sec"):
            self.seconds = parts[-1].strip()[0:-4]

    def __repr__(self):
        parts = []
        parts.append(f"type: {self.type}")
        parts.append(f"frame: {self.frame}")
        if self.type != 'E':
            parts.append(f"phone: {self.phone}")
        if 'word' in self.__dict__:
            parts.append(f"word: {self.word}")
        if 'pm_type' in self.__dict__:
            parts.append(f"pm_type: {self.pm_type}")
        if 'pm' in self.__dict__:
            parts.append(f"pm: {self.pm}")
        parts.append(f"sec: {self.seconds}")
        return f"FR(" + ", ".join(parts) + ")"


class Mix():
    def __init__(self, filepath: str):
        self.fr = []
        with open(filepath) as inpf:
            saw_text = False
            saw_phoneme = False
            saw_labels = False
            for line in inpf.readlines():
                if line.startswith("Waxholm dialog."):
                    self.filepath = line[15:].strip()
                if line.startswith("TEXT:"):
                    saw_text = True
                if saw_text:
                    self.text = fix_text(line.strip())
                    saw_text = False
                if line.startswith("FR "):
                    if saw_labels:
                        saw_labels = False
                    self.fr.append(FR(line))
                if line.startswith("Labels: "):
                    self.labels = line[8:].strip()
                    saw_labels = True
                if saw_labels and line.startswith(" "):
                    self.labels += line.strip()


def smp_probe(filename: str) -> bool:
    with open(filename, "rb") as f:
        return f.read(9) == b"file=samp"


def smp_headers(filename: str):
    with open(filename, "rb") as f:
        f.seek(0)
        raw_headers = f.read(1024)
        raw_headers = raw_headers.rstrip(b'\x00')
        asc_headers = raw_headers.decode("ascii")
        asc_headers.rstrip('\x00')
        tmp = [a for a in asc_headers.split("\r\n")]
        back = -1
        while abs(back) > len(tmp) + 1:
            if tmp[back] == '=':
                break
            back -= 1
        tmp = tmp[0:back-1]
        return dict(a.split("=") for a in tmp)


def smp_read_sf(filename: str):
    headers = smp_headers(filename)
    if headers["msb"] == "last":
        ENDIAN = "LITTLE"
    else:
        ENDIAN = "BIG"

    data, sr = sf.read(filename, channels=int(headers["nchans"]),
                       samplerate=16000, endian=ENDIAN, start=512,
                       dtype="int16", format="RAW", subtype="PCM_16")
    return (data, sr)


def _write_wav(filename, arr):
    import wave

    with wave.open(filename, "w") as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(16000)
        f.writeframes(arr)


#arr, sr = smp_read_sf("/Users/joregan/Playing/waxholm/scenes_formatted//fp2060/fp2060.pr.09.smp")
#write_wav("out.wav", arr)
