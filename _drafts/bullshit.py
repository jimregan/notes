import argparse
import torchaudio
import soundfile as sf
import numpy as np
from pathlib import Path
from datasets import Dataset
from transformers import AutoProcessor
from tqdm import tqdm

# Function to load an audio file
def load_audio(file_path):
    waveform, sample_rate = torchaudio.load(file_path)
    return {
        "path": str(file_path),
        "array": waveform.squeeze(0).numpy(),
        "sampling_rate": sample_rate,
        "duration": waveform.shape[1] / sample_rate
    }

# Function to load a transcription file
def load_transcription(file_path):
    return file_path.read_text(encoding="utf-8").strip()

# Function to concatenate short audio files
def concatenate_audio(audio_list, silence_duration, max_duration):
    concatenated_data = []
    temp_waveform = []
    temp_transcription = []
    total_duration = 0
    silence_waveform = None

    for item in audio_list:
        if total_duration + item["duration"] + silence_duration > max_duration:
            if temp_waveform:
                concatenated_data.append({
                    "audio": {
                        "array": np.concatenate(temp_waveform),
                        "sampling_rate": item["sampling_rate"]
                    },
                    "transcription": " ".join(temp_transcription)
                })
            temp_waveform = []
            temp_transcription = []
            total_duration = 0
        
        temp_waveform.append(item["array"])
        temp_transcription.append(item["transcription"])
        total_duration += item["duration"]

        if silence_duration > 0:
            if silence_waveform is None:
                silence_waveform = np.zeros(int(item["sampling_rate"] * silence_duration))
            temp_waveform.append(silence_waveform)
            total_duration += silence_duration

    if temp_waveform:
        concatenated_data.append({
            "audio": {
                "array": np.concatenate(temp_waveform),
                "sampling_rate": item["sampling_rate"]
            },
            "transcription": " ".join(temp_transcription)
        })

    return concatenated_data

def main():
    parser = argparse.ArgumentParser(description="Prepare audio dataset for Wav2Vec")
    parser.add_argument("--data-dir", type=Path, required=True, help="Path to directory containing audio and transcription files")
    parser.add_argument("--model", type=str, required=True, help="Wav2Vec model to determine batch size")
    parser.add_argument("--concatenate", action="store_true", help="Concatenate short audio files to fit batch size")
    parser.add_argument("--silence-duration", type=float, default=0.5, help="Silence duration (seconds) between concatenated clips")
    
    args = parser.parse_args()

    # Load Wav2Vec model processor to get max input length
    processor = AutoProcessor.from_pretrained(args.model)
    max_duration = processor.feature_extractor.sampling_rate * processor.feature_extractor.max_length_in_seconds

    # Collect all audio and transcription files
    audio_data = []
    for audio_file in tqdm(args.data_dir.glob("*.wav")):
        transcript_file = audio_file.with_suffix(".txt")
        
        if transcript_file.exists():
            audio_info = load_audio(audio_file)
            audio_info["transcription"] = load_transcription(transcript_file)
            audio_data.append(audio_info)

    # Concatenation mode
    if args.concatenate:
        print(f"Concatenating short audio files (max duration: {processor.feature_extractor.max_length_in_seconds} sec)")
        dataset_data = concatenate_audio(audio_data, args.silence_duration, max_duration)
    else:
        dataset_data = [{"audio": {"array": a["array"], "sampling_rate": a["sampling_rate"]}, "transcription": a["transcription"]} for a in audio_data]

    # Create Hugging Face Dataset
    dataset = Dataset.from_list(dataset_data)

    # Save dataset to disk for later use
    dataset.save_to_disk("wav2vec_dataset")
    
    print("Dataset saved to 'wav2vec_dataset'")
    print("Sample:", dataset[0])

if __name__ == "__main__":
    main()

