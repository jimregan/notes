import json
from pathlib import Path

TSV_PATH = Path("/home/joregan/updated_annotations/word_annotations")
JSON_PATH = Path("/home/joregan/updated_annotations/final_resolved")
#INPUT_PATH = Path("/home/deichler/mm_conv_crowdsourcing_data/final_set")
INPUT_PATH = Path("/shared/mm_conv/meta_final_set")
OUTPUT_PATH = Path("/home/joregan/mm_conv_crowdsourcing_data_context")

if not OUTPUT_PATH.is_dir():
    OUTPUT_PATH.mkdir()

old_json = {}
tsv_cache = {}

def get_topic_context(segments, segment_id, size=None, keep_topic=True):
    rec_id = segments[segment_id]["recording_id"]
    orig_seg_id = segments[segment_id]["segment_id"]
    if not rec_id in old_json:
        with open(JSON_PATH / f"{rec_id}.json") as inf:
            old_json[rec_id] = json.load(inf)
    original = old_json[rec_id]
    orig_keys = list(original.keys())
    orig_topic = original[orig_seg_id]["high_level"]["current_topic"]

    index = orig_keys.index(orig_seg_id)
    if size is None:
        start = 0
    else:
        start = index - size
    ctx_range = orig_keys[start:index]

    if len(ctx_range) < size:
        if int(orig_seg_id) <= size:
            pass
        else:
            print(f"Warning: size of {size} cannot be satisfied: {ctx_range}")

    topics = [original[x]["high_level"]["current_topic"] for x in ctx_range]

    tmp = []
    for p in zip(ctx_range, topics):
        if not keep_topic:
            tmp.append(original[p[0]]["snippet"])
        elif keep_topic and p[1] == orig_topic:
            tmp.append(original[p[0]]["snippet"])
        else:
            tmp.append(None)
    return " ".join([x for x in tmp if x is not None])


def get_time_context(segments, segment_id, ctx_time = 5.0):
    rec_id = segments[segment_id]["recording_id"]
    #start = segments[segment_id]["timing"]["utterance_start"]
    start = segments[segment_id]["timing"]["phrase_start"]

    if not rec_id in tsv_cache:
        with open(TSV_PATH / f"{rec_id}_main.tsv") as inf:
            lines = []
            for line in inf.readlines():
                line = line.strip()
                if "\t" in line:
                    lines.append(line.split("\t"))
            tsv_cache[rec_id] = lines

    tsv_times = tsv_cache[rec_id]
    extract = []
    for time in tsv_times:
        s = float(time[0])
        e = float(time[1])
        if s >= (start - ctx_time) and (e < start):
            extract.append(time[2])
    return " ".join(extract)


for file in INPUT_PATH.glob("*.json"):
    with open(file) as f:
        segments = json.load(f)

    for seg in segments:
        ctx = get_topic_context(segments, seg, 5)
        ctx_type = "topic"
        if ctx.strip() == "":
            ctx = get_time_context(segments, seg, 20.0)
            ctx_type = "audio"
        utt = segments[seg]["utterance"]
        segments[seg]["utterance"] = " ".join([ctx, utt])
    with open(OUTPUT_PATH / file.name, "w") as outf:
        json.dump(segments, outf, indent=2)
