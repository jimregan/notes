import argparse
import codecs
import os
import re
import random
import json
from datetime import datetime
from importlib.resources import files
from pathlib import Path

import numpy as np
import soundfile as sf
import tomli
from cached_path import cached_path
from hydra.utils import get_class
from omegaconf import OmegaConf
from tqdm import tqdm

from f5_tts.infer.utils_infer import (
    mel_spec_type,
    target_rms,
    cross_fade_duration,
    nfe_step,
    cfg_strength,
    sway_sampling_coef,
    speed,
    fix_duration,
    device,
    infer_process,
    load_model,
    load_vocoder,
    preprocess_ref_audio_text,
    remove_silence_for_generated_wav,
)

# --------------------------------------------------------
# Helper function
# --------------------------------------------------------

def get_mmconv_speaker_pairs(ref_dir):
    pairs = {}
    if isinstance(ref_dir, str):
        ref_dir = Path(ref_dir)
    for wavfile in ref_dir.glob("*.wav"):
        textfile = wavfile.with_suffix(".txt")
        parts = wavfile.stem.split("_")
        speaker = parts[1]
        room = parts[3]
        if speaker not in pairs:
            pairs[speaker] = {}
        if textfile.exists():
            with open(textfile, "r", encoding="utf-8") as f:
                data = f.read().strip()
            pairs[speaker][str(wavfile)] = data
    return pairs

# --------------------------------------------------------
# CLI arguments
# --------------------------------------------------------

parser = argparse.ArgumentParser(
    prog="python3 infer-cli.py",
    description="Commandline interface for E2/F5 TTS with Advanced Batch Processing.",
)

parser.add_argument("-c", "--config", type=str,
    default=os.path.join(files("f5_tts").joinpath("infer/examples/basic"), "basic.toml"),
    help="The configuration file."
)

parser.add_argument("-m", "--model", type=str, help="The model name")
parser.add_argument("-mc", "--model_cfg", type=str, help="The path to model config .yaml")
parser.add_argument("-p", "--ckpt_file", type=str, help="Path to model checkpoint .pt")
parser.add_argument("-v", "--vocab_file", type=str, help="Path to vocab file .txt")
parser.add_argument("-r", "--ref_audio", type=str, help="Reference audio file")
parser.add_argument("-s", "--ref_text", type=str, help="Reference text")
parser.add_argument("-t", "--gen_text", type=str, help="Text to synthesize")
parser.add_argument("-f", "--gen_file", type=str, help="File with text to synthesize")
parser.add_argument("-o", "--output_dir", type=str, help="Output directory")
parser.add_argument("-w", "--output_file", type=str, help="Output file name")
parser.add_argument("--save_chunk", action="store_true", help="Save each audio chunk separately")
parser.add_argument("--remove_silence", action="store_true", help="Remove silence from output")
parser.add_argument("--load_vocoder_from_local", action="store_true", help="Load vocoder from local")
parser.add_argument("--vocoder_name", type=str, choices=["vocos", "bigvgan"], help="Vocoder name")
parser.add_argument("--target_rms", type=float, help="Target RMS loudness")
parser.add_argument("--cross_fade_duration", type=float, help="Cross-fade duration")
parser.add_argument("--nfe_step", type=int, help="Number of function evaluations")
parser.add_argument("--cfg_strength", type=float, help="Classifier-free guidance strength")
parser.add_argument("--sway_sampling_coef", type=float, help="Sway sampling coefficient")
parser.add_argument("--speed", type=float, help="Generated audio speed")
parser.add_argument("--fix_duration", type=float, help="Fix total duration")
parser.add_argument("--device", type=str, help="Device to run on")
parser.add_argument("--json_file", type=str, help="Path to JSON file with generation instructions")
parser.add_argument("--ref_dir", type=str, help="Reference audio+text directory for speaker/room pairs")
parser.add_argument("--speaker", type=str, help="Speaker to generate for")

args = parser.parse_args()

# --------------------------------------------------------
# Config and Variables
# --------------------------------------------------------

config = tomli.load(open(args.config, "rb"))

model = args.model or config.get("model", "F5TTS_v1_Base")
ckpt_file = args.ckpt_file or config.get("ckpt_file", "")
vocab_file = args.vocab_file or config.get("vocab_file", "")
ref_audio = args.ref_audio or config.get("ref_audio", "infer/examples/basic/basic_ref_en.wav")
ref_text = args.ref_text if args.ref_text is not None else config.get("ref_text", "Some call me nature...")
gen_text = args.gen_text or config.get("gen_text", "Here we generate something for test.")
gen_file = args.gen_file or config.get("gen_file", "")
output_dir = args.output_dir or config.get("output_dir", "tests")
output_file = args.output_file or config.get("output_file", f"infer_cli_{datetime.now().strftime(r'%Y%m%d_%H%M%S')}.wav")
save_chunk = args.save_chunk or config.get("save_chunk", False)
remove_silence = args.remove_silence or config.get("remove_silence", False)
load_vocoder_from_local = args.load_vocoder_from_local or config.get("load_vocoder_from_local", False)

vocoder_name = args.vocoder_name or config.get("vocoder_name", mel_spec_type)
target_rms = args.target_rms or config.get("target_rms", target_rms)
cross_fade_duration = args.cross_fade_duration or config.get("cross_fade_duration", cross_fade_duration)
nfe_step = args.nfe_step or config.get("nfe_step", nfe_step)
cfg_strength = args.cfg_strength or config.get("cfg_strength", cfg_strength)
sway_sampling_coef = args.sway_sampling_coef or config.get("sway_sampling_coef", sway_sampling_coef)
speed = args.speed or config.get("speed", speed)
fix_duration = args.fix_duration or config.get("fix_duration", fix_duration)
device = args.device or config.get("device", device)

