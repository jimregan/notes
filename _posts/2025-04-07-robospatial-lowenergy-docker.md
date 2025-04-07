---
toc: true
layout: post
description: RoboSpatial is low-energy on information required to run it
title: Low-energy dockerfile for RoboSpatial
categories: [docker, laziness, robospatial]
---


```docker
FROM pytorch/pytorch
RUN apt update
RUN apt install -y git git-lfs g++
RUN git lfs install
RUN git clone https://github.com/chanhee-luke/RoboSpatial-Eval
RUN pip install numpy tqdm pyyaml datasets
RUN python RoboSpatial-Eval/download_benchmark.py robospatial
RUN pip install einops
RUN pip install git+https://github.com/LLaVA-VL/LLaVA-NeXT
RUN pip install accelerate
RUN pip install -U huggingface-hub transformers
#RUN pip install mantis-tsfm

COPY config.yaml /workspace/RoboSpatial-Eval
RUN mkdir -p /root/.cache/huggingface/hub/
COPY models--meta-llama--Meta-Llama-3-8B-Instruct /root/.cache/huggingface/hub/

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
docker run -it -e HF_TOKEN=$(cat ~/.huggingface/token) --entrypoint /bin/bash -v'/home/joregan/rs_results:/results' --gpus all robospatial
```

