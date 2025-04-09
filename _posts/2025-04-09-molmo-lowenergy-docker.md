---
toc: true
layout: post
description: The version of Molmo relies on old Transformers
title: Low-energy dockerfile for Molmo
categories: [docker, laziness, molmo, hsi]
---


```docker
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y git curl libglib2.0-0 libsm6 libxext6 libxrender-dev
RUN pip install --upgrade pip setuptools wheel
RUN pip install \
    numpy==1.26.4 \
    torch==2.1.0 \
    torchvision==0.16.0 \
    transformers==4.37.2 \
    accelerate==0.25.0 \
    einops \
    sentencepiece \
    safetensors \
    tensorflow-cpu==2.15.0

ENV TRANSFORMERS_DYNAMIC_MODULE_NAME="trusted"

# Download model and processor at build time to avoid runtime fetch
RUN python -c "from transformers import AutoModelForCausalLM, AutoProcessor; \
AutoModelForCausalLM.from_pretrained('allenai/Molmo-7B-D-0924', trust_remote_code=True, torch_dtype='auto', cache_dir='/workspace/.hf_cache'); \
AutoProcessor.from_pretrained('allenai/Molmo-7B-D-0924', trust_remote_code=True, cache_dir='/workspace/.hf_cache')"
```


Build with:

```bash
docker build -t molmo .
```

Run with:

```bash
docker run -it --entrypoint /bin/bash -v'/home/joregan/rs_results:/results' --gpus all molmo
```

Something was happening with this, so I had to try to find why the wrong
version of transformers kept popping up:

```docker
FROM python:3.10-slim

# Avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git curl build-essential && \
    pip install --upgrade pip

# Install only transformers and dependencies
RUN pip install transformers==4.37.2

# Check if TextKwargs is available
RUN python -c "from transformers.processing_utils import TextKwargs; print('✅ TextKwargs is present:', TextKwargs)"
```

