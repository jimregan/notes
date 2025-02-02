import torch
import torchaudio
import faiss
import numpy as np
import soundfile as sf
import pickle
from transformers import AutoModel, AutoTokenizer

# Load CLAP Model (LAION version, Hugging Face)
MODEL_NAME = "laion/clap"
model = AutoModel.from_pretrained(MODEL_NAME)
tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)

# Parameters
WINDOW_SIZE = 5  # seconds
STRIDE = 2       # seconds (overlap step)
SAMPLE_RATE = 16000
INDEX_FILE = "audio_index.faiss"
METADATA_FILE = "audio_metadata.pkl"

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
    audio_tensor = audio_segment.unsqueeze(0).unsqueeze(0)  # Add batch and channel dims
    with torch.no_grad():
        embedding = model.get_audio_features(audio_tensor)  # Extract embedding
    return embedding.squeeze(0).numpy()

# Load and Process Audio
audio_file = "example_audio.wav"
audio_data = load_audio(audio_file)
audio_segments = chunk_audio(audio_data, SAMPLE_RATE, WINDOW_SIZE, STRIDE)

# Create FAISS Index
D = 512  # CLAP embedding dimension
index = faiss.IndexFlatL2(D)

# Store embeddings and metadata
segment_embeddings = []
metadata = []

for i, segment in enumerate(audio_segments):
    embedding = get_audio_embedding(segment)
    segment_embeddings.append(embedding)
    start_time = i * STRIDE  # Calculate start time for the segment
    end_time = start_time + WINDOW_SIZE
    metadata.append((start_time, end_time))

# Convert to NumPy array and add to FAISS
segment_embeddings = np.array(segment_embeddings, dtype=np.float32)
index.add(segment_embeddings)

# Save FAISS Index
faiss.write_index(index, INDEX_FILE)

# Save Metadata
with open(METADATA_FILE, "wb") as f:
    pickle.dump(metadata, f)

print(f"✅ Indexing complete! Stored {len(metadata)} audio segments.")

