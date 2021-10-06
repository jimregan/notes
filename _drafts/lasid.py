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

import sys
from pathlib import Path

import datasets

try:
    import icu
except ImportError:
    sys.exit("ICU not found (hint: pip install pyicu)")

_DESCRIPTION = """\
Linguistic Atlas and Survey of Irish Dialects, volume 1
"""

_CITATION = """\
@book{wagner1958linguistic,
  title={Linguistic Atlas and Survey of Irish Dialects: Introduction, 300 maps.},
  author={Wagner, H.},
  number={v. 1},
  year={1958},
  publisher={Dublin Institute for Advanced Studies}
}

@phdthesis{mckendry1982computer,
  title={Computer-aided contributions to the study of Irish dialects},
  author={McKendry, Eugene},
  year={1982},
  school={Queen's University Belfast}
}

@article{mckendry1998linguistic,
  title={The Linguistic Atlas and Survey of Irish Dialects (LASID) and the Computer},
  author={McKendry, Eugene},
  journal={Studia Celtica Upsaliensia},
  volume={2},
  pages={345--354},
  year={1998}
}
"""

_DATA_URL = "https://www3.smo.uhi.ac.uk/oduibhin/oideasra/lasid/lasid.zip"

LASID_ICU = """
\x07 → ᵏ ;
\\\t → ᵉ ; # \x09
\x0e → ᴵ ;
\x11 → ʰ ;
\x12 → ⁱ ;
\x13 → ᵒ ;
\x14 → ᵒ̤ ;
\x15 → ʳ ;
\x16 → ˢ ;
\x17 → ᶴ ;
\x18 → ᵗ ;
\x19 → ᵘ ;
\x1a → ᵘ̯ ;
\x1c → ᵛ ;
\x1d → ʷ ;
\x1e → ᶾ ;
\x1f → ᵊ ;
\# → ᶠ ; # \x23
\$ → ᵠ ; # \x24
\% → ᵍ ; # \x25
\& → ᵞ ; # \x26 ˠ for IPA
\' → ’ ; # \x27
\: → ː ; # \x3a
\< → ⁱ̈ ; # \x3c
\= → ⁱ̯ ; # \x3d
\? → ʔ ; # \x3f
\@ → ʲ ; # \x40
E → ᴇ ; # \x45
I → ɪ ; # \x49
L → ʟ ;
N → ɴ ;
R → ʀ ;
\^ → ᵐ ; # \x5e
\_ → ǰ ; # crane, 021 # \x5f
\` → ɛ̀̃ ; # limekiln, 078: \x60
\| → ⁿ ; # lamb, 055: \x7c
\~ → ᵑ ; # dreaming, 078; maybe ⁿ̠ ? # \x7e
\x7f → ᴇ̃ ;
\x80 → φ ; # ɸ
\x81 → ü ;
\x83 → ɛ \u0300 ;
\x84 → è \u0323 ; # FIXME
\\\x85 → è̃ ; # this is �, so it needs to be escaped
\x86 → ũ̜ ; # lamb, 038
\x87 → u̜ ; # finger-nails, 043
\x88 → ʈ ; # looks like t̜ : toothache, 033
\x89 → ᵃ ; # eggs, 066
\x8a → è ;
\x8b → ï ;
\x8c → ɔ̜̃ ; # grandmother, 007
\x8d → ɔ̜ ;
\x8e → ɔ̆ ; # before i go, 078
\x8f → õ̜ ; # as cute, 062
\x91 → æ ;
\x92 → o̜ ;
\x93 → ɖ ;
\x94 → ö ;
\x95 → ɑ̜̃ ;
\x96 → û ; # milking, 067
\x97 → ɑ \u0323 ; # FIXME (maybe α̩  or ɑ̜ ?)
\x98 → v̠ ;
\x99 → t̠ ; # toothache, 021
\x9a → r̠ ;
\x9b → ø ;
\x9c → ɴ̠ ; # sick, 034
\x9d → ŋ̠ ; # grazing, 002
\x9e → n̠ ;
\x9f → l̠ ; # plumage, 068
\xa4 → k̠ ; # plumage, 068
\xa5 → g̠ ;
\xa6 → d̠ ; # wedge, 021
\xa7 → ŭ ;
\xa8 → ö̆ ;
\xa9 → ŏ ;
\xaa → ĭ ;
\xab → ɛ̆ ;
\xac → ĕ ;
\xad → o̤ ;
\xae → λ ;
\xaf → ɑ ; # α in the software
\xb0 → ɔ ;
\xb1 → ɑ̆ \u0323 ; # FIXME
\xb2 → ə ;
\xb4 → ᵈ ; # tail, 007
\xb6 → ɑ̆ ; # ᾰ in the software
\xb7 → ă ;
\xb8 → λ \u0323 ; # FIXME
\xb9 → ɛ ;
\xba → ʃ \u030c ; # calling, 067
\xbb → š ;
\xbc → ř ;
\xbd → ɑ̃ ;
\xbe → ẽ ; # tied, 88N
\xc1 → ′ ; # superscript prime
\xc5 → ᴍ̠ ; # fart, 071
\xc6 → ã ; # calf, 046
\xc7 → t \u0323 ; # probably t̞
\xc8 → λ̯ ; # mane, 067
\xc9 → o̯ ; # hare, 088
\xca → Ɫ ; # loaf, 001
\xcb → ɫ ; # loaf, 003
\xcc → m̥ ; # awake, 001
\xcd → ʀ̥ ; # thieving, 003
\xce → ˈ ;
\xcf → ˌ ; # cattle, 040
\xd0 → ð ; # boar, 88N
\xd1 → s \u0323 ; # FIXME # slime 008
\xd2 → r \u0323 ; # FIXME # bulls 067
\xd3 → ɪ̆ ; # suit of clothes 039
\xd4 → ᴇ̀ ;
\xd5 → p \u0323 ; # FIXME # castrating 053
\xd7 → ɪ̃ ; # slime, 007
\xd8 → ɪ̈ ; # calf 027
\xdb → o \u0323 ; # FIXME # cow 028
\xdc → ŋ \u0323 ; # FIXME # tied 078
\xdd → ö̤ ;
\xde → k \u0323 ; # FIXME
\xdf → i \u0323 ; # FIXME # sick 069
\xe1 → g \u0323 ; # FIXME
\xe2 → e \u0323 ; # FIXME
\xe3 → d \u0323 ; # FIXME # agut 052
\xe4 → õ ; # I shall tie 062
\xe5 → b \u0323 ; # FIXME # castrating 071
\xe6 → ɑ̃ \u0323 ; #FIXME # barking 049
\xe7 → ɑ \u0323 ; # FIXME # slime 008
\xe8 → ỹ ;
\xea → λ̃ ;
\xeb → ü̃ ; # churn-dash, 011
\xec → ũ ;
\xed → ɔ̃ ; # cow 074
\xee → õ̤ ; # barking 055
\xef → ′ ;
\xf0 → ″ ;
\xf1 → ö̤̃ ; # dreaming, 078
\xf2 → ö̃ ; # sheep shears 074
\xf3 → ï̃ ; # churn-dash, 034
\xf4 → ĩ ; # sick 001
\xf5 → ɣ̃ ; # tied 075
\xf6 → ɛ̃ ; # tied 067
\xf7 → n̥ ; # awake, 059
\xf8 → r̥ ; # slime 002
\xf9 → ʃ ;
\xfb → · ; # slime 058
\xfa → ɣ ;
\xfc → χ ; # limekiln, 080
\xfd → ʒ ; # sheep shears 054
\xfe → ŋ ;
"""