if args.ref_dir:
    ref_pairs = get_mmconv_speaker_pairs(args.ref_dir)
else:
    ref_pairs = None

# --------------------------------------------------------
# Vocoder and Model Loading
# --------------------------------------------------------

if vocoder_name == "vocos":
    vocoder_local_path = "../checkpoints/vocos-mel-24khz"
elif vocoder_name == "bigvgan":
    vocoder_local_path = "../checkpoints/bigvgan_v2_24khz_100band_256x"

vocoder = load_vocoder(
    vocoder_name=vocoder_name,
    is_local=load_vocoder_from_local,
    local_path=vocoder_local_path,
    device=device,
)

model_cfg = OmegaConf.load(
    args.model_cfg or config.get("model_cfg", str(files("f5_tts").joinpath(f"configs/{model}.yaml")))
)
model_cls = get_class(f"f5_tts.model.{model_cfg.model.backbone}")
model_arc = model_cfg.model.arch

repo_name, ckpt_step, ckpt_type = "F5-TTS", 1250000, "safetensors"
if model != "F5TTS_Base":
    assert vocoder_name == model_cfg.model.mel_spec.mel_spec_type
if model == "F5TTS_Base":
    if vocoder_name == "vocos":
        ckpt_step = 1200000
    elif vocoder_name == "bigvgan":
        model = "F5TTS_Base_bigvgan"
        ckpt_type = "pt"
elif model == "E2TTS_Base":
    repo_name = "E2-TTS"
    ckpt_step = 1200000

if not ckpt_file:
    ckpt_file = str(cached_path(f"hf://SWivid/{repo_name}/{model}/model_{ckpt_step}.{ckpt_type}"))

print(f"Using {model}...")
ema_model = load_model(
    model_cls, model_arc, ckpt_file, mel_spec_type=vocoder_name, vocab_file=vocab_file, device=device
)

# --------------------------------------------------------
# Main Inference
# --------------------------------------------------------

def main():
    if args.json_file:
        with open(args.json_file, "r", encoding="utf-8") as f:
            json_data = json.load(f)

        for entry in tqdm(json_data, desc="Generating speech"):
            speaker = entry["person"]
            room = entry["room"]
            snippet = entry["snippet"]
            out_path = Path(output_dir) / f"{entry['id']}.wav"

            if args.speaker and args.speaker != speaker:
                continue

            if ref_pairs is None:
                raise ValueError("--ref_dir must be provided with --json_file")

            if speaker not in ref_pairs:
                raise ValueError(f"No reference audio/text found for speaker {speaker}")

            available_refs = list(ref_pairs[speaker][room].items())
            ref_audio_file, ref_text = random.choice(available_refs)

            ref_audio_proc, ref_text_proc = preprocess_ref_audio_text(ref_audio_file, ref_text)

            audio_segment, final_sample_rate, _ = infer_process(
                ref_audio_proc,
                ref_text_proc,
                snippet,
                ema_model,
                vocoder,
                mel_spec_type=vocoder_name,
                target_rms=target_rms,
                cross_fade_duration=cross_fade_duration,
                nfe_step=nfe_step,
                cfg_strength=cfg_strength,
                sway_sampling_coef=sway_sampling_coef,
                speed=speed,
                fix_duration=fix_duration,
                device=device,
            )

            os.makedirs(output_dir, exist_ok=True)
            sf.write(str(out_path), audio_segment, final_sample_rate)
            print(f"Saved {out_path}")

    else:
        # Fall back to original behavior: Single file/text generation
        if args.gen_file:
            gen_text = codecs.open(args.gen_file, "r", "utf-8").read()
        voices = {"main": {"ref_audio": ref_audio, "ref_text": ref_text}}
        for v in voices:
            voices[v]["ref_audio"], voices[v]["ref_text"] = preprocess_ref_audio_text(
                voices[v]["ref_audio"], voices[v]["ref_text"]
            )

        generated_audio_segments = []
        reg1 = r"(?=\[\w+\])"
        chunks = re.split(reg1, gen_text)
        reg2 = r"\[(\w+)\]"
        for text in chunks:
            if not text.strip():
                continue
            match = re.match(reg2, text)
            voice = match[1] if match else "main"
            text = re.sub(reg2, "", text).strip()
            audio_segment, final_sample_rate, _ = infer_process(
                voices[voice]["ref_audio"],
                voices[voice]["ref_text"],
                text,
                ema_model,
                vocoder,
                mel_spec_type=vocoder_name,
                target_rms=target_rms,
                cross_fade_duration=cross_fade_duration,
                nfe_step=nfe_step,
                cfg_strength=cfg_strength,
                sway_sampling_coef=sway_sampling_coef,
                speed=speed,
                fix_duration=fix_duration,
                device=device,
            )
            generated_audio_segments.append(audio_segment)

        if generated_audio_segments:
            final_wave = np.concatenate(generated_audio_segments)
            os.makedirs(output_dir, exist_ok=True)
            sf.write(str(Path(output_dir) / output_file), final_wave, final_sample_rate)
            if remove_silence:
                remove_silence_for_generated_wav(str(Path(output_dir) / output_file))

if __name__ == "__main__":
    main()
