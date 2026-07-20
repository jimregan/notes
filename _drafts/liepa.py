# -*- coding: utf-8 -*-
import pympi
from pathlib import Path
from pydub import AudioSegment

DATAPATH = "/mnt/cloud/lithuanian-asr/data"

def get_eaf_data(filename):
    filepath = Path(filename)
    base = filepath.stem
    eaf = pympi.Elan.Eaf(filename)
    tiers = []

    def is_simple_layout(tiers):
        if len(tiers) == 1 and 'speech' in tiers:
            return True
        elif len(tiers) == 2 and 'speech' in tiers and 'noise' in tiers:
            return True
        elif len(tiers) == 3 and 'speech' in tiers and 'noise' in tiers and 'ss' in tiers:
            return True
        else:
            return False

    if is_simple_layout(eaf.tiers):
        tiernames = ['speech']
        simple = True
    else:
        skip = ['noise', 'ss']
        tiernames = [a for a in eaf.tiers.keys() if a not in skip]
        simple = False

    for tiername in tiernames:
        for tier in eaf.tiers[tiername][0].keys():
            current = {}
            id = f"{base}_{tier}"
            if not simple:
                id = f"{base}_{tiername}_{tier}"
            current["id"] = id
            data = eaf.tiers[tiername][0][tier]
            current["start"] = eaf.timeslots[data[0]]
            current["end"] = eaf.timeslots[data[1]]
            current["text"] = data[2].replace("\t", " ").replace("\n", " ").strip()
            if current["text"] != "":
                tiers.append(current)

    return tiers

def write_split_wavs(outdir, filename, data):
    outpath = Path(outdir)
    original = AudioSegment.from_wav(filename)
    for piece in data:
        outfile = outpath / f"{piece['id']}.wav"
        audio = original[piece["start"]:piece["end"]]
        audio.export(str(outfile), format="wav")

def append_to_tsv(tsv_file, data):
    with open(tsv_file, "a") as f:
        for item in data:
            f.write(f"{item['id']}\t{item['text']}\n")

for eaf_file in Path(DATAPATH).glob("*.eaf"):
    data = get_eaf_data(eaf_file)
    wav_file = str(eaf_file).replace(".eaf", ".wav")
    write_split_wavs("/tmp/liepa-split", wav_file, data)
    append_to_tsv("/mnt/cloud/liepa-split/text.tsv", data)
