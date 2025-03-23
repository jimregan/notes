import torch
import torchaudio
import faiss
import numpy as np
from transformers import AutoModel, AutoTokenizer

# Load CLAP Model (LAION version, Hugging Face)
MODEL_NAME = "laion/clap"
model = AutoModel.from_pretrained(MODEL_NAME)
tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)

# Set Sliding Window Parameters
WINDOW_SIZE = 5  # seconds
STRIDE = 2       # overlap (step size)
SAMPLE_RATE = 16000  # Standard audio sampling rate

# Function to Load Audio
def load_audio(file_path, target_sr=SAMPLE_RATE):
    waveform, sr = torchaudio.load(file_path)
    if sr != target_sr:
        waveform = torchaudio.transforms.Resample(sr, target_sr)(waveform)
    return waveform.mean(dim=0)  # Convert to mono

# Function to Chunk Audio
def chunk_audio(audio, sr, window_size, stride):
    step = int(stride * sr)
    window = int(window_size * sr)
    return [audio[i : i + window] for i in range(0, len(audio) - window, step)]

# Function to Extract CLAP Audio Embeddings
def get_audio_embedding(audio_segment):
    # Convert to tensor and normalize
    audio_tensor = audio_segment.unsqueeze(0).unsqueeze(0)  # Add batch and channel dims
    with torch.no_grad():
        embedding = model.get_audio_features(audio_tensor)  # Extract embedding
    return embedding.squeeze(0).numpy()

# Function to Extract CLAP Text Embeddings
def get_text_embedding(text):
    inputs = tokenizer(text, return_tensors="pt")
    with torch.no_grad():
        embedding = model.get_text_features(**inputs)
    return embedding.squeeze(0).numpy()

# Load and Chunk the Audio
audio_file = "example_audio.wav"
audio_data = load_audio(audio_file)
audio_segments = chunk_audio(audio_data, SAMPLE_RATE, WINDOW_SIZE, STRIDE)

# Create FAISS Index (for fast retrieval)
D = 512  # Assuming CLAP embeddings are 512-dim
index = faiss.IndexFlatL2(D)

# Store Embeddings in FAISS
segment_embeddings = []
for segment in audio_segments:
    embedding = get_audio_embedding(segment)
    segment_embeddings.append(embedding)

segment_embeddings = np.array(segment_embeddings, dtype=np.float32)
index.add(segment_embeddings)  # Add embeddings to FAISS index

# Perform Zero-Shot Text-Based Search
query_text = "dog barking"  # Example text query
query_embedding = get_text_embedding(query_text).astype(np.float32)
query_embedding = query_embedding.reshape(1, -1)  # Reshape for FAISS

# Search FAISS Index for Matching Segments
k = 5  # Number of nearest neighbors to retrieve
distances, indices = index.search(query_embedding, k)

# Display Matching Time Intervals
print("\nTop Matching Audio Segments:")
for i, idx in enumerate(indices[0]):
    start_time = (idx * STRIDE)
    end_time = start_time + WINDOW_SIZE
    print(f"{i+1}. Time: {start_time:.2f}s - {end_time:.2f}s (Distance: {distances[0][i]:.4f})")

