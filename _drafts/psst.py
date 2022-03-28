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

from email.mime import audio
from pathlib import Path
import os
import csv

import datasets
from datasets.tasks import AutomaticSpeechRecognition



_DESCRIPTION = """
The PSST Challenge focuses on a technically-challenging and clinically
important task—high-accuracy automatic phoneme recognition of disordered
speech, in a diagnostic context—which has applications in many different
areas relating to speech and language disorders.
"""

class PSSTDataset(datasets.GeneratorBasedBuilder):
    """PSST Dataset"""

    VERSION = datasets.Version("1.1.0")

    BUILDER_CONFIGS = [
         datasets.BuilderConfig(name="psst"),
    ]

    # utterance_id    session test    prompt  transcript      correctness     aq_index        duration_frames filename
    def _info(self):
        features = datasets.Features(
            {
                "utterance_id": datasets.Value("string"),
                "session": datasets.Value("string"),
                "test": datasets.Value("string"),
                "prompt": datasets.Value("string"),
                "transcript": datasets.Value("string"),
                "correctness": datasets.Value("bool"),
                "aq_index": datasets.Value("float"),
                "duration_frames": datasets.Value("uint64"),
                "audio": datasets.Audio(sampling_rate=16_000)
            }
        )

        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=features,
            supervised_keys=None,
            homepage="https://psst.study/",
            task_templates=[
                AutomaticSpeechRecognition(audio_file_path_column="filename", transcription_column="transcript")
            ],
        )


    def _split_generators(self, dl_manager):
        if hasattr(dl_manager, 'manual_dir') and dl_manager.manual_dir is not None:
            data_dir = os.path.abspath(os.path.expanduser(dl_manager.manual_dir))
        else:
            raise Exception("No path to data specified")
        
        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
                gen_kwargs={
                    "split": "train",
                    "data_dir": data_dir
                },
            ),
            datasets.SplitGenerator(
                name=datasets.Split.VALIDATION,
                gen_kwargs={
                    "split": "valid",
                    "data_dir": data_dir
                },
            ),
        ]

    # utterance_id    session test    prompt  transcript      correctness     aq_index        duration_frames filename
    def _generate_examples(
        self, split, data_dir
    ):
        """Yields examples as (key, example) tuples. """
        data_path = Path(data_dir)
        split_path = data_path / split
        if not split_path.exists():
            raise Exception(f"{split} directory not found ({split_path})")
        utterances = split_path / "utterances.tsv"
        if not utterances.exists():
            raise Exception(f"utterances.tsv not found in {split} directory ({split_path})")
        with open(utterances) as tsvfile:
            data = csv.reader(tsvfile, delimiter='\t')
            for row in data:
                audiopath = split_path / row["filename"]
                if audiopath.exists():
                    with open(audiopath, "rb") as audiofile:
                        yield row["utterance_id"], {
                            "utterance_id": row["utterance_id"],
                            "session": row["session"],
                            "test": row["test"],
                            "prompt": row["prompt"],
                            "transcript": row["transcript"],
                            "correctness": (row["correctness"] == "True"),
                            "aq_index": float(row["aq_index"]),
                            "duration_frames": int(row["duration_frames"]),
                            "audio": {
                                "path": str(audiopath),
                                "bytes": audiofile.read()
                            }                            
                        }
