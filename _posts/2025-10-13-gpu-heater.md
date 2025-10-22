---
toc: true
layout: post
description: ChatGPT generated code to keep the office warm
title: GPU heater
categories: [heating, gpu, chatgpt]
---

```python
# heater_max.py — multi-stream tensor-core heater
import os, torch

assert torch.cuda.is_available(), "CUDA not available"
torch.backends.cuda.matmul.allow_tf32 = True  # good on Ampere
try:
    torch.set_float32_matmul_precision("high")
except Exception:
    pass

dev = "cuda"
N   = int(os.environ.get("HEAT_SIZE", "16384"))    # 16–24k if you have the VRAM
REPS= int(os.environ.get("HEAT_REPS", "16"))       # more reps = more heat
STREAMS = int(os.environ.get("HEAT_STREAMS", "4")) # 2–8 streams works well
DT  = os.environ.get("HEAT_DTYPE", "fp16")         # fp16|bf16|fp32
dtype = {"fp16": torch.float16, "bf16": torch.bfloat16, "fp32": torch.float32}[DT]

# pre-allocate per-stream tensors to avoid allocator churn
pairs = []
streams = [torch.cuda.Stream() for _ in range(STREAMS)]
for _ in range(STREAMS):
    a = torch.randn((N, N), device=dev, dtype=dtype)
    b = torch.randn((N, N), device=dev, dtype=dtype)
    pairs.append((a, b))

print("GPU:", torch.cuda.get_device_name(0), "N:", N, "dtype:", dtype,
      "streams:", STREAMS, "reps:", REPS)

while True:
    for s, (a, b) in zip(streams, pairs):
        with torch.cuda.stream(s):
            c = a @ b
            for _ in range(REPS - 1):
                c = c @ b  # chain matmuls to keep units loaded
    torch.cuda.synchronize()
```