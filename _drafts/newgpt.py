
import os
import sys
import json
from pathlib import Path
import pandas as pd
import torch
import csv
from tqdm import tqdm
import numpy as np
import time
from PIL import Image

import argparse
import torch
from lego.constants import IMAGE_TOKEN_INDEX, DEFAULT_IMAGE_TOKEN, DEFAULT_IMAGE_PATCH_TOKEN, DEFAULT_IMAGE_START_TOKEN, DEFAULT_IMAGE_END_TOKEN
from lego.conversation import SeparatorStyle
from lego import conversation as conversation_lib
from lego.mm_utils import tokenizer_image_token, KeywordsStoppingCriteria, load_image_square, postprocess_output
from lego.model.builder import CONFIG, load_pretrained_model

import numpy as np
import ast  
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from PIL import Image
import os

def get_gt_mask(img_mask_path):
    gt_mask = cv2.imread(img_mask_path, cv2.IMREAD_GRAYSCALE)
    if gt_mask is None:
        raise ValueError(f"GT mask not found at {img_mask_path}")
    return (gt_mask > 0).astype(np.uint8)

def check_containment(x, y, img_mask_path):
    gt_mask = cv2.imread(img_mask_path, cv2.IMREAD_GRAYSCALE)
    gt_mask = (gt_mask > 0).astype(np.uint8)
    return gt_mask[int(y), int(x)] == 1


def compute_iou_boxes(box1, box2):
    """
    Compute IoU between two bounding boxes.

    Args:
        box1: [x_min, y_min, x_max, y_max]
        box2: [x_min, y_min, x_max, y_max]

    Returns:
        IoU (float): Intersection over Union score
    """
    x1_min, y1_min, x1_max, y1_max = map(int, box1)
    x2_min, y2_min, x2_max, y2_max = map(int, box2)

    # Calculate intersection coordinates
    inter_x_min = max(x1_min, x2_min)
    inter_y_min = max(y1_min, y2_min)
    inter_x_max = min(x1_max, x2_max)
    inter_y_max = min(y1_max, y2_max)

    # Compute intersection area
    inter_width = max(0, inter_x_max - inter_x_min)
    inter_height = max(0, inter_y_max - inter_y_min)
    intersection = inter_width * inter_height

    # Compute areas
    area1 = (x1_max - x1_min) * (y1_max - y1_min)
    area2 = (x2_max - x2_min) * (y2_max - y2_min)
    union = area1 + area2 - intersection

    if union == 0:
        return 0.0
    return intersection / union


def get_bbox_from_mask(mask):
    """
    Get the tight bounding box [x_min, y_min, x_max, y_max] from a binary mask.
    """
    ys, xs = np.where(mask > 0)
    if len(xs) == 0 or len(ys) == 0:
        return None
    x_min, x_max = xs.min(), xs.max()
    y_min, y_max = ys.min(), ys.max()
    return [x_min, y_min, x_max, y_max]
device = "cuda" if torch.cuda.is_available() else "cpu"

# Shared paths
data_path = "/results/meta_files/"
img_base_path = "/results/mm_conv_crowdsourcing_data/"
data_path_sc = "/results/screenshots_1.6/"
results_dir = "/results/eval_results"
os.makedirs(results_dir, exist_ok=True)
annotated_image_dir = "/results/annotated_images_ref"
os.makedirs(annotated_image_dir, exist_ok=True)


# JSON files to evaluate
json_files = [
    # "meta_exact_single.json",
    # "meta_part_single.json"
    "meta_pronomial_single.json",
]

import os
import cv2
from PIL import Image, ImageDraw, ImageFont

