from pathlib import Path
import datasets
from datasets.tasks import AutomaticSpeechRecognition, AudioClassification
import os


_DESCRIPTION = """
An Emotional Audio-Textual Corpus

The EATD-Corpus is a dataset that consists of audio and text files of 162 volunteers who received counseling.

Training set contains data from 83 volunteers (19 depressed and 64 non-depressed).

Validation set contains data from 79 volunteers (11 depressed and 68 non-depressed).
"""


_URL = "https://github.com/speechandlanguageprocessing/ICASSP2022-Depression"


_CITE = """
@INPROCEEDINGS{9746569,
  author={Shen, Ying and Yang, Huiyu and Lin, Lin},
  booktitle={ICASSP 2022 - 2022 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP)}, 
  title={Automatic Depression Detection: an Emotional Audio-Textual Corpus and A Gru/Bilstm-Based Model}, 
  year={2022},
  pages={6247-6251},
  doi={10.1109/ICASSP43922.2022.9746569}
}
"""


class EATDDataset(datasets.GeneratorBasedBuilder):
    VERSION = datasets.Version("1.1.0")

    BUILDER_CONFIGS = [
        datasets.BuilderConfig(name="speech", version=VERSION, description="Data for speech recognition"),
    ]

    def _info(self):
        features = datasets.Features(
            {
                "audio_raw": datasets.Audio(sampling_rate=16_000),
                "audio": datasets.Audio(sampling_rate=16_000),
                "id": datasets.Value("string"),
                "text": datasets.Value("string"),
                "raw_sds": datasets.Value("int"),
                "sds_score": datasets.Value("float"),
                "label": datasets.ClassLabel(names=["neutral", "negative", "positive"])
            }
        )

        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=features,
            supervised_keys=None,
            homepage=_URL,
            citation=_CITE,
            task_templates=[
                AutomaticSpeechRecognition(audio_column="audio", transcription_column="text"),
                AudioClassification(audio_column="audio", label_column="label")
            ],
        )

    def _split_generators(self, dl_manager):
        if hasattr(dl_manager, 'manual_dir') and dl_manager.manual_dir is not None:
            data_dir = os.path.abspath(os.path.expanduser(dl_manager.manual_dir))
            return [
                datasets.SplitGenerator(
                    name=datasets.Split.TRAIN,
                    gen_kwargs={
                        "split": "train",
                        "data_dir": data_dir,
                    },
                ),
                datasets.SplitGenerator(
                    name=datasets.Split.VALIDATION,
                    gen_kwargs={
                        "split": "valid",
                        "data_dir": data_dir,
                    },
                ),
            ]

    def _generate_examples(
        self, split, data_dir
    ):
        basepath = Path(data_dir)
        prefix = "v" if split == "valid" else "t"
        for dir in basepath.glob(f"{prefix}_*"):
            id = dir.name
            with open(str(dir / "label.txt")) as labelf:
                label = labelf.read().strip()
                if label.endswith(".0"):
                    raw_sds = int(label[:-2])
                else:
                    raw_sds = int(label)
            with open(str(dir / "new_label.txt")) as labelf:
                new_label = labelf.read().strip()
                sds_score = float(new_label)
            for polarity in ["neutral", "negative", "positive"]:
                raw_audio = dir / f"{polarity}.wav"
                proc_audio = dir / f"{polarity}_out.wav"
                text_file = dir / f"{polarity}.txt"
                with open(raw_audio, "rb") as rawf, open(proc_audio, "rb") as procf, open(text_file, "r") as textf:
                    text = textf.read().strip()
                    yield id, {
                        "audio_raw": {
                            "bytes": rawf.read(),
                            "path": str(raw_audio),
                        },
                        "audio": {
                            "bytes": procf.read(),
                            "path": str(proc_audio),
                        },
                        "text": textf.read().strip(),
                        "raw_sds": raw_sds,
                        "sds_score": sds_score,
                        "label": polarity
                    }
