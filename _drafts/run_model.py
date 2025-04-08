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

IMG_PATH = "/results/images/color/"
JSON_PATH = Path("/results/json/")

results = {}
POINTS_PROMPT = "Your answer should be formatted as a list of tuples, i.e. [(x1, y1), (x2, y2), ...], where each tuple contains the x and y coordinates of a point satisfying the conditions above. The coordinates should be between 0 and 1, indicating the normalized pixel locations of the points in the image."
BOX_PROMPT = "Your answer should be formatted as a list containing a pair of tuples, i.e. [(x1, y1), (x2, y2)], where each tuple contains the x and y coordinates of a point satisfying the conditions above. The coordinates should be between 0 and 1, indicating the normalized pixel locations of bounding box of the item in the image."

for image in Path(IMG_PATH).glob("*.png"):
    print("Current", image)
    stem = image.stem
    stem_parts = stem.split("_")
    if stem_parts[-1] == "color":
        sentid = stem_parts[-2]
        fileid = "_".join(stem_parts[:-2])
    else:
        print("Error reading file", stem)
        continue
    with open(str(JSON_PATH / f"{fileid}.json")) as jsf:
        data = json.load(jsf)
    current = data[sentid]
    if not stem in results:
        results[stem] = {}

    snippet = current["snippet"]
    references = current.get("low_level", {}).get("resolved_references", {})
    if references == {}:
        print(f"Skipping {stem}: no low_level resolved_references")

    for reference in references:
        item_code = references[reference]
        if type(item_code) is list:
            item = ", ".join([x.split("_")[0] for x in item_code])
        else:
            item_parts = item_code.split("_")
            item = item_parts[0]

        prompt = """This image is being discussed in the snippet of conversation that follows; 
        in the snippet, the text {reference} refers to {item}.\n\n
        The snippet is: {snippet}\n\n
        Is the reference to {item} real, or imaginary? Answer with the word "real" or "imaginary".
        """

        # process the image and text
        inputs = processor.process(
            images=[Image.open(str(image))],
            text=prompt
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

        results[stem][reference] = generated_text

with open("/results/trial_run.json", "w") as outf:
    json.dump(data, outf)