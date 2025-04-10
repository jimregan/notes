---
toc: true
layout: post
description: RoboSpatial is low-energy on information required to run it
title: Low-energy dockerfile for RoboSpatial
categories: [docker, laziness, robospatial, hsi]
---

[RoboSpatial](https://github.com/chanhee-luke/RoboSpatial-Eval) is lacking most of the key information needed to run it.


```docker
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel
RUN apt update
RUN apt install -y git git-lfs g++
RUN git lfs install
RUN git clone https://github.com/chanhee-luke/RoboSpatial-Eval
RUN pip install numpy tqdm pyyaml datasets
RUN python RoboSpatial-Eval/download_benchmark.py robospatial
RUN pip install einops
RUN pip install accelerate
RUN pip install -U huggingface-hub transformers
RUN pip install git+https://github.com/LLaVA-VL/LLaVA-NeXT
RUN pip install git+https://github.com/TIGER-AI-Lab/Mantis
RUN pip install flash-attn==2.3.6
RUN pip install git+https://github.com/wentaoyuan/RoboPoint
# Needed for Qwen2-VL, breaks everything else but Molmo (which is already broken)
# RUN pip install -U transformers

COPY config.yaml /workspace/RoboSpatial-Eval
COPY models--meta-llama--Meta-Llama-3-8B-Instruct /root/.cache/huggingface/hub/models--meta-llama--Meta-Llama-3-8B-Instruct

WORKDIR /workspace/RoboSpatial-Eval
```

With `config.yaml`:

```yaml
# RoboSpatial Evaluation Configuration

# Dataset paths
datasets:
  robospatial_home:
    data_dir: "/workspace/robospatial"  # Root directory containing JSON files and images/ folder

# Output configuration
output:
  output_dir: "/results"  # Full path to where results will be stored
```

Build with:

```bash
docker build -t robospatial .
```

Run with:

```bash
docker run -it --entrypoint /bin/bash -v'/home/joregan/rs_results:/results' --gpus all robospatial
```

