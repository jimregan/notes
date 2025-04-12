import os
import json
import base64
import re
from PIL import Image, ImageDraw
from openai import OpenAI

API_KEY = ""

client = OpenAI(api_key=API_KEY)

# ✅ Paths
base_image_dir = "/Users/lubosm/Work/images"
output_img_dir = "output_annotated"
output_json_dir = "scene_graphs"
os.makedirs(output_img_dir, exist_ok=True)
os.makedirs(output_json_dir, exist_ok=True)

# ✅ Image metadata: (object_label, user_excerpt, filename)
image_entries = [
    ("the furniture", "But eve- but if you wish to actually change the color of the furniture, maybe the brown one, it would be a better choice.", "hsi_7_0719_209_003_39_000_color.png"),
    ("that lamp", "Yeah, but that is a problem, of course, that lamp will have to be turned off when I watch TV.", "hsi_4_0717_211_001_75_001_color.png"),
    ("the couch", "yeah, i can understand that because you don't want to sit like this and especially if you lie down on the couch you you want to have it lower so i can see that so thank you that's a great suggestion", "hsi_5_0718_210_002_28_000_color.png"),
    ("balcony", "put them in the box, and then put the box, just, just throw it off, throw it off, off, off your balcony.", "hsi_6_0718_227_002_106_003_color.png"),
    ("this lamp", "So I really like this lamp. It's a symbol because I have eh a daughter and I have two granddaughters.", "hsi_5_0718_222_002_66_000_color.png"),
    ("the badminton rackets", "Also th- this book together with the badminton rackets. Eh, I, That's not placed there by accident. Eh It's actually one of the world's greatest eh badminton players, eh Sarah Nicholson.", "hsi_5_0718_222_002_54_001_color.png"),
    ("fauteuil", "What {do} you call this one in Swedish eh or in English, fåtölj?", "hsi_5_0718_209_001_1_001_color.png")
]

# ✅ Utility functions
def encode_image_base64(image_path):
    with open(image_path, "rb") as f:
        return base64.b64encode(f.read()).decode("utf-8")

def build_prompt(object_name, excerpt):
    return f"""
For the provided image and its associated question, generate only a scene graph in JSON format that includes the following:
1. Objects that are relevant to answering the question
2. Object attributes that are relevant to answering the question
3. Object relationships that are relevant to answering the question
'''
Use the image and scene graph as context and answer the following prompt:
The final output should be coordinates of discussed object ("{object_name}") in pixel format [X, Y] from the excerpt as well as scen graph in JSON file.
He is the excerpt: "{excerpt}"
"""

def extract_json_from_text(text):
    """Extracts the first valid JSON object found in a string."""
    # Remove any markdown code block markers
    text = text.replace('```json', '').replace('```', '').strip()
    
    # Remove comments
    text = re.sub(r'//.*$', '', text, flags=re.MULTILINE)  # Remove single-line comments
    text = re.sub(r'/\*.*?\*/', '', text, flags=re.DOTALL)  # Remove multi-line comments
    
    # Try to find a JSON object
    match = re.search(r'\{.*\}', text, re.DOTALL)
    if match:
        try:
            return json.loads(match.group(0))
        except json.JSONDecodeError as e:
            print(f"JSON decode error: {e}")
            print(f"Cleaned text: {text}")
            return None
    return None

def call_openai_vision(image_path, object_name, excerpt, max_retries=3):
    prompt = build_prompt(object_name, excerpt)
    base64_image = encode_image_base64(image_path)

    for attempt in range(max_retries):
        try:
            response = client.chat.completions.create(
                model="gpt-4o",
                messages=[
                    {
                        "role": "user",
                        "content": [
                            { "type": "text", "text": prompt },
                            { "type": "image_url", "image_url": { "url": f"data:image/png;base64,{base64_image}" }}
                        ]
                    }
                ],
                max_tokens=1000
            )
            
            response_text = response.choices[0].message.content
            if response_text.strip():  # Check if response is not empty
                return response_text
            
            print(f"⚠️ Empty response on attempt {attempt + 1}, retrying...")
        except Exception as e:
            print(f"⚠️ Error on attempt {attempt + 1}: {e}")
            if attempt == max_retries - 1:
                raise
            continue
    
    raise ValueError("Max retries reached with empty responses")

def visualize_and_save(image_path, label, coords, save_path):
    img = Image.open(image_path)
    draw = ImageDraw.Draw(img)
    x, y = coords
    r = 15
    draw.ellipse([x - r, y - r, x + r, y + r], outline="blue", width=3)
    draw.text((x + 10, y - 10), label, fill="blue")
    img.save(save_path)

