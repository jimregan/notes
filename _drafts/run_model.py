from transformers import AutoModelForCausalLM, AutoProcessor, GenerationConfig
from PIL import Image
import json
from pathlib import Path


# load the processor
processor = AutoProcessor.from_pretrained(
    'allenai/Molmo-7B-D-0924',
    trust_remote_code=True,
    torch_dtype='auto',
    device_map='auto'
)

# load the model
model = AutoModelForCausalLM.from_pretrained(
    'allenai/Molmo-7B-D-0924',
    trust_remote_code=True,
    torch_dtype='auto',
    device_map='auto'
)

IMG_PATH = Path("/results/mm_conv_crowdsourcing_data/images/color")
JSON_PATH = Path("/results/mm_conv_crowdsourcing_data/meta")
OUTPATH = Path("/results/molmo_output")

if not OUTPATH.is_dir():
    OUTPATH.mkdir()


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


for image in IMG_PATH.glob("*.png"):
    print("Current", image)
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

    with open(OUTPATH / f"{stem}.json", "w") as outf:
        json.dump(data, outf)
