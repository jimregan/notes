import os
import json
import pandas as pd
import re
import string
import argparse
# Paths
WORD_PATH = "/home/deichler/data/sgs_recordings/hsi/word_annotations/main/"
TOPIC_ANNOTATIONS = "/shared/mm_conv/annotations/resolved_references/"
ANALYSIS_RESULTS = "/shared/mm_conv/analysis/analysis_results"
FPS = 15
# Contraction handling
contraction_map = {
    "it's": ["it", "is"],
    "that's": ["that", "is"],
    "i'm": ["i", "am"],
    "you're": ["you", "are"],
    "they're": ["they", "are"],
    "we're": ["we", "are"],
    "isn't": ["is", "not"],
}
def normalize(word):
    return word.strip(string.punctuation).lower()
def expand_token(token):
    return contraction_map.get(token.lower(), [token.lower()])
def get_word_timings_for_resolved_references(seg, word_df):
    start_time = seg["general"]["start"]
    end_time = seg["general"]["end"]
    resolved_refs = seg["low_level"].get("resolved_references", {})
    snippet = seg.get("snippet", "")
    # Clean tokenized version of the utterance
    # snippet_tokens = [normalize(w) for w in snippet.split()]
    raw_snippet_tokens = snippet.split()
    snippet_tokens = []
    for token in raw_snippet_tokens:
        expanded = expand_token(token)
        snippet_tokens.extend([normalize(t) for t in expanded])
    token_positions = {}
    # Build lookup table of normalized subphrases
    for i in range(len(snippet_tokens)):
        for j in range(i + 1, min(len(snippet_tokens), i + 10) + 1):  # up to 10-word phrases
            phrase = " ".join(snippet_tokens[i:j])
            token_positions[phrase] = (i, j - i)
    # Extract relevant word timings
    window_df = word_df[(word_df["start"] >= start_time) & (word_df["end"] <= end_time)].copy()
    tokens = []
    token_times = []
    for _, row in window_df.iterrows():
        raw_word = row["word"].strip()
        start, end = row["start"], row["end"]
        if raw_word.lower() in contraction_map:
            for w in contraction_map[raw_word.lower()]:
                tokens.append(w)
                token_times.append((start, end))
        else:
            tokens.append(normalize(raw_word))
            token_times.append((start, end))
    used_indices = set()
    ref_timings = {}
    for phrase, obj_id in resolved_refs.items():
        phrase_tokens = re.findall(r"\w+", phrase.lower())
        n = len(phrase_tokens)
        normalized_phrase = " ".join(phrase_tokens)
        token_index, phrase_len = token_positions.get(normalized_phrase, (-1, len(phrase_tokens)))
        for i in range(len(tokens)):
            if any(j in used_indices for j in range(i, i + n)):
                continue
            expanded = []
            for j in range(i, min(i + n, len(tokens))):
                expanded += expand_token(tokens[j])
            if expanded[:n] == phrase_tokens:
                slice_times = token_times[i:i + n]
                start_time, end_time = slice_times[0][0], slice_times[-1][1]
                if isinstance(obj_id, list):
                    obj_id = obj_id[0]
                ref_timings[(phrase, obj_id)] = {
                    "phrase_start": start_time,
                    "phrase_end": end_time,
                    "utterance_token_index": token_index,
                    "phrase_token_length": phrase_len
                }
                used_indices.update(range(i, i + n))
                break
        else:
            print(f":exclamation: No match found for phrase: '{phrase}'")
    return ref_timings
# Main
if __name__ == "__main__":
    # parser = argparse.ArgumentParser()
    # parser.add_argument("pid", type=int)
    # parser.add_argument("rid", type=int)
    # parser.add_argument("tid", type=int)
    # args = parser.parse_args()
    pid = 3
    rid = 210
    tid = 10
    DDATE = {3: "0715", 4: "0717", 5: "0718", 6: "0718", 7: "0719"}
    tid_str = f"{tid:03d}"
    base_id = f"hsi_{pid}_{DDATE[pid]}_{rid}_{tid_str}"
    word_path = os.path.join(WORD_PATH, f"{base_id}_main.tsv")
    topic_file = os.path.join(TOPIC_ANNOTATIONS, f"{base_id}.json")
    words = pd.read_csv(word_path, names=["start", "end", "word"], sep="\t")
    with open(topic_file, "r") as f:
        segments = json.load(f)
    output_data = []
    for seg_id, seg in segments.items():
        utter_start = seg["general"]["start"]
        utter_end = seg["general"]["end"]
        snippet = seg.get("snippet", "")
        rr = seg.get("low_level", {}).get("resolved_references", {})
        if not rr:
            continue
        ref_matches = get_word_timings_for_resolved_references(seg, words)
        for (phrase, obj_id), info in ref_matches.items():
            output_data.append({
                "segment_id": seg_id,
                "phrase": phrase,
                "object_id": obj_id,
                "utterance": snippet,
                "utterance_start": utter_start,
                "utterance_end": utter_end,
                "phrase_start": info["phrase_start"],
                "phrase_end": info["phrase_end"],
                "utterance_token_index": info["utterance_token_index"],
                "phrase_token_length": info["phrase_token_length"]
            })
    out_dir = os.path.join(ANALYSIS_RESULTS, base_id)
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join("/home/joregan", f"{base_id}_ref_timings.json")
    with open(out_path, "w") as f:
        json.dump(output_data, f, indent=2)
    print(f":white_tick: Saved timing data to: {out_path}")
    # Safety check print
    print("\n:test_tube: Sanity check (first 5 resolved phrases):")
    for item in output_data[23:45]:
        phrase = item['phrase']
        utterance = item['utterance']
        token_index = item['utterance_token_index']
        phrase_len = item['phrase_token_length']
        # Tokenize utterance (normalized, to match what's used in the code)
        utterance_tokens = [normalize(w) for w in utterance.split()]
        # Extract phrase from tokenized utterance
        if 0 <= token_index < len(utterance_tokens):
            extracted_phrase = " ".join(utterance_tokens[token_index : token_index + phrase_len])
        else:
            extracted_phrase = "<OUT OF BOUNDS>"
        print(f":small_blue_diamond: Phrase: '{phrase}'")
        print(f"   Utterance: '{utterance}'")
        print(f"   → Token Index: {token_index}, Length: {phrase_len}")
        print(f"   → Extracted Phrase: '{extracted_phrase}'")
        print(f"   → Utterance Time: [{item['utterance_start']:.2f}s - {item['utterance_end']:.2f}s]")
        print(f"   → Phrase Time:    [{item['phrase_start']:.2f}s - {item['phrase_end']:.2f}s]\n")

