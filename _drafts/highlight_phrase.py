import os
import json
import pandas as pd
from pathlib import Path

TSV_PATH = Path("/home/deichler/data/sgs_recordings/hsi/word_annotations/main/")
INPUT_JSON = Path("/shared/mm_conv/meta_final_set/wutt/meta_pronomial_single_wutt.json")   # 👈 Replace this
OUTPUT_JSON = Path("meta_pronomial_single_wutt.json")  # 👈 Replace this

HIGHLIGHT_WRAP = '<span style="background-color: yellow;">{}</span>'

# Load segments
with open(INPUT_JSON, "r") as f:
    segments = json.load(f)

# Cache for TSVs
tsv_cache = {}

# Normalization helper
def normalize(text):
    return text.strip().lower().strip(".,!?;:\"'`")

# Apply highlighting to the correct span based on timing
for seg_id, seg in segments.items():
    rec_id = seg["recording_id"]
    phrase_start = seg["timing"]["phrase_start"]
    phrase_end = seg["timing"]["phrase_end"]
    utterance = seg["utterance"]

    # Load TSV if needed
    if rec_id not in tsv_cache:
        tsv_file = TSV_PATH / f"{rec_id}_main.tsv"
        if not tsv_file.exists():
            print(f"⚠️ Missing TSV file for {rec_id}")
            continue
        tsv_cache[rec_id] = pd.read_csv(tsv_file, sep="\t", names=["start", "end", "word"])

    df = tsv_cache[rec_id]

    # Get word tokens that match the phrase timing
    phrase_df = df[(df["start"] >= phrase_start) & (df["end"] <= phrase_end)].reset_index(drop=True)
    phrase_tokens = phrase_df["word"].tolist()
    if not phrase_tokens:
        print(f"⚠️ No matched tokens for {seg_id} in {rec_id}")
        continue

    norm_phrase = [normalize(w) for w in phrase_tokens]

    # Tokenize and normalize the utterance
    orig_tokens = utterance.split()
    norm_tokens = [normalize(w) for w in orig_tokens]

    # Try to find the exact match sequence in normalized tokens
    match_idx = -1
    for i in range(len(norm_tokens) - len(norm_phrase) + 1):
        if norm_tokens[i:i+len(norm_phrase)] == norm_phrase:
            match_idx = i
            break

    if match_idx == -1:
        print(f"⚠️ Could not align phrase '{' '.join(phrase_tokens)}' with utterance in seg {seg_id}")
        continue

    # Wrap the matched range in the original token list
    new_tokens = (
        orig_tokens[:match_idx]
        + [HIGHLIGHT_WRAP.format(" ".join(orig_tokens[match_idx:match_idx+len(norm_phrase)]))]
        + orig_tokens[match_idx+len(norm_phrase):]
    )

    seg["utterance"] = " ".join(new_tokens)

# Save updated JSON
with open(OUTPUT_JSON, "w") as f:
    json.dump(segments, f, indent=2)

print(f"✅ Updated utterances written to: {OUTPUT_JSON}")