def draw_two_boxes(img_path, bbox_det, prompt, exp_id, output_dir, gt_box=None, iou=None):
    os.makedirs(output_dir, exist_ok=True)
    image = Image.open(img_path).convert("RGB")
    width, height = image.size

    bbox = [
        bbox[0] * width,
        bbox[1] * height,
        bbox[2] * width,
        bbox[3] * height,
    ]

    draw = ImageDraw.Draw(image)
    try:
        font = ImageFont.truetype("arial.ttf", 16)
    except:
        font = ImageFont.load_default()
    # Draw prompt
    draw.text((10, 10), f"Prompt: {prompt}", fill="yellow", font=font)
    # Draw predicted box (red)
    x1, y1, x2, y2 = bbox_det
    draw.rectangle([x1, y1, x2, y2], outline="red", width=3)
    draw.text((x1, y1 - 15), "Detection", fill="red", font=font)
    # Draw GT box (yellow)
    if gt_box:
        gx1, gy1, gx2, gy2 = gt_box
        draw.rectangle([gx1, gy1, gx2, gy2], outline="yellow", width=3)
        draw.text((gx1, gy1 - 15), "GT", fill="yellow", font=font)
    # Draw IoU score (bottom left corner or elsewhere)
    if iou is not None:
        draw.text((10, height - 30), f"IoU: {iou:.3f}", fill="white", font=font)
    output_path = os.path.join(output_dir, f"{exp_id}.png")
    image.save(output_path)
    print(f":white_tick: Saved: {output_path}")
    return output_path


thresholds = [0.3, 0.5]

model_path = "/ckpt/GroundingGPT"
temperature = 0.2
max_new_tokens = 512

model, tokenizer, image_processor, _, _ = load_pretrained_model(model_path)
# model = None
# tokenizer = None
# image_processor = None
# JSON files to evaluate
json_files = [
    "meta_exact_single.json",
    # # "meta_part_single.json"
    # "meta_pronomial_single.json",
]
# for json_name in json_files:
json_name = json_files[0]
print(f"\n🔍 Evaluating: {json_name}")
json_path = Path(data_path) / json_name
with open(json_path, 'r') as f:
    json_data = json.load(f)

base_name = json_name.replace(".json", "")
annotated_image_dir = f"./annotated_images/{base_name}"
os.makedirs(annotated_image_dir, exist_ok=True)

out_csv = f"{results_dir}/{base_name}_eval.csv"
out_fail = f"{results_dir}/{base_name}_failures.csv"

