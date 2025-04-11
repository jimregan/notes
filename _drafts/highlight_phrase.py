import json
from pathlib import Path
import re


def load_tsv(filename):
    data = []
    with open(filename) as inf:
        for line in inf:
            parts = line.strip().split("\t")
            data.append({
                "start": float(parts[0]),
                "end": float(parts[1]),
                "word": parts[2]
            })
    return data


def slice_tsv_data(data, start, end):
    ret = []
    for datum in data:
        datum["start"] = float(datum["start"])
        datum["end"] = float(datum["end"])
        if datum["start"] >= start and datum["end"] <= end:
            ret.append(datum)
        elif datum["end"] > end:
            return ret
    return ret


def norm_spaces(text):
    return re.sub("  +", " ", text.strip())


def clean_text2(text):
    nums = {
        "60": "sixty",
        "1": "one",
        "20th": "twentieth",
        "9th": "ninth",
        "5": "five"
    }
    text = norm_spaces(text)
    words = [x.lower().strip(".,;?!") for x in text.split(" ")]
    ret = []
    for word in words:
        if word.startswith("[") and word.endswith("]"):
            continue
        elif word.startswith("{") and word.endswith("}"):
            continue
        word = nums.get(word, word)
        word = word.replace(".", " ").replace(",", " ")
        ret.append(word)
    return " ".join(ret)


def get_indices(needle, haystack, checkpos=True):
    ret = []
    nwords = [x.lower().strip(",?.;:()") for x in needle.split(" ")]
    hwords = [x.lower().strip(",?.;:") for x in haystack.split(" ")]
    nwordspos = nwords[:-1] + [f"{nwords[-1]}'s"]
    nlen = len(nwords)

    for i in range(len(hwords)):
        if hwords[i:i+nlen] == nwords:
            ret.append((i, i+nlen))
        elif checkpos and hwords[i:i+nlen] == nwordspos:
            ret.append((i, i+nlen))
    return ret


TSV_PATH = Path("/home/joregan/updated_annotations/word_annotations")
INPUT_PATH = Path("/shared/mm_conv/meta_final_set")
OUTPUT_PATH = Path("/home/joregan/mm_conv_crowdsourcing_data_context")

if not OUTPUT_PATH.is_dir():
    OUTPUT_PATH.mkdir()


tsv_cache = {}


for file in INPUT_PATH.glob("*.json"):
    with open(file) as f:
        segments = json.load(f)

    for seg in segments:
        rec_id = segments[seg]["recording_id"]

        if rec_id not in tsv_cache:
            tsv_path = TSV_PATH / f"{rec_id}_main.tsv"
            tsv_cache[rec_id] = load_tsv(str(tsv_path))
        
        tsv_data = tsv_cache[rec_id]

        start = segments[seg]["timing"]["phrase_start"]
        end = segments[seg]["timing"]["phrase_end"]

        sliced_tsv = slice_tsv_data(tsv_data, start, end)
        tsv_text = " ".join([x["word"] for x in sliced_tsv])

        refs = segments[seg]["phrase"]
        if not refs:
            continue

        indices = {}
        for ref in refs:
            indices[ref] = get_indices(ref, segments[seg]["utterance"])

        spans = []
        for ref, idx_list in indices.items():
            for start_i, end_i in idx_list:
                spans.append((start_i, end_i))
        spans = sorted(spans, key=lambda x: x[0])

        words = segments[seg]["utterance"].split()
        for start_i, end_i in reversed(spans):
            words[start_i:end_i] = ["<b>" + " ".join(words[start_i:end_i]) + "</b>"]

        segments[seg]["utterance"] = " ".join(words)

    with open(OUTPUT_PATH / file.name, "w") as outf:
        json.dump(segments, outf, indent=2)
