import os
import torchaudio
import soundfile as sf
from datasets import Dataset, DatasetDict
from tqdm import tqdm

# Path to your dataset directory
DATA_DIR = "data"

# Function to load an audio file
def load_audio(file_path):
    waveform, sample_rate = torchaudio.load(file_path)
    return {"audio": {"path": file_path, "array": waveform.squeeze(0).numpy(), "sampling_rate": sample_rate}}

# Function to load a transcription file
def load_transcription(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        return f.read().strip()

# Collect all audio and transcription files
data = []
for file in tqdm(os.listdir(DATA_DIR)):
    if file.endswith(".wav"):
        base_name = os.path.splitext(file)[0]
        audio_path = os.path.join(DATA_DIR, file)
        transcript_path = os.path.join(DATA_DIR, base_name + ".txt")

        if os.path.exists(transcript_path):
            data.append({
                "audio": load_audio(audio_path),
                "transcription": load_transcription(transcript_path)
            })

# Create a Hugging Face Dataset
dataset = Dataset.from_list(data)

# Save dataset to disk for later use
dataset.save_to_disk("wav2vec_dataset")

# Print sample
print(dataset[0])

