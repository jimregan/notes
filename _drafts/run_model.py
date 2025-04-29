import logging
from transformers import AutoModelForCausalLM, AutoProcessor, GenerationConfig
import argparse
from datetime import datetime
from PIL import Image
import json
from pathlib import Path


def setup_logger():
    logging.basicConfig(
        format="%(asctime)s %(levelname)s %(message)s",
        level=logging.INFO,
        datefmt="%Y-%m-%d %H:%M:%S"
    )


def build_prompt_orig(utterance):
    return (
        "Locate the object: '{0}' in the image.\n"
        "Return only the coordinates as [[x1, y1, x2, y2]].\n"
        "Example: [[100, 150, 300, 400]]"
    ).format(utterance)


def build_prompt_chatgpt(utterance):
    return (
        "An image is (X, Y)=(640, 400).\n"
        "Locate the object commonly referred to as '{0}' in the image.\n"
        "Focus on its visual appearance and spatial layout.\n"
        "Return only the coordinates as [[x1, y1, x2, y2]].\n"
        "Example: [[100, 150, 300, 400]]"
    ).format(utterance)


def build_prompt(type, utterance):
    if type == "first":
        return build_prompt_orig(utterance)


def slurp(filename):
    with open(filename) as f:
        segment = json.load(f)
    return segment


def get_topic_context(segment, old_json, json_path, size=None, keep_topic=True):
    rec_id = segment["recording_id"]
    orig_seg_id = segment["segment_id"]
    if not rec_id in old_json:
        with open(json_path / f"{rec_id}.json") as inf:
            old_json[rec_id] = json.load(inf)
    original = old_json[rec_id]
    orig_keys = list(original.keys())
    orig_keys.sort(key=lambda x: int(x))
    orig_topic = original[orig_seg_id]["high_level"]["current_topic"]

    index = orig_keys.index(orig_seg_id)
    if size is None:
        start = 0
    else:
        start = index - size
    ctx_range = orig_keys[start:index]

    if size is not None and len(ctx_range) < size:
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


def get_time_context(segment, tsv_cache, tsv_path, ctx_time = 5.0):
    rec_id = segment["recording_id"]
    start = segment["timing"]["utterance_start"]

    if not rec_id in tsv_cache:
        with open(tsv_path / f"{rec_id}_main.tsv") as inf:
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


def parse_args():
    parser = argparse.ArgumentParser(description="Load model and processor with paths.")
    parser.add_argument('--model_name', type=str, required=True)
    parser.add_argument('--processor_name', type=str, default=None)
    parser.add_argument('--img_path', type=str, default="/results/mm_conv_crowdsourcing_data/images/color")
    parser.add_argument('--json_path', type=str, default="/results/mm_conv_crowdsourcing_data/meta")
    parser.add_argument('--annotation_path', type=str, default="/results/mm_conv_crowdsourcing_data/meta")
    parser.add_argument('--tsv_path', type=str, default="/results/mm_conv_crowdsourcing_data/meta")
    parser.add_argument('--outpath', type=str, default="/results/molmo_output")
    return parser.parse_args()


def main():
    setup_logger()
    args = parse_args()

    processor_name = args.processor_name or args.model_name

    logging.info("🚀 Starting model load")
    processor = AutoProcessor.from_pretrained(
        processor_name,
        trust_remote_code=True,
        torch_dtype='auto',
        device_map='auto'
    )
    model = AutoModelForCausalLM.from_pretrained(
        args.model_name,
        trust_remote_code=True,
        torch_dtype='auto',
        device_map='auto'
    )

    IMG_PATH = Path(args.img_path)
    JSON_PATH = Path(args.json_path)
    OUTPATH = Path(args.outpath)
    OUTPATH.mkdir(parents=True, exist_ok=True)

    logging.info(f"📦 Processor loaded from: {processor_name}")
    logging.info(f"🧠 Model loaded from: {args.model_name}")
    logging.info(f"🖼️ Image path: {IMG_PATH}")
    logging.info(f"🗂️ JSON path: {JSON_PATH}")
    logging.info(f"💾 Output path: {OUTPATH}")

    logging.info("🕒 Processing started")

    old_json = {}
    tsv_cache = {}

    for image in IMG_PATH.glob("*.png"):
        logging.info(f"📸 Processing image: {image.name}")
        stem = image.stem
        with open(JSON_PATH / f"{stem.replace('_color', '_meta')}.json") as jsf:
            data = json.load(jsf)

        utterance = data["utterance"]
        reference = data["phrase"]
        object_name = data["object_name"]
        topic_context = get_topic_context(data, old_json, args.json_path, 5)
        tsv_context = get_time_context(data, tsv_cache, args.tsv_path, 20.0)
        if topic_context != "":
            context = topic_context
        else:
            context = tsv_context

        inputs = processor.process(
            images=[Image.open(str(image))],
            text=build_prompt_orig(utterance)
        )
        inputs = {k: v.to(model.device).unsqueeze(0) for k, v in inputs.items()}

        output = model.generate_from_batch(
            inputs,
            GenerationConfig(max_new_tokens=200, stop_strings="<|endoftext|>"),
            tokenizer=processor.tokenizer
        )

        generated_tokens = output[0, inputs['input_ids'].size(1):]
        generated_text = processor.tokenizer.decode(generated_tokens, skip_special_tokens=True)

        data["generated_answer"] = generated_text

        with open(OUTPATH / f"{stem}.json", "w") as outf:
            json.dump(data, outf)
        logging.info("📝 Output written")

    logging.info("✅ Processing completed")


if __name__ == "__main__":
    main()
