# -*- coding: utf-8 -*-
# Copyright 2022 Jim O'Regan
# Licence: Apache 2.0

# This was originally generated from a Jupyter notebook,
# so it could be much, much neater.

from datasets import load_dataset, concatenate_datasets
import soundfile as sf

PAD = "<pad>"
UNK = "<unk>"
SIL = "<sil>"
SPN = "<spn>"

VOCAB_ITEMS ="""
AA
AE
AH
AO
AW
AX
AY
EH
ER
EY
IH
IY
OW
OY
UH
UW
UX
B
CH
D
DH
DX
EL
EM
EN
F
G
HH
JH
K
L
M
N
NG
NX
P
Q
R
S
SH
T
TH
V
W
WH
Y
Z
ZH
 
.
,
?
!
"""

_VOCAB_SPLIT = VOCAB_ITEMS.split("\n")[1:-1]

VOCAB = {e[1]:e[0] for e in enumerate(_VOCAB_SPLIT)}

TIMIT_MAPPING = {
    'ax': 'AH',
    'ax-h': 'AH',
    'axr': 'ER',
    'dx': 'T',
    'el': ['AH', 'L'],
    'em': ['AH', 'M'],
    'en': ['AH', 'N'],
    'eng': ['IH', 'NG'],
    'hv': 'HH',
    'ix': 'IH',
    'nx': ['N', 'T'],
    'pau': '<sil>',
    'epi': '<sil>',
    'ux': 'UW'
}
TIMIT_IGNORE = ['bcl', 'dcl', 'gcl', 'kcl', 'pcl', 'tcl']
TIMIT_DISCARD = ['dx', 'nx', 'q']

def map_timit_to_cmudict(timit):
    output = []

    start = 1 if timit[0] == "h#" else 0
    end = -1 if timit[-1] == "h#" else None
    timit = timit[start:end]

    for phone in timit:
        if phone in TIMIT_MAPPING:
            if type(TIMIT_MAPPING[phone]) == list:
                output += TIMIT_MAPPING[phone]
            else:
                output.append(TIMIT_MAPPING[phone])
        elif phone in TIMIT_IGNORE:
            pass
        else:
            if not phone.upper() in VOCAB:
                print("Invalid phone", phone.upper())
            output.append(phone.upper())
    return output

timit = load_dataset('timit_asr')

def is_discardable(batch):
    for phoneme in batch["phonetic_detail"]["utterance"]:
        if phoneme in TIMIT_DISCARD:
            return False
    return True

timit_filt = timit["train"].filter(lambda eg: is_discardable(eg))

timit_filt2 = timit["test"].filter(lambda eg: is_discardable(eg))

timit = concatenate_datasets([timit_filt, timit_filt2])

MAX_TOKENS = 1120000

BASE = timit[0]["file"].split("/data/")[0] + "/data/"

with open("train_timit.tsv", "w") as manifest, open("train_timit.ltr", "w") as transcript:
    manifest.write(BASE + "\n")
    for item in timit:
        frames, sr = sf.read(item["file"])
        manifest.write(f"{item['file'].replace(BASE, '')}\t{len(frames)}\n")
        utt = item['phonetic_detail']['utterance']
        mapped = map_timit_to_cmudict(utt)
        transcript.write(f"{' '.join(mapped)}\n")