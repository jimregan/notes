# coding=utf-8
# Copyright 2021 The TensorFlow Datasets Authors and the HuggingFace Datasets Authors.
# Copyright 2021 Phonetics and Speech Laboratory, Trinity College, Dublin
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
import re

import datasets

import xml.etree.ElementTree as ET

_DESCRIPTION = """\
Builds a dataset from a directory containing utterance XML files.
If you're not in the TCD phonetics lab, this is of no use to you.
"""

logger = datasets.utils.logging.get_logger(__name__)


class UtteranceXMLDataset(datasets.GeneratorBasedBuilder):
    """Speech dataset from data annotated with utternance XML."""

    VERSION = datasets.Version("1.1.0")

    BUILDER_CONFIGS = [
        datasets.BuilderConfig(name="utterance", version=VERSION),
    ]

    def _info(self):
        features = datasets.Features(
            {
                "file_id": datasets.Value("string"),
                "words": datasets.Value("string"),
                "phonemes": datasets.Sequence(datasets.Value("string")),
                "audio": datasets.Value("string"),
                "dialect": datasets.Value("string"),
                "language": datasets.Value("string"),
                "speaker_id": datasets.Value("string"),
                "audio_set": datasets.Value("string")
            }
        )

        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=features,
            supervised_keys=None,
        )

    def _split_generators(self, dl_manager):
        """Returns SplitGenerators."""
        manual_dir = os.path.abspath(os.path.expanduser(dl_manager.manual_dir))

        if not os.path.exists(manual_dir):
            raise FileNotFoundError(
                "{} does not exist. Make sure you insert a manual dir via `datasets.load_dataset('phonlab-tcd/utterance-xml', data_dir=...)` with the path to the corpus directory".format(
                    manual_dir
                )
            )

        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
                gen_kwargs={
                    "data_dir": manual_dir,
                    "split": "train",
                },
            ),
        ]

    def _generate_examples(
        self, data_dir, split
    ):
        """ Yields examples as (key, example) tuples. """
        matcher = re.match(".*/([a-z]{3})_ga_(ul|mu|co)[_/](.*)/?$", data_dir)
        matcher2 = re.match(".*/ga_(UL|MU|CP)/([a-z]{3})/([^/]*)/?$", data_dir)
        matcher_en = re.match(".*/([a-z]{3})_en_ie", data_dir)
        if matcher:
            speaker_id = matcher.group(1)
            language = "ga"
            dialect = matcher.group(2)
            audio_set = matcher.group(3)
        elif matcher2:
            speaker_id = matcher2.group(2)
            language = "ga"
            dialect = matcher2.group(1).lower()
            audio_set = matcher2.group(3)
        elif matcher_en:
            language = "en"
            dialect = "ie"
            speaker_id = matcher_en.group(1)
            audio_set = f"{speaker_id}_en_ie"
        elif "mul_ga_msf" in data_dir:
            language = "ga"
            dialect = "mu"
            speaker_id = "mul"
            audio_set = "msf"
        else:
            raise Exception(f"{data_dir} {type(data_dir)} doesn't look like a valid path")

        dd_path = Path(data_dir)
        xml_path = dd_path / "xml"
        if not xml_path.is_dir():
            xml_path = dd_path / "xmlproc"

        _AUDIO = ["wav", "wav16", "wav44", "wav_trimmed", "wav16_trimmed", "wav44_trimmed", "ogg"]

        _id = 1
        for xmlfile in xml_path.glob("*.xml"):
            utt = from_xml(xmlfile)
            words = utt_to_words(utt)
            phonemes = utt_to_phonemes(utt)
            assert len(words) == len(phonemes)
            file_id = xmlfile.stem

            audio = ""
            for wd in _AUDIO:
                try_path = dd_path / wd
                ext = "ogg" if wd == "ogg" else "wav"
                stem = xmlfile.stem
                audio = try_path / f"{stem}.{ext}"
                if audio.is_file():
                    break

            if audio == "":
                logger.info("failed to find audio to match XML: %s", xmlfile)
                continue

            for pair in zip(words, phonemes):
                yield _id, {
                    "speaker_id": speaker_id,
                    "file_id": file_id,
                    "audio": str(audio),
                    "phonemes": pair[1],
                    "words": irish_lc(" ".join(pair[0])),
                    "language": language,
                    "dialect": dialect,
                    "audio_set": audio_set
                }
                _id += 1


