---
toc: true
layout: post
description: WhisperX is unmaintained, use a fork that at least pays attention to dependencies.
title: Low-energy dockerfile for WhisperX
categories: [docker, laziness, whisperx]
---
Update of [this]({% post_url 2024-10-14-whisperx-lowenergy-docker %})


```docker
FROM pytorch/pytorch
RUN apt update
RUN apt install -y git git-lfs g++
RUN git lfs install
RUN git clone https://github.com/chanhee-luke/RoboSpatial-Eval
RUN pip install numpy tqdm pyyaml datasets
RUN python RoboSpatial-Eval/download_benchmark.py robospatial
RUN pip install git+https://github.com/huggingface/transformers
RUN pip install llava-torch

COPY config.yaml /workspace/RoboSpatial-Eval

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


Run with:

```bash
docker run -it --entrypoint /bin/bash -v'/home/joregan/rs_results:/results' --gpus all robospatial
```