LASID_TITLES_ICU = """
\xb5 → Á ;
\xd6 → Í ;
\x90 → É ;
\xe0 → Ó ;
\xe9 → Ú ;
"""

def transliterator_from_rules(name, rules):
    fromrules = icu.Transliterator.createFromRules(name, rules)
    icu.Transliterator.registerInstance(fromrules)
    return icu.Transliterator.createInstance(name)

LASID = transliterator_from_rules('lasid_icu', LASID_ICU)
TITLES = transliterator_from_rules('lasid_titles', LASID_TITLES_ICU)

def translit_phon(text):
  # could have been any 8-bit encoding
  return LASID.transliterate(text.decode('ISO-8859-1').rstrip())

def translit_irish(text, spaces=True):
  return TITLES.transliterate(text.decode('ISO-8859-1').rstrip())


class LasidDataset(datasets.GeneratorBasedBuilder):
    """Scraper dataset for LASID."""

    VERSION = datasets.Version("1.1.0")

    BUILDER_CONFIGS = [
        datasets.BuilderConfig(name="lasid"),
    ]

    def _info(self):
        features = datasets.Features(
            {
                "english": datasets.Value("string"),
                "irish": datasets.Value("string"),
                "map_id": datasets.Value("string"),
                "place_ids": datasets.Sequence(datasets.Value("string")),
                "transcripts": datasets.Sequence(datasets.Value("string")),
            }
        )

        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=features,
            supervised_keys=None,
            citation=_CITATION
        )

    def _split_generators(self, dl_manager):
        """Returns SplitGenerators."""
        dl_path = dl_manager.download_and_extract(_DATA_URL)
        infile = f"{dl_path}/mapdata.dat"

        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
                gen_kwargs={
                    "split": "train",
                    "data_file": infile
                },
            ),
        ]

    def _generate_examples(
        self, split, data_file
    ):
        """ Yields examples as (key, example) tuples. """
        data = process_lasid(data_file)
        _id = 1
        for map in data.keys():
            item = data[map]
            place_ids = list(item["data"])
            transcripts = [item["data"][a] for a in place_ids]

            yield _id, {
                "english": item.get("en", ""),
                "irish": item.get("ga", ""),
                "map_id": item.get("id", ""),
                "place_ids": place_ids,
                "transcripts": transcripts
            }
            _id += 1


def process_lasid(filename):
    data = {}
    cur = {}
    with open(filename, "rb") as file:
        for line in file.readlines():
            if b'{M' in line:
                prev_en = en
                text = line.decode('ISO-8859-1').rstrip()
                id = text[3:7].strip()
                en = text[7:-1].strip()
                tmp = {}
                tmp['en'] = prev_en
                tmp['id'] = id
                tmp['ga'] = ga
                tmp['data'] = cur
                data[id] = tmp
                cur = {}
            elif b'{F' in line:
                raw = translit_irish(line, False)
                ga = raw[3:-1].strip()
            elif line.decode('ISO-8859-1')[0:1].isnumeric():
                pid = line.decode('ISO-8859-1')[0:3]
                ptext = translit_phon(line[3:-1], False)
                if ptext[-1] == '*':
                    ptext = ptext[0:-1]
                cur[pid] = ptext.strip()
    return data
