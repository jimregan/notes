import json
import pandas as pd
from pathlib import Path
import re

# === Config ===
TSV_PATH = Path("/home/deichler/data/sgs_recordings/hsi/word_annotations/main/")
INPUT_JSON = Path("/shared/mm_conv/meta_final_set/wutt/meta_pronomial_single_wutt.json")       # 👈 Replace this
OUTPUT_JSON = Path("meta_pronomial_single_wutt.json")  # 👈 Replace this

HIGHLIGHT = '<span style="background-color: yellow;">{}</span>'

# === Normalize Helper ===
def normalize(word):
    return re.sub(r"[^\w']", "", word.lower())

# === Load Input ===
with open(INPUT_JSON, "r") as f:
    segments = json.load(f)

# === TSV Cache ===
tsv_cache = {}

for seg_id, seg in segments.items():
    rec_id = seg["recording_id"]
    start_time = seg["timing"]["phrase_start"]
    end_time = seg["timing"]["phrase_end"]
    utterance = seg["utterance"]

    # --- Load TSV ---
    if rec_id not in tsv_cache:
        tsv_file = TSV_PATH / f"{rec_id}_main.tsv"
        if not tsv_file.exists():
            print(f"[WARN] Missing TSV for {rec_id}")
            continue
        df = pd.read_csv(tsv_file, sep="\t", names=["start", "end", "word"])
        tsv_cache[rec_id] = df
    else:
        df = tsv_cache[rec_id]

    # --- Get tokens for this phrase based on time ---
    phrase_df = df[(df["start"] >= start_time) & (df["end"] <= end_time)].reset_index(drop=True)

    if phrase_df.empty:
        print(f"[WARN] No words found in timing range for seg {seg_id}")
        continue

    phrase_tokens = phrase_df["word"].tolist()
    norm_phrase = [normalize(w) for w in phrase_tokens if w.strip()]

    if not norm_phrase:
        print(f"[WARN] Normalized phrase empty for seg {seg_id}")
        continue

    # --- Tokenize utterance and normalize ---
    orig_tokens = utterance.split()
    norm_tokens = [normalize(tok) for tok in orig_tokens]

    # --- Try to locate exact sequence ---
    found = False
    for i in range(len(norm_tokens) - len(norm_phrase) + 1):
        if norm_tokens[i:i+len(norm_phrase)] == norm_phrase:
            # Found match
            span = orig_tokens[i:i+len(norm_phrase)]
            highlighted = HIGHLIGHT.format(" ".join(span))
            new_utterance = (
                " ".join(orig_tokens[:i]) + " " +
                highlighted + " " +
                " ".join(orig_tokens[i+len(norm_phrase):])
            ).strip()
            seg["utterance"] = re.sub(r"\s+", " ", new_utterance)
            found = True
            break

    if not found:
        print(f"[WARN] No match found in utterance for seg {seg_id}")
        print(f"    Phrase: {' '.join(phrase_tokens)}")
        print(f"    Utterance: {utterance}")
        print(f"    Normalized Phrase: {norm_phrase}")

# === Write Output ===
with open(OUTPUT_JSON, "w") as f:
    json.dump(segments, f, indent=2)

print(f"✅ Done. Output written to {OUTPUT_JSON}")