class Utterance:
  def __init__(self, input, sentences):
    self.input = input
    self.sentences = sentences


class Sentence:
  def __init__(self, input, tokens):
    self.input = input
    self.tokens = tokens


class Token:
  def __init__(self, input, words):
    self.input = input
    self.words = words


class Word:
    def __init__(self, input, source, syllables):
        self.input = input
        self.source = source
        self.syllables = syllables
        if self.syllables is None:
            self.syllables = []
    
    def skippable(self):
        if self.input == "SILENCE_TOKEN":
            return True
        if len(self.syllables) == 1 \
           and len(self.syllables[0].phonemes) == 1 \
           and self.syllables[0].phonemes[0].skippable():
            return True
        return False



class Syllable:
    def __init__(self, stress: int = 0, phonemes = None):
        self.stress = stress
        self.phonemes = phonemes
        if self.phonemes is None:
            self.phonemes = []


class Phoneme:
    def __init__(self, symbol: str = "", end: float = 0.0):
        self.symbol = symbol
        self.end = end

    def skippable(self):
        return self.symbol == "sil"


def from_xml(source):
    tree = ET.parse(source)
    root = tree.getroot()
    if 'input_string' in root.attrib:
        input = root.attrib['input_string']
    else:
        input = ''
    sentences = []
    for sentence in root.findall('./sentence'):
        if 'input_string' in sentence.attrib:
            input = sentence.attrib['input_string']
        else:
            input = ''
        tokens = []
        for token in sentence.findall('./token'):
            if 'input_string' in token.attrib:
                input = token.attrib['input_string']
            else:
                input = ''
            words = []
            for word in token.findall('./word'):
                if 'input_string' in word.attrib:
                    input = word.attrib['input_string']
                else:
                    input = ""
                if 'trans_source' in word.attrib:
                    source = word.attrib['trans_source']
                else:
                    source = ""
                syllables = []
                for syllable in word.findall('./syllable'):
                    phonemes = []
                    if 'stress' in syllable.attrib:
                        if syllable.attrib['stress'] == 'None':
                            stress = 0
                        else:
                            stress = int(syllable.attrib['stress'])
                    else:
                        stress = 0
                    for phoneme in syllable.findall('./phoneme'):
                        if 'symbol' in phoneme.attrib:
                            symbol = phoneme.attrib['symbol']
                        else:
                            symbol = ''
                        if 'end' in phoneme.attrib:
                            end = float(phoneme.attrib['end'])
                        else:
                            symbol = 0.0
                        phonemes.append(Phoneme(symbol, end))
                    syllables.append(Syllable(stress, phonemes))
                words.append(Word(input, source, syllables))
            tokens.append(Token(input, words))
        sentences.append(Sentence(input, tokens))
    return Utterance(input, sentences)


def is_punct(tok):
    return tok in [".", ","]


def utt_to_words(utterance: Utterance):
    sentences = []
    for sentence in utterance.sentences:
        words = []
        for token in sentence.tokens:
            for word in token.words:
                if word.skippable():
                    continue
                else:
                    words.append(word.input)
        sentences.append(words)
    return sentences


def utt_to_phonemes(utterance: Utterance):
    sentences = []
    for sentence in utterance.sentences:
        phonemes = []
        for token in sentence.tokens:
            for word in token.words:
                for syllable in word.syllables:
                    for phoneme in syllable.phonemes:
                        if phoneme.skippable():
                            continue
                        else:
                            phonemes.append(phoneme.symbol)
        sentences.append(phonemes)
    return sentences


def _irish_lc_word(word: str) -> str:
    if word[0:1] in ["n", "t"] and word[1:2] in "AEIOUÁÉÍÓÚ":
        return word[0:1] + "-" + word[1:].lower()
    else:
        return word.lower()


def irish_lc(string: str) -> str:
    return " ".join(list(map(_irish_lc_word, string.split(" "))))
