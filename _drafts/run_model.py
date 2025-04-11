from transformers import AutoModelForCausalLM, AutoProcessor, GenerationConfig
import argparse
from datetime import datetime
from PIL import Image
import json
from pathlib import Path


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


def build_prompt(type, utterance, ):
    if type == "first":
        return build_prompt_orig(utterance)


def parse_args():
    parser = argparse.ArgumentParser(description="Load model and processor with paths.")
    
    parser.add_argument('--model_name', type=str, required=True,
                        help="Name or path of the model to load.")
    parser.add_argument('--processor_name', type=str, default=None,
                        help="Optional: Name or path of the processor. Defaults to model_name.")
    parser.add_argument('--img_path', type=str, default="/results/mm_conv_crowdsourcing_data/images/color",
                        help="Path to the image directory.")
    parser.add_argument('--json_path', type=str, default="/results/mm_conv_crowdsourcing_data/meta",
                        help="Path to the JSON metadata directory.")
    parser.add_argument('--outpath', type=str, default="/results/molmo_output",
                        help="Path to the output directory.")

    return parser.parse_args()


def main():
    args = parse_args()

    # Use model_name if processor_name not provided
    processor_name = args.processor_name or args.model_name

    print(f"[INFO] Model loading started at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    # Load processor
    processor = AutoProcessor.from_pretrained(
        processor_name,
        trust_remote_code=True,
        torch_dtype='auto',
        device_map='auto'
    )

    # Load model
    model = AutoModelForCausalLM.from_pretrained(
        args.model_name,
        trust_remote_code=True,
        torch_dtype='auto',
        device_map='auto'
    )

    # Convert paths to Path objects
    IMG_PATH = Path(args.img_path)
    JSON_PATH = Path(args.json_path)
    OUTPATH = Path(args.outpath)
    if not OUTPATH.is_dir():
        OUTPATH.mkdir()

    print(f"[INFO] Processor loaded from: {processor_name}")
    print(f"[INFO] Model loaded from: {args.model_name}")
    print(f"[INFO] Image path: {IMG_PATH}")
    print(f"[INFO] JSON path: {JSON_PATH}")
    print(f"[INFO] Output path: {OUTPATH}")

    print(f"[INFO] Processing started at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    for image in IMG_PATH.glob("*.png"):
        print(f"[INFO] Current image: {image}")
        stem = image.stem
        with open(str(JSON_PATH / f"{stem.replace('_color', '_meta')}.json")) as jsf:
            data = json.load(jsf)
        
        utterance = data["utterance"]
        reference = data["phrase"]
        object_name = data["object_name"]

        # process the image and text
        inputs = processor.process(
            images=[Image.open(str(image))],
            text=build_prompt_orig(utterance)
        )

        # move inputs to the correct device and make a batch of size 1
        inputs = {k: v.to(model.device).unsqueeze(0) for k, v in inputs.items()}

        # generate output; maximum 200 new tokens; stop generation when <|endoftext|> is generated
        output = model.generate_from_batch(
            inputs,
            GenerationConfig(max_new_tokens=200, stop_strings="<|endoftext|>"),
            tokenizer=processor.tokenizer
        )

        # only get generated tokens; decode them to text
        generated_tokens = output[0,inputs['input_ids'].size(1):]
        generated_text = processor.tokenizer.decode(generated_tokens, skip_special_tokens=True)

        data["generated_answer"] = generated_text

        print(f"[INFO] Writing results")
        with open(OUTPATH / f"{stem}.json", "w") as outf:
            json.dump(data, outf)

    print(f"[INFO] Processing ended at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")


if __name__ == "__main__":
    main()
