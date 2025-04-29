import os
import json
import re
import base64
import openai
import matplotlib.pyplot as plt
from PIL import Image
from openai import OpenAI
API_KEY = ""
client = OpenAI(api_key=API_KEY)
def encode_image(image_path):
    with open(image_path, "rb") as f:
        return base64.b64encode(f.read()).decode("utf-8")
def build_prompt(utterance):
    return (
        "You are given an image and a sentence. "
        "The sentence refers to an object visible in the image. "
        "Return up to four points of the object in the image. "
        "as a list of lists: [[x,y], ...]. "
        "Only return a list of points, no text or explanation.\n\n"
        f"Sentence: '{utterance}'"
    )
def parse_points(output):
    return [[int(x), int(y)] for x, y in re.findall(r"\[\s*(\d+)\s*,\s*(\d+)\s*\]", output)]
def build_prompt(phrase,utterance, image_width, image_height):
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
# def call_gpt4o(utterance, image_path):
#     base64_image = encode_image(image_path)
#     prompt = build_prompt(utterance)
#     response = client.chat.completions.create(
#         model="gpt-4o",
#         messages=[
#             {
#                 "role": "user",
#                 "content": [
#                     {"type": "text", "text": prompt},
#                     {"type": "image_url", "image_url": {"url": f"data:image/png;base64,{base64_image}"}}
#                 ]
#             }
#         ],
#         temperature=0.2
#     )
#     return response.choices[0].message.content
def call_gpt4o(phrase,utterance, image_path):
    base64_image = encode_image(image_path)
    image = Image.open(image_path)
    width, height = image.size
    prompt = build_prompt(phrase,utterance, width, height)
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": prompt},
                    {"type": "image_url", "image_url": {"url": f"data:image/png;base64,{base64_image}"}}
                ]
            }
        ],
        temperature=0.2
    )
    return response.choices[0].message.content
def plot_points(image_path, points, save_path):
    image = Image.open(image_path)
    plt.figure(figsize=(10, 10))
    plt.imshow(image)
    for point in points:
        plt.plot(point[0], point[1], 'ro', markersize=8)
    plt.axis("off")
    plt.tight_layout()
    plt.savefig(save_path)
    plt.close()
from PIL import ImageDraw, ImageFont
from PIL import ImageDraw, ImageFont
def plot_points(image_path, points, save_path, utterance=None, phrase=None):
    image = Image.open(image_path).convert("RGB")
    width, height = image.size
    draw = ImageDraw.Draw(image)
    font_size = 20
    try:
        font = ImageFont.truetype("DejaVuSans.ttf", font_size)
    except:
        font = ImageFont.load_default()
    # Draw points
    for point in points:
        x, y = point
        draw.ellipse((x - 5, y - 5, x + 5, y + 5), fill='red', outline='white')
    # Prepare text
    text_lines = []
    if utterance:
        text_lines.append(f"Utterance: {utterance}")
    if phrase:
        text_lines.append(f"Phrase: {phrase}")
    # Draw background and text using textbbox for compatibility
    text_y = 5
    for line in text_lines:
        # Get bounding box of text: (left, top, right, bottom)
        bbox = draw.textbbox((0, 0), line, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        draw.rectangle(
            [5, text_y, 5 + text_width + 10, text_y + text_height + 6],
            fill=(0, 0, 0)
        )
        draw.text((10, text_y + 3), line, fill="white", font=font)
        text_y += text_height + 10
    image.save(save_path)
# Paths
output_folder = "./res_gpt"
os.makedirs(output_folder, exist_ok=True)
results = {}
# Load data
with open("/shared/mm_conv/meta_final_set/meta_exact_single348.json", "r") as f:
    all_examples = json.load(f)
# Process examples
for meta_id, data in all_examples.items():
    print(f"Processing {meta_id}...")
    utterance = data["utterance"]
    phrase = data["phrase"]
    im_path = data['image_paths']['color']
    image_path = f"/home/deichler/mm_conv_crowdsourcing_data/{im_path}"
    try:
        prediction_raw = call_gpt4o(phrase, utterance, image_path)
        print(f"Prediction: {prediction_raw}")
        points = parse_points(prediction_raw)
        # Save image with points
        save_path = os.path.join(output_folder, f"{meta_id}.png")
        # plot_points(image_path, points, save_path)
        plot_points(image_path, points, save_path, utterance=utterance, phrase=phrase)
        # Store result
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
# Save all results
with open("gpt4o_predictions.json", "w") as f:
    json.dump(results, f, indent=2)
