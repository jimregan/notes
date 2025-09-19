import requests, json, html
from typing import List, Dict
from pathlib import Path
import json

wiki_dir = "/home/joregan/quiggin/wiki"
json_dir = "/home/joregan/quiggin/raw"

OLLAMA_HOST = "http://130.237.3.106:11434"
MODEL = "quiggin-extractor:latest"


def normalize_snippet(s: str) -> str:
    s = s.replace("\u00AD", "")
    s = s.replace("\u200B", "")
    s = s.replace("&amp;", "&")
    s = s.replace("&nbsp;", " ")
    s = s.replace("&shy;", "")
    s = html.unescape(s)
    return s

def extract_sections(text: str) -> List[Dict]:
    """
    Send one text chunk (one or more sections) to Ollama; return parsed JSON list.
    """
    text = normalize_snippet(text)

    resp = requests.post(
        f"{OLLAMA_HOST}/api/generate",
        headers={"Content-Type": "application/json"},
        json={
            "model": MODEL,
            "prompt": f"<<<\n{text}\n>>>",
            "options": {"temperature": 0.1, "num_ctx": 8192},
            "stream": False,
        },
        timeout=1500,
    )
    resp.raise_for_status()
    data = resp.json()

    raw = data.get("response", "").strip()

    start = raw.find("[")
    end = raw.rfind("]")
    if start != -1 and end != -1 and end >= start:
        raw = raw[start:end+1]

    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        print("⚠️ Could not parse JSON. Raw response:\n", raw)
        return []


if __name__ == "__main__":
    json_path = Path(json_dir)
    wiki_path = Path(wiki_dir)

    for file in wiki_path.glob("*.wiki"):
        stem = file.stem
        print(f"Processing {stem}")
        if (json_path / f"{stem}.json").exists():
            print(f"Skipping {stem}, already done")
            continue
        with open(file, "r") as f:
            text = f.read()
        text = text.strip()
        try:
            output = extract_sections(text)
            with open(json_path / f"{stem}.json", "w", encoding="utf-8") as f:
                json.dump(output, f, ensure_ascii=False, indent=2)
        except Exception as e:
            print(f"Error processing {stem}: {e}")
            continue