csv_fieldnames = [
    "exp_id", "phrase", "ref_object_id", "px_object_id", "utterance",
    "img_color_path", "img_mask_path", "meta_json_path"
] + [
    f"iou@{t}" for t in thresholds
] + [
    f"iou@{t}_matched" for t in thresholds
] + [
    "iou_matched", "annotated_image_path", "n_bboxes"
]
with open(out_csv, 'w', newline='') as csv_file, open(out_fail, 'w', newline='') as csv_fail_file:
    csv_writer = csv.DictWriter(csv_file, fieldnames=csv_fieldnames)
    csv_fail_writer = csv.DictWriter(csv_fail_file, fieldnames=csv_fieldnames)
    csv_writer.writeheader()
    csv_fail_writer.writeheader()


    for exp_id, data in tqdm(json_data.items()):

        try:
            # recording_id = data["recording_id"]
            # ref_object_name = data["object_id"]
            img_color_path = os.path.join(img_base_path, data["image_paths"]["color"])
            img_color_path = img_color_path.replace("/home/deichler/", "/results/")
            print("img_color_path", img_color_path)
            img_mask_path = os.path.join(img_base_path, data["image_paths"]["mask"])
            img_mask_path = img_mask_path.replace("/home/deichler/", "/results/")
            print("img_mask_path", img_mask_path)
            phrase = data.get("phrase", "")
            utterance = data.get("utterance", "").replace("coach", "couch")

            inp = f"Given the following utterance: {utterance} Identify the object referred to by the word {phrase} in the image. Return the bounding box."
            image = load_image_square(img_color_path, image_processor)
            image_tensor = image_processor.preprocess(image, return_tensors='pt')['pixel_values'].half().cuda()

            conv = conversation_lib.default_conversation.copy()
            roles = conv.roles

            if model.config.mm_use_im_start_end:
                inp = DEFAULT_IMAGE_START_TOKEN + DEFAULT_IMAGE_PATCH_TOKEN * CONFIG.image_token_len + DEFAULT_IMAGE_END_TOKEN + '\n' + inp
            else:
                inp = DEFAULT_IMAGE_TOKEN + '\n' + inp

            conv.append_message(roles[0], inp)
            conv.append_message(roles[1], None)
            prompt = conv.get_prompt()

            input_ids = tokenizer_image_token(prompt, tokenizer, IMAGE_TOKEN_INDEX, return_tensors='pt').unsqueeze(0).cuda()
            stop_str = conv.sep if conv.sep_style != SeparatorStyle.TWO else conv.sep2
            stopping_criteria = KeywordsStoppingCriteria([stop_str], tokenizer, input_ids)

            with torch.inference_mode():
                output_ids = model.generate(
                    input_ids,
                    images=image_tensor,
                    do_sample=True,
                    temperature=temperature,
                    max_new_tokens=max_new_tokens,
                    use_cache=True,
                    stopping_criteria=[stopping_criteria]
                )

            outputs = tokenizer.decode(output_ids[0, input_ids.shape[1]:]).strip()
            outputs = postprocess_output(outputs, img_color_path)
            if outputs.endswith(stop_str):
                outputs = outputs[:-len(stop_str)]

            bbox = np.array(ast.literal_eval(outputs))  # may raise

            gt_mask = get_gt_mask(img_mask_path)
            gt_box = get_bbox_from_mask(gt_mask)

            iou = compute_iou_boxes(gt_box, bbox)
            iou_scores = [iou if iou > t else 0.0 for t in thresholds]
            iou_matched_flags = [iou > t for t in thresholds]
            iou_matched = any(iou_matched_flags)

            annotated_img_path = draw_two_boxes(
                img_path=img_color_path,
                bbox_det=gt_box,
                prompt=f"{phrase}/{utterance}",
                exp_id=exp_id,
                output_dir=annotated_image_dir,
                gt_box=gt_box
            )

            result_entry = {
                "exp_id": exp_id,
                "phrase": phrase,
                "ref_object_id": "None",
                "px_object_id": "None",
                "utterance": utterance,
                "img_color_path": img_color_path,
                "img_mask_path": img_mask_path,
                "meta_json_path": str(json_path),
                "iou_matched": iou_matched,
                "annotated_image_path": str(annotated_img_path),
                "n_bboxes": 1
            }
            for i, t in enumerate(thresholds):
                result_entry[f"iou@{t}"] = iou_scores[i]
                result_entry[f"iou@{t}_matched"] = iou_matched_flags[i]

            csv_writer.writerow(result_entry)
            csv_file.flush()

            if not iou_matched:
                csv_fail_writer.writerow(result_entry)
                csv_fail_file.flush()

        except Exception as e:
            print(f"❌ Failed on {exp_id}: {e}")
            # traceback.print_exc()

            # Save failure entry even when crashing
            fail_entry = {
                "exp_id": exp_id,
                "phrase": data.get("phrase", ""),
                "ref_object_id": data.get("object_id", ""),
                "px_object_id": "None",
                "utterance": data.get("utterance", "").replace("coach", "couch"),
                "img_color_path": data["image_paths"]["color"].replace("/home/deichler/", "/results/"),
                "img_mask_path": data["image_paths"]["mask"],
                "meta_json_path": str(json_path),
                "iou_matched": False,
                "annotated_image_path": "ERROR",
                "n_bboxes": 0
            }
            for t in thresholds:
                fail_entry[f"iou@{t}"] = 0.0
                fail_entry[f"iou@{t}_matched"] = False

            csv_fail_writer.writerow(fail_entry)
            csv_fail_file.flush()
