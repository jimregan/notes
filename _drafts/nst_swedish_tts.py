# coding=utf-8
# Copyright 2021 The TensorFlow Datasets Authors and the HuggingFace Datasets Authors.
# Copyright 2023 Jim O'Regan for Språkbanken Tal
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
"""Datasets loader for NST Swedish TTS data"""

import soundfile as sf
import os
from pathlib import Path
import datasets
from datasets.tasks import AutomaticSpeechRecognition



_HEADER = b'PCM44   \x00\x00\x00\x00\x00\x00\x00S'

_AUDIO_URL = "https://www.nb.no/sbfil/talesyntese/sve.ibm.talesyntese.tar.gz"

_DESCRIPTION = """
Database for Swedish speech synthesis, originally produced by Nordic Language Technology AS (NST).
"""

_URL = "https://www.nb.no/sprakbanken/en/resource-catalogue/oai-nb-no-sbr-18/"


def is_pcm(filename) -> bool:
    """
    Check the header of a .pcm file

    Args:
        filename: the file to check

    Returns:
        True is header is present, False otherwise
    """
    with open(filename, "rb") as pcm:
        pcm.seek(0)
        cond = (pcm.read(16) == _HEADER)
        # reset location, just in case
        pcm.seek(0)
        return cond


IGNORE_SENT = [
    "stod man på torget kunde man se huset och det var ingen tvekan om att det dominerade sin omgivning och det rådde knappast heller något tvivel om att det förr i tiden hade väckt en hel del avund känslor som någon enstaka gång fortfarande kunde framkallas hos de äldre",
    "viktor hade skickat ut det innan novell sålde unixware till sco",
    "det gläder oss självklart"
]
IGNORE_ID = [
    "4913",
]
# MAYBE_FIX = {
#     "4913": "en annan gång tar vi ett annat grepp"
# }

def read_with_soundfile(filename):
    return sf.read(filename, channels=2, samplerate=44100, endian="BIG",
                   dtype="int16", format="RAW", subtype="PCM_16", start=16)


class NSTDataset(datasets.GeneratorBasedBuilder):

    VERSION = datasets.Version("1.1.0")

    BUILDER_CONFIGS = [
        datasets.BuilderConfig(name="speech", version=VERSION, description="Data for speech recognition"),
    ]

    def _info(self):
        features = datasets.Features(
            {
                "audio": datasets.Audio(sampling_rate=44_100),
                "pitch_tracker": datasets.Audio(sampling_rate=44_100),
                "text": datasets.Value("string"),
                "file_stem": datasets.Value("string"),
            }
        )

        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=features,
            supervised_keys=None,
            homepage=_URL,
            task_templates=[
                AutomaticSpeechRecognition(audio_column="audio", transcription_column="text")
            ],
        )

    def _split_generators(self, dl_manager):
        if hasattr(dl_manager, 'manual_dir') and dl_manager.manual_dir is not None:
            data_dir = os.path.abspath(os.path.expanduser(dl_manager.manual_dir))
            AUDIO_FILE = os.path.join(data_dir, _AUDIO_URL.split("/")[-1])
            audio_dir = dl_manager.extract(AUDIO_FILE)
        else:
            audio_dir = dl_manager.download_and_extract(_AUDIO_URL)
        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
                gen_kwargs={
                    "split": "train",
                    "audio_dir": audio_dir,
                },
            ),
        ]

    def _generate_examples(
        self, split, audio_dir
    ):
        filepath = Path(audio_dir) / "sw_pcms" / "mf"
        textpath = Path(audio_dir) / "sw_pcms" / "scripts" / "mf" / "sw_all"
        transcripts = {}
        counter = 1
        with open(str(textpath), encoding="latin1") as text:
            for line in text.readlines():
                line = line.strip()
                if line in IGNORE_SENT:
                    if f"{counter:04d}" in IGNORE_ID:
                        counter += 1
                    continue
                else:
                    id = f"sw_all_mf_01_{counter:04d}"
                    transcripts[id] = line
                    counter += 1
        for file in filepath.glob("*.pcm"):
            stem = file.stem
            id = stem.split("_")[-1]
            if is_pcm(str(file)) and not id in IGNORE_ID:
                data, _ = read_with_soundfile(str(file))
                yield stem, {
                    "audio": {
                        "array": data[:, 1],
                        "sampling_rate": 44_100,
                        "path": str(file),
                        "id": stem,
                    },
                    "pitch_tracker": {
                        "array": data[:, 0],
                        "sampling_rate": 44_100,
                        "path": str(file),
                        "id": stem,
                    },
                    "text": transcripts[stem],
                    "file_stem": stem,
                }
                