def process_all_images(entries):
    for object_label, excerpt, filename in entries:
        image_path = os.path.join(base_image_dir, filename)
        img_output_path = os.path.join(output_img_dir, f"annotated_{filename}")
        json_output_path = os.path.join(output_json_dir, f"{filename.replace('.png', '')}_scene_graph.json")
        print(f"🔍 Processing: {filename}")

        try:
            response_text = call_openai_vision(image_path, object_label, excerpt)
            print(f"Raw response: {response_text}")  # Debug print
            
            scene_graph = extract_json_from_text(response_text)
            if not scene_graph:
                raise ValueError("No valid JSON could be extracted from model output.")

            if "objects" not in scene_graph:
                raise ValueError("No 'objects' key found in scene graph")

            # Find the main object by looking for the object_label in the name or id
            main_obj = None
            search_label = object_label.lower().replace("the ", "").replace("this ", "").replace("that ", "")
            
            # List of furniture-related terms
            furniture_terms = ["furniture", "sofa", "couch", "chair", "table", "desk", "cabinet", "fauteuil", "armchair"]
            if search_label in furniture_terms:
                for obj in scene_graph["objects"]:
                    obj_name = (obj.get("name", "") or obj.get("id", "")).lower()
                    if any(term in obj_name for term in furniture_terms):
                        main_obj = obj
                        break
            else:
                for obj in scene_graph["objects"]:
                    obj_name = (obj.get("name", "") or obj.get("id", "")).lower()
                    if search_label in obj_name or obj_name in search_label:
                        main_obj = obj
                        break

            if not main_obj:
                print(f"⚠️ No exact match found for {object_label}, using first object")
                main_obj = scene_graph["objects"][0] if scene_graph["objects"] else None

            if not main_obj:
                raise ValueError(f"No objects found in scene graph for {filename}")

            # Try different ways to get coordinates
            coords = None
            
            # Case 1: Direct coordinates list [x,y]
            if "coordinates" in main_obj and isinstance(main_obj["coordinates"], list):
                if len(main_obj["coordinates"]) == 2:
                    coords = tuple(main_obj["coordinates"])
            
            # Case 2: Coordinates in dictionary format
            elif "coordinates" in main_obj and isinstance(main_obj["coordinates"], dict):
                if "x" in main_obj["coordinates"] and "y" in main_obj["coordinates"]:
                    coords = (main_obj["coordinates"]["x"], main_obj["coordinates"]["y"])
            
            # Case 3: Position in dictionary format
            elif "position" in main_obj and isinstance(main_obj["position"], dict):
                if "x" in main_obj["position"] and "y" in main_obj["position"]:
                    coords = (main_obj["position"]["x"], main_obj["position"]["y"])
                elif "coordinates" in main_obj["position"] and isinstance(main_obj["position"]["coordinates"], list):
                    if len(main_obj["position"]["coordinates"]) == 2:
                        coords = tuple(main_obj["position"]["coordinates"])
            
            # Case 4: Direct position list [x,y]
            elif "position" in main_obj and isinstance(main_obj["position"], list):
                if len(main_obj["position"]) == 2:
                    coords = tuple(main_obj["position"])
            
            # Case 5: Singular coordinate
            elif "coordinate" in main_obj and isinstance(main_obj["coordinate"], list):
                if len(main_obj["coordinate"]) == 2:
                    coords = tuple(main_obj["coordinate"])
            
            # Case 6: Coordinates in attributes
            elif "attributes" in main_obj:
                attrs = main_obj["attributes"]
                if isinstance(attrs, dict):
                    # Check for location in attributes
                    if "location" in attrs and isinstance(attrs["location"], list) and len(attrs["location"]) == 2:
                        coords = tuple(attrs["location"])
                    # Check for position in attributes
                    elif "position" in attrs and isinstance(attrs["position"], list) and len(attrs["position"]) == 2:
                        coords = tuple(attrs["position"])
                    # Check for coordinates in attributes
                    elif "coordinates" in attrs and isinstance(attrs["coordinates"], list) and len(attrs["coordinates"]) == 2:
                        coords = tuple(attrs["coordinates"])

            if not coords:
                raise ValueError(f"No coordinates found for object {object_label} in {filename}")

            # Get object identifier from either name or id
            obj_id = main_obj.get("name") or main_obj.get("id") or object_label
            visualize_and_save(image_path, obj_id, coords, img_output_path)

            with open(json_output_path, "w") as f:
                json.dump(scene_graph, f, indent=2)

            print(f"✅ Saved: {img_output_path}, {json_output_path}")

        except Exception as e:
            print(f"❌ Error processing {filename}: {e}")

# ✅ Run the pipeline
process_all_images(image_entries)
