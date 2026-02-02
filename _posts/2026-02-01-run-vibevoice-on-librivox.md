---
toc: true
layout: post
hidden: true
description: For sanity(?)
title: Run VibeVoice on Librivox
categories: [librivox, chatgpt, vibevoice]
---

```python
#!/usr/bin/env python3
import argparse, json, time
from pathlib import Path
import torch

from vibevoice.modular.modeling_vibevoice_asr import VibeVoiceASRForConditionalGeneration
from vibevoice.processor.vibevoice_asr_processor import VibeVoiceASRProcessor

AUDIO_EXTS = {".wav",".mp3",".flac",".mp4",".m4a",".webm",".ogg",".opus"}

def list_audio_files(audio_dir: str) -> list[str]:
    root = Path(audio_dir)
    return sorted(str(p) for p in root.rglob("*") if p.is_file() and p.suffix.lower() in AUDIO_EXTS)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--model_path", required=True)
    ap.add_argument("--audio_dir", default="")
    ap.add_argument("--audio_files", nargs="*", default=[])
    ap.add_argument("--out_dir", required=True)
    ap.add_argument("--device", default="cuda" if torch.cuda.is_available() else "cpu",
                    choices=["cuda","cpu","mps","xpu","auto"])
    ap.add_argument("--attn_implementation", default="sdpa",
                    choices=["flash_attention_2","sdpa","eager"])
    ap.add_argument("--max_new_tokens", type=int, default=32768)
    ap.add_argument("--temperature", type=float, default=0.0)
    ap.add_argument("--top_p", type=float, default=1.0)
    ap.add_argument("--num_beams", type=int, default=1)
    args = ap.parse_args()

    files = []
    if args.audio_dir:
        files.extend(list_audio_files(args.audio_dir))
    files.extend(args.audio_files)
    if not files:
        raise SystemExit("No audio files found. Use --audio_dir or --audio_files.")

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    dtype = torch.float32 if args.device in ("cpu","mps","xpu") else torch.bfloat16

    processor = VibeVoiceASRProcessor.from_pretrained(args.model_path)
    model = VibeVoiceASRForConditionalGeneration.from_pretrained(
        args.model_path,
        dtype=dtype,
        device_map=args.device if args.device == "auto" else None,
        attn_implementation=args.attn_implementation,
        trust_remote_code=True,
    )
    if args.device != "auto":
        model = model.to(args.device)
        device = args.device
    else:
        device = next(model.parameters()).device
    model.eval()

    do_sample = args.temperature > 0

    for f in files:
        inputs = processor(
            audio=f,
            sampling_rate=None,
            return_tensors="pt",
            add_generation_prompt=True,
        )
        inputs = {k: v.to(device) if isinstance(v, torch.Tensor) else v for k,v in inputs.items()}

        gen_cfg = {
            "max_new_tokens": args.max_new_tokens,
            "do_sample": do_sample,
            "num_beams": args.num_beams,
            "pad_token_id": processor.pad_id,
            "eos_token_id": processor.tokenizer.eos_token_id,
        }
        if do_sample:
            gen_cfg["temperature"] = args.temperature
            gen_cfg["top_p"] = args.top_p

        t0 = time.time()
        with torch.no_grad():
            output_ids = model.generate(**inputs, **gen_cfg)
        _ = time.time() - t0  # not used; you asked for JSON only

        generated_ids = output_ids[0, inputs["input_ids"].shape[1]:]
        raw_text = processor.decode(generated_ids, skip_special_tokens=True)

        # parse into segments
        try:
            segments = processor.post_process_transcription(raw_text)
        except Exception:
            segments = []

        # convert to Gradio-style JSON list
        out_list = []
        for seg in segments:
            item = {
                "Start": seg.get("start_time"),
                "End": seg.get("end_time"),
                "Content": seg.get("text", ""),
            }
            spk = seg.get("speaker_id", None)
            if spk is not None:
                item["Speaker"] = spk
            out_list.append(item)

        out_path = out_dir / (Path(f).stem + ".json")
        out_path.write_text(json.dumps(out_list, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"✅ wrote {out_path} ({len(out_list)} segments)")

if __name__ == "__main__":
    main()
```

Running with:


```bash
for d in /data/*/*; do if [ -d $d ];then for f in $d/*.mp3;do json=$(echo $f|sed -e 's/mp3$/json/'); if [ ! -e $json ];then python vibevoice/scripts/transcribe.py --model_path /app/models/VibeVoice-ASR --audio_files $f --out_dir $d;fi;done;fi;done
done
```

ChatGPT cleanup:

```bash
for d in /data/*/*; do
  if [ -d "$d" ]; then
    for f in "$d"/*.mp3; do
      [ -e "$f" ] || continue  # skip if no mp3s matched

      json="${f%.mp3}.json"
      if [ ! -e "$json" ]; then
        python vibevoice/scripts/transcribe.py \
          --model_path /app/models/VibeVoice-ASR \
          --audio_files "$f" \
          --out_dir "$d"
      fi
    done
  fi
done
```

