# coding=utf-8
# Copyright 2021 The TensorFlow Datasets Authors and the HuggingFace Datasets Authors.
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
import json
import os

import datasets
from datasets.tasks import AutomaticSpeechRecognition


_DESCRIPTION = """\
This database was created by Nordic Language Technology for the development of automatic speech recognition and dictation in Swedish. In this updated version, the organization of the data have been altered to improve the usefulness of the database.

In the original version of the material, the files were organized in a specific folder structure where the folder names were meaningful. However, the file names were not meaningful, and there were also cases of files with identical names in different folders. This proved to be impractical, since users had to keep the original folder structure in order to use the data. The files have been renamed, such that the file names are unique and meaningful regardless of the folder structure. The original metadata files were in spl format. These have been converted to JSON format. The converted metadata files are also anonymized and the text encoding has been converted from ANSI to UTF-8.
"""

_URL = "https://www.nb.no/sprakbanken/en/resource-catalogue/oai-nb-no-sbr-56/"


_JSON_URL = "https://www.nb.no/sbfil/talegjenkjenning/16kHz_2020/se_2020/ADB_SWE_0467.tar.gz"


_AUDIO_URLS = [
    "https://www.nb.no/sbfil/talegjenkjenning/16kHz_2020/se_2020/lydfiler_16_1.tar.gz",
    "https://www.nb.no/sbfil/talegjenkjenning/16kHz_2020/se_2020/lydfiler_16_2.tar.gz"
]


_REGIONS = [
    "Dalarna med omnejd",
    "Göteborg med omnejd",
    "Mellansverige",
    "Norrland",
    "Östergötland",
    "Östra sydsverige",
    "Stockholm med omnejd",
    "Västergötland",
    "Västra sydsverige",
    "Västsverige",
    "Unspecified"
]

_SEX = [
    "Male",
    "Female",
    "Unspecified"
]

class NSTDataset(datasets.GeneratorBasedBuilder):
    """NST Dataset for ASR"""

    VERSION = datasets.Version("1.1.0")

    BUILDER_CONFIGS = [
        datasets.BuilderConfig(name="speech", version=VERSION, description="Data for speech recognition"),
#        datasets.BuilderConfig(name="dialects", version=VERSION, description="Data for dialect classification"),
    ]

    def _info(self):
        features = datasets.Features(
            {
                "speaker_id": datasets.Value("string"),
                "age": datasets.Value("string"),
                "gender": datasets.ClassLabel(names=_SEX),
                "region_of_birth": datasets.ClassLabel(names=_REGIONS),
                "region_of_youth": datasets.ClassLabel(names=_REGIONS),
                "text": datasets.Value("string"),
                "path": datasets.Value("string"),
                "audio": datasets.Audio(sampling_rate=16_000)
            }
        )

        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=features,
            supervised_keys=None,
            homepage=_URL,
            task_templates=[
                AutomaticSpeechRecognition(audio_file_path_column="path", transcription_column="text")
            ],
        )

    # split is hardcoded to 'train' for now; there is a test set, but
    # it has not been modernised
    def _split_generators(self, dl_manager):
        if hasattr(dl_manager, 'manual_dir'):
            data_dir = os.path.abspath(os.path.expanduser(dl_manager.manual_dir))
            JSON_FILE = _JSON_URL.split("/")[-1]
            AUDIO_FILES = [
                os.path.join(data_dir, a.split("/")[-1]) for a in _AUDIO_URLS
            ]
            json_dir = dl_manager.extract(os.path.join(data_dir, JSON_FILE))
            audio_dirs = dl_manager.extract(AUDIO_FILES)
        else:
            json_dir = dl_manager.download_and_extract(_JSON_URL)
            audio_dirs = dl_manager.download_and_extract(_AUDIO_URLS)
        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
                gen_kwargs={
                    "split": "train",
                    "json_dir": json_dir,
                    "audio_dirs": audio_dirs,
                },
            ),
        ]

    def _generate_examples(
        self, split, json_dir, audio_dirs
    ):
        """Yields examples as (key, example) tuples. """
        json_path = Path(json_dir)
        for json_filename in json_path.glob("*.json"):
            with open(json_filename) as json_file:
                data = json.load(json_file)
                speaker_data = _get_speaker_data(data["info"])
                pid = data["pid"]
                if "val_recordings" not in data:
                    continue
                for recording in data["val_recordings"]:
                    bare_path = recording['file'].replace(".wav", "")
                    text = recording["text"]
                    lang_part = pid[0:2]
                    for num in ["1", "2"]:
                        tar_path = f"{lang_part}/{pid}/{pid}_{bare_path}-{num}.wav"
                        for adir in audio_dirs:
                            fpath = Path(adir) / tar_path
                            if fpath.exists():
                                with open(fpath, "rb") as audiofile:
                                    yield str(fpath), {
                                        "speaker_id": speaker_data["speaker_id"],
                                        "age": speaker_data["age"],
                                        "gender": speaker_data["gender"],
                                        "region_of_birth": speaker_data["region_of_birth"],
                                        "region_of_youth": speaker_data["region_of_youth"],
                                        "text": text,
                                        "path": str(fpath),
                                        "audio": {
                                            "path": str(fpath),
                                            "bytes": audiofile.read()
                                        }
                                    }


def _get_speaker_data(data):
    out = {}
    if "Age" in data:
        if data["Age"] == "":
            out["age"] = "Unspecified"
        else:
            out["age"] = data["Age"]
    else:
        out["age"] = "Unspecified"

    if "Region_of_Birth" in data:
        if data["Region_of_Birth"] == "":
            out["region_of_birth"] = "Unspecified"
        elif data["Region_of_Birth"] not in _REGIONS:
            print("Unknown option for Region_of_Birth: " + data["Region_of_Birth"])
            out["region_of_birth"] = "Unspecified"
        else:
            out["region_of_birth"] = data["Region_of_Birth"]
    else:
        out["region_of_birth"] = "Unspecified"

    if "Region_of_Youth" in data:
        if data["Region_of_Youth"] == "":
            out["region_of_youth"] = "Unspecified"
        elif data["Region_of_Youth"] not in _REGIONS:
            print("Unknown option for Region_of_Youth: " + data["Region_of_Youth"])
            out["region_of_youth"] = "Unspecified"
        else:
            out["region_of_youth"] = data["Region_of_Youth"]
    else:
        out["region_of_youth"] = "Unspecified"

    if "Speaker_ID" in data:
        if data["Speaker_ID"] == "":
            out["speaker_id"] = "Unspecified"
        else:
            out["speaker_id"] = data["Speaker_ID"]
    else:
        out["speaker_id"] = "Unspecified"

    if 'Sex' in data:
        if data["Sex"] == "":
            out["gender"] = "Unspecified"
        elif data["Sex"] not in _SEX:
            print("Unknown option for Sex: " + data["Sex"])
            out["gender"] = "Unspecified"
        else:
            out["gender"] = data["Sex"]
    else:
        out["gender"] = "Unspecified"

    return out

