import os
import json
import re
import torch
from PIL import Image, ImageDraw, ImageFont
from lego.mm_utils import tokenizer_image_token, KeywordsStoppingCriteria, load_image_square, postprocess_output
from lego.conversation import SeparatorStyle
from lego import conversation as conversation_lib
from lego.model.builder import CONFIG, load_pretrained_model
from lego.constants import IMAGE_TOKEN_INDEX, DEFAULT_IMAGE_PATCH_TOKEN, DEFAULT_IMAGE_START_TOKEN, DEFAULT_IMAGE_END_TOKEN

# Load model once
model_path = "/workspace/GroundingGPT/ckpt"
model, tokenizer, image_processor, _, _ = load_pretrained_model(model_path)

# Prompt builder (same logic as original OpenAI)
def build_prompt(phrase, utterance, image_width, image_height):
    return (
        "You are given an image, a phrase and a utterance. "
        "The phrase refers to an object visible in the image. "
        "The utterance provides context for the phrase. "
        f"The image is {image_width} pixels wide and {image_height} pixels tall. "
        "Return up to three points of the object in pixel coordinates "
        "as a list of lists: [[x,y], ...]. "
        "Only return a list of points, no text or explanation.\n\n"
        f"Phrase: '{phrase}' in the context of '{utterance}'"
    )

def parse_points(output):
    return [[int(x), int(y)] for x, y in re.findall(r"\[\s*(\d+)\s*,\s*(\d+)\s*\]", output)]

def call_groundinggpt(phrase, utterance, image_path):
    image = Image.open(image_path).convert("RGB")
    image_tensor = image_processor.preprocess(image, return_tensors='pt')['pixel_values'].half().cuda()

    width, height = image.size
    prompt = build_prompt(phrase, utterance, width, height)

    # Compose conversation
    conv = conversation_lib.default_conversation.copy()
    if model.config.mm_use_im_start_end:
        image_token = DEFAULT_IMAGE_START_TOKEN + DEFAULT_IMAGE_PATCH_TOKEN * CONFIG.image_token_len + DEFAULT_IMAGE_END_TOKEN
    else:
        image_token = DEFAULT_IMAGE_PATCH_TOKEN * CONFIG.image_token_len

    conv.append_message(conv.roles[0], image_token + '\n' + prompt)
    conv.append_message(conv.roles[1], None)
    prompt_text = conv.get_prompt()

    input_ids = tokenizer_image_token(prompt_text, tokenizer, IMAGE_TOKEN_INDEX, return_tensors='pt').unsqueeze(0).cuda()
    stop_str = conv.sep if conv.sep_style != SeparatorStyle.TWO else conv.sep2
    stopping_criteria = KeywordsStoppingCriteria([stop_str], tokenizer, input_ids)

    with torch.inference_mode():
        output_ids = model.generate(
            input_ids,
            images=image_tensor,
            do_sample=True,
            temperature=0.2,
            max_new_tokens=512,
            stopping_criteria=[stopping_criteria]
        )

    outputs = tokenizer.decode(output_ids[0, input_ids.shape[1]:]).strip()
    if outputs.endswith(stop_str):
        outputs = outputs[:-len(stop_str)]
    return postprocess_output(outputs, image_path)

def plot_points(image_path, points, save_path, utterance=None, phrase=None):
    image = Image.open(image_path).convert("RGB")
    draw = ImageDraw.Draw(image)
    font_size = 20
    try:
        font = ImageFont.truetype("DejaVuSans.ttf", font_size)
    except:
        font = ImageFont.load_default()
    for point in points:
        x, y = point
        draw.ellipse((x - 5, y - 5, x + 5, y + 5), fill='red', outline='white')
    text_lines = []
    if utterance:
        text_lines.append(f"Utterance: {utterance}")
    if phrase:
        text_lines.append(f"Phrase: {phrase}")
    text_y = 5
    for line in text_lines:
        bbox = draw.textbbox((0, 0), line, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        draw.rectangle([5, text_y, 5 + text_width + 10, text_y + text_height + 6], fill=(0, 0, 0))
        draw.text((10, text_y + 3), line, fill="white", font=font)
        text_y += text_height + 10
    image.save(save_path)

# Output folder
output_folder = "/audio/res_groundinggpt"
os.makedirs(output_folder, exist_ok=True)

# Load your dataset
with open("/audio/rs_results/meta_exact_single348.json", "r") as f:
    all_examples = json.load(f)

results = {}
for meta_id, data in all_examples.items():
    print(f"Processing {meta_id}...")
    utterance = data["utterance"]
    phrase = data["phrase"]
    im_path = data['image_paths']['color']
    image_path = f"/audio/rs_results/mm_conv_crowdsourcing_data/{im_path}"
    try:
        prediction_raw = call_groundinggpt(phrase, utterance, image_path)
        print(f"Prediction: {prediction_raw}")
        points = parse_points(prediction_raw)
        save_path = os.path.join(output_folder, f"{meta_id}.png")
        plot_points(image_path, points, save_path, utterance=utterance, phrase=phrase)
        results[meta_id] = {
            "utterance": phrase,
            "image_path": image_path,
            "prediction": points
        }
    except Exception as e:
        print(f"Error processing {meta_id}: {e}")
        results[meta_id] = {
            "utterance": phrase,
            "image_path": image_path,
            "prediction": "error"
        }

# Save results
with open("/audio/groundinggpt_predictions.json", "w") as f:
    json.dump(results, f, indent=2)

