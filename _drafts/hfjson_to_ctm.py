import json
import argparse


def get_args():
    parser = argparse.ArgumentParser(description="""
    Simple script to convert HuggingFace timestamped JSON to CTM.
    """)
    parser.add_argument('files', type=str, nargs='+', help='files to process')
    parser.add_argument('--lower', help='lowercase words', action='store_true', default=True)
    args = parser.parse_args()

    return args


def read_hfjson(json_file, lowercase=True):
    outname = json_file.replace(".json", ".ctm")
    with open(json_file) as jsonf, open(outname, "w") as outf:
        utt = json_file.split("/")[-1].replace(".json", "").replace("_480p", "")
        data = json.load(jsonf)
        if not "chunks" in data:
            raise ValueError(f"File does not appear to contain HuggingFace JSON")
        # utt_id channel_num start_time duration phone_id confidence
        count = 1
        for chunk in data["chunks"]:
            # do stuff
            word = chunk["text"] if not lowercase else chunk["text"].lower()
            start = chunk["timestamp"][0]
            dur = chunk["timestamp"][1] - chunk["timestamp"][0]
            outf.write(f"{utt} 1 {start} {dur} {word} 1.0\n")


def main():
    args = get_args()
    lc = args.lower
    for file in args.files:
        read_hfjson(file, lc)


if __name__ == '__main__':
    main()
