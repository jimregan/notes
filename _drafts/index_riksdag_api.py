import json
from bs4 import BeautifulSoup
from pathlib import Path
import argparse
import copy
import re


BASE_KEYS = ['videostatus', 'committee', 'type', 'debatepreamble', 'debatetexthtml', 'livestreamurl', 'activelivespeaker', 'id', 'dokid', 'title', 'debatename', 'debatedate', 'debatetype', 'debateurl', 'fromchamber', 'thumbnailurl', 'debateseconds']


def get_args():
    parser = argparse.ArgumentParser(description="""
    Convert a directory of Riksdag API output to Kaldi text format
    """)
    parser.add_argument('dir', type=str, help='directory containing API JSON')
    parser.add_argument('output', type=str, help='output file name')
    args = parser.parse_args()

    return args


def read_api_json(filename):
    infile = str(filename)
    with open(infile) as input:
        data = json.load(input)
    assert "videodata" in data
    print(f"Reading {filename}")

    if len(data["videodata"]) > 1:
        print(f"More than one 'videodata' in {infile}")

    base = {}
    for key in BASE_KEYS:
        base[key] = data["videodata"][0][key]

    if not "streams" in data["videodata"][0] or data["videodata"][0]["streams"] is None:
        print(f"No 'streams' key found in {filename}")
        return None, None
    assert "streams" in data["videodata"][0]
    if not "files" in data["videodata"][0]["streams"] or data["videodata"][0]["streams"]["files"] is None:
        print(f"No 'files' key found in {filename}")
    assert "files" in data["videodata"][0]["streams"]
    if len(data["videodata"][0]["streams"]["files"]) > 1:
        print(f"More than one stream: {infile}")
    assert "url" in data["videodata"][0]["streams"]["files"][0]
    base["streamurl"] = data["videodata"][0]["streams"]["files"][0]["url"]


    if not "speakers" in data["videodata"][0] or data["videodata"][0]["speakers"] is None:
        print(f"No 'speakers' key found in {filename}")
        return None, None
    speakers = []
    for speaker in data["videodata"][0]["speakers"]:
        cur = {}
        for key in ["start", "duration", "party", "subid", "active", "number"]:
            cur[key] = speaker[key]
        cur["speaker"] = speaker["text"]
        ending = f" ({cur['party']})"
        if cur["speaker"].endswith(ending):
            cur["speaker"] = cur["speaker"][:-len(ending)]
        html = speaker["anftext"]
        soup = BeautifulSoup(html, 'html.parser')
        count = 1
        for para in soup.find_all("p"):
            if para.text.strip() == "":
                continue
            pg = copy.deepcopy(cur)
            pg["text"] = para.text
            pg["paragraph"] = count
            speakers.append(pg)
            count += 1
    return base, speakers


PUNCT_FINAL = [")", ".", ",", "!", ":", ";", "?", '"']


def clean_text(text):
    text = text.strip().replace("\r\n", " ")
    if text == "":
        return ""
    if len(text) == 1 and text in PUNCT_FINAL:
        return ""
    while text[-1] in PUNCT_FINAL:
        text = text[:-1]
    while text[0] in ["(", '"']:
        text = text[1:]
    text = text.replace("\n", " ")
    text = text.strip()
    text = text.replace('"', "")
    text = text.replace(". ", " ")
    text = text.replace(", ", " ")
    text = text.replace(";", "")
    text = text.replace(": ", " ")
    text = text.replace("!", "")
    text = text.replace("?", "")
    text = re.sub("  +", " ", text)
    text = text.lower()
    
    return text


def main():
    args = get_args()
    API_OUTPUT = Path(args.dir)
    with open(args.output, "w") as outf:
        for file in API_OUTPUT.glob("*"):
            doc, speakers = read_api_json(file)
            if doc is None or speakers is None:
                continue
            for speaker in speakers:
                if speaker["text"].strip() == "":
                    continue
                elif speaker["text"].strip().startswith("STYLEREF Kantrubrik"):
                    continue
                docid = f'{doc["streamurl"].split("/")[-1]}_{speaker["paragraph"]}'
                text = clean_text(speaker["text"])
                if text == "":
                    continue
                outf.write(f"{docid} {text}\n")


if __name__ == '__main__':
    main()
