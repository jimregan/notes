from pathlib import Path
import torchaudio
import soundfile as sf
from datasets import Dataset
from tqdm import tqdm

# Path to your dataset directory
DATA_DIR = Path("data")

# Function to load an audio file
def load_audio(file_path):
    waveform, sample_rate = torchaudio.load(file_path)
    return {
        "audio": {
            "path": str(file_path),
            "array": waveform.squeeze(0).numpy(),
            "sampling_rate": sample_rate,
        }
    }

# Function to load a transcription file
def load_transcription(file_path):
    return file_path.read_text(encoding="utf-8").strip()

# Collect all audio and transcription files
data = []
for audio_file in tqdm(DATA_DIR.glob("*.wav")):
    transcript_file = audio_file.with_suffix(".txt")
    
    if transcript_file.exists():
        data.append({
            "audio": load_audio(audio_file),
            "transcription": load_transcription(transcript_file),
        })

# Create a Hugging Face Dataset
dataset = Dataset.from_list(data)

# Save dataset to disk for later use
dataset.save_to_disk("wav2vec_dataset")

# Print a sample
print(dataset[0])

