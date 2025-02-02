import torch
import torchaudio
import faiss
import numpy as np
import soundfile as sf
import pickle
from transformers import AutoModel, AutoTokenizer

# Load CLAP Model (on GPU)
MODEL_NAME = "laion/clap"
device = "cuda" if torch.cuda.is_available() else "cpu"
model = AutoModel.from_pretrained(MODEL_NAME).to(device)
tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)

# Parameters
WINDOW_SIZE = 5  # seconds
STRIDE = 2       # seconds (overlap step)
SAMPLE_RATE = 16000
INDEX_FILE = "audio_index.faiss"
METADATA_FILE = "audio_metadata.pkl"
BATCH_SIZE = 16  # Process multiple chunks in parallel

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

# Function to Extract CLAP Audio Embeddings (Batched, GPU)
def get_audio_embeddings(audio_segments):
    tensors = [seg.unsqueeze(0).unsqueeze(0).to(device) for seg in audio_segments]  # Add batch & channel dims
    tensor_batch = torch.cat(tensors, dim=0)  # Stack into a batch
    with torch.no_grad():
        embeddings = model.get_audio_features(tensor_batch)  # GPU inference
    return embeddings.cpu().numpy()  # Move to CPU for FAISS

# Load and Process Audio
audio_file = "example_audio.wav"
audio_data = load_audio(audio_file)
audio_segments = chunk_audio(audio_data, SAMPLE_RATE, WINDOW_SIZE, STRIDE)

# Create FAISS GPU Index
D = 512  # CLAP embedding dimension
index = faiss.IndexFlatL2(D)
res = faiss.StandardGpuResources()  # Enable GPU
index = faiss.index_cpu_to_gpu(res, 0, index)  # Move index to GPU

# Store embeddings and metadata
segment_embeddings = []
metadata = []

# Process in Batches for Speed
for i in range(0, len(audio_segments), BATCH_SIZE):
    batch = audio_segments[i : i + BATCH_SIZE]
    batch_embeddings = get_audio_embeddings(batch)
    segment_embeddings.append(batch_embeddings)

    # Store timestamps
    for j, emb in enumerate(batch_embeddings):
        start_time = (i + j) * STRIDE
        end_time = start_time + WINDOW_SIZE
        metadata.append((start_time, end_time))

# Convert to NumPy array and add to FAISS
segment_embeddings = np.vstack(segment_embeddings).astype(np.float32)
index.add(segment_embeddings)

# Save FAISS Index (Move to CPU before saving)
index = faiss.index_gpu_to_cpu(index)
faiss.write_index(index, INDEX_FILE)

# Save Metadata
with open(METADATA_FILE, "wb") as f:
    pickle.dump(metadata, f)

print(f"✅ GPU Indexing complete! Stored {len(metadata)} audio segments.")

