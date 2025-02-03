import argparse
import torchaudio
import soundfile as sf
import numpy as np
import json
import matplotlib.pyplot as plt
from pathlib import Path
from datasets import Dataset, load_from_disk
from transformers import AutoProcessor, AutoModelForCTC
import torch
from tqdm import tqdm
from jiwer import wer, cer, compute_confusion_matrix

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

# Function to transcribe audio using a Wav2Vec2 model
def transcribe_audio(processor, model, audio_data):
    input_values = processor(audio_data, sampling_rate=16000, return_tensors="pt").input_values
    with torch.no_grad():
        logits = model(input_values).logits
    predicted_ids = torch.argmax(logits, dim=-1)
    return processor.batch_decode(predicted_ids)[0]

# Function to compute and save confusion matrix
def save_confusion_matrix(ground_truths, predictions, silence_durations, output_path):
    matrix = compute_confusion_matrix(ground_truths, predictions)

    plt.figure(figsize=(10, 8))
    plt.imshow(matrix, cmap="Blues", interpolation="nearest")
    plt.xlabel("Predicted Labels")
    plt.ylabel("True Labels")
    plt.title(f"Confusion Matrix for Silence Durations: {silence_durations}")
    plt.colorbar()
    plt.savefig(output_path)
    print(f"Confusion matrix saved to {output_path}")

def main():
    parser = argparse.ArgumentParser(description="Prepare and evaluate audio dataset for Wav2Vec2 ASR")
    parser.add_argument("--data-dir", type=Path, required=True, help="Path to directory containing audio and transcription files")
    parser.add_argument("--model", type=str, required=True, help="Wav2Vec2 model to use")
    parser.add_argument("--concatenate", action="store_true", help="Concatenate short audio files to fit batch size")
    parser.add_argument("--silence-duration", type=str, default="0.5", help="Silence duration(s) in seconds (comma-separated for multiple values)")
    parser.add_argument("--evaluate", action="store_true", help="Evaluate Wav2Vec2 ASR output against ground truth")
    parser.add_argument("--overwrite", action="store_true", help="Overwrite existing datasets if they already exist")

    args = parser.parse_args()
    
    # Parse multiple silence durations
    silence_durations = [float(x) for x in args.silence_duration.split(",")]

    # Load Wav2Vec2 processor & model
    processor = AutoProcessor.from_pretrained(args.model)
    model = AutoModelForCTC.from_pretrained(args.model)

    # Determine max duration based on model
    max_duration = processor.feature_extractor.sampling_rate * processor.feature_extractor.max_length_in_seconds

    # Collect all audio and transcription files
    audio_data = []
    for audio_file in tqdm(args.data_dir.glob("*.wav")):
        transcript_file = audio_file.with_suffix(".txt")
        
        if transcript_file.exists():
            audio_info = load_audio(audio_file)
            audio_info["transcription"] = load_transcription(transcript_file)
            audio_data.append(audio_info)

    all_results = {}

    for silence_duration in silence_durations:
        dataset_path = Path(f"wav2vec_dataset_silence_{silence_duration}")
        if dataset_path.exists() and not args.overwrite:
            print(f"Reusing existing dataset: {dataset_path}")
            dataset = load_from_disk(str(dataset_path))
        else:
            print(f"\nProcessing with silence duration: {silence_duration} seconds...")

            # Concatenation mode
            if args.concatenate:
                dataset_data = concatenate_audio(audio_data, silence_duration, max_duration)
            else:
                dataset_data = [{"audio": {"array": a["array"], "sampling_rate": a["sampling_rate"]}, "transcription": a["transcription"]} for a in audio_data]

            # Create and save dataset
            dataset = Dataset.from_list(dataset_data)
            dataset.save_to_disk(str(dataset_path))
            print(f"Dataset saved: {dataset_path}")

        # ASR Evaluation Mode
        if args.evaluate:
            predictions = []
            ground_truths = []

            for item in tqdm(dataset_data, desc=f"Transcribing (Silence {silence_duration}s)"):
                transcription = transcribe_audio(processor, model, item["audio"]["array"])
                predictions.append(transcription)
                ground_truths.append(item["transcription"])

            wer_score = wer(ground_truths, predictions)
            cer_score = cer(ground_truths, predictions)

            print(f"WER (Silence {silence_duration}s): {wer_score:.4f}")
            print(f"CER (Silence {silence_duration}s): {cer_score:.4f}")

            all_results[silence_duration] = {
                "WER": wer_score,
                "CER": cer_score,
                "Ground Truths": ground_truths,
                "Predictions": predictions
            }

    # Save ASR results to JSON
    if args.evaluate:
        with open("asr_results.json", "w", encoding="utf-8") as f:
            json.dump(all_results, f, indent=4)
        print("ASR results saved to asr_results.json")

        # Generate confusion matrix if multiple silence durations are tested
        if len(silence_durations) > 1:
            print("\nGenerating confusion matrix...")
            all_ground_truths = sum([result["Ground Truths"] for result in all_results.values()], [])
            all_predictions = sum([result["Predictions"] for result in all_results.values()], [])
            save_confusion_matrix(all_ground_truths, all_predictions, silence_durations, "confusion_matrix.png")

if __name__ == "__main__":
    main()

