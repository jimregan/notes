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

import os
from pathlib import Path
import glob
import re

import datasets
from datasets.tasks import AutomaticSpeechRecognition


_DESCRIPTION = """\
This database was created by Nordic Language Technology for the development of automatic speech recognition and dictation in Swedish. In this updated version, the organization of the data have been altered to improve the usefulness of the database.

In the original version of the material, the files were organized in a specific folder structure where the folder names were meaningful. However, the file names were not meaningful, and there were also cases of files with identical names in different folders. This proved to be impractical, since users had to keep the original folder structure in order to use the data. The files have been renamed, such that the file names are unique and meaningful regardless of the folder structure. The original metadata files were in spl format. These have been converted to JSON format. The converted metadata files are also anonymized and the text encoding has been converted from ANSI to UTF-8.
"""

_URL = "https://www.nb.no/sprakbanken/en/resource-catalogue/oai-nb-no-sbr-56/"

__DATA_URLS = [
    "https://www.nb.no/sbfil/talegjenkjenning/16kHz_2020/se_2020/ADB_SWE_0467.tar.gz",
    "https://www.nb.no/sbfil/talegjenkjenning/16kHz_2020/se_2020/lydfiler_16_1.tar.gz",
    "https://www.nb.no/sbfil/talegjenkjenning/16kHz_2020/se_2020/lydfiler_16_2.tar.gz",
    "https://www.nb.no/sbfil/talegjenkjenning/16kHz_2020/se_2020/lydfiler_16_begge.tar.gz"
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
    "Västsverige"
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
                "speaker_info": datasets.features.Sequence(
                    {
                        "id": datasets.Value("string"),
                        "age": datasets.Value("string"),
                        "gender": datasets.ClassLabel(_SEX),
                        "region_of_birth": datasets.ClassLabel(_REGIONS),
                        "region_of_youth": datasets.ClassLabel(_REGIONS),
                    }
                ),
                "text": datasets.Value("string"),
                "path": datasets.Value("string"),
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

    def _split_generators(self, dl_manager):
        data_dir = dl_manager.download_and_extract(_DATA_URLS)
        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
            ),
        ]