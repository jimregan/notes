import torch
import faiss
import numpy as np
import pickle
from transformers import AutoModel, AutoTokenizer

# Load CLAP Model (GPU)
MODEL_NAME = "laion/clap"
device = "cuda" if torch.cuda.is_available() else "cpu"
model = AutoModel.from_pretrained(MODEL_NAME).to(device)
tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)

# Load FAISS Index and Metadata
INDEX_FILE = "audio_index.faiss"
METADATA_FILE = "audio_metadata.pkl"

index = faiss.read_index(INDEX_FILE)
res = faiss.StandardGpuResources()  # Enable GPU
index = faiss.index_cpu_to_gpu(res, 0, index)  # Move index to GPU

with open(METADATA_FILE, "rb") as f:
    metadata = pickle.load(f)

# Function to Extract CLAP Text Embeddings (GPU)
def get_text_embedding(text):
    inputs = tokenizer(text, return_tensors="pt").to(device)
    with torch.no_grad():
        embedding = model.get_text_features(**inputs)
    return embedding.cpu().numpy()  # Move to CPU for FAISS

# Search Query
query_text = "dog barking"  # Example input
query_embedding = get_text_embedding(query_text).astype(np.float32).reshape(1, -1)

# Perform FAISS Search (GPU)
k = 5  # Top-k matches
distances, indices = index.search(query_embedding, k)

# Show Matching Segments
print("\n🔍 Top Matching Audio Segments:")
for i, idx in enumerate(indices[0]):
    start_time, end_time = metadata[idx]
    print(f"{i+1}. Time: {start_time:.2f}s - {end_time:.2f}s (Distance: {distances[0][i]:.4f})")

