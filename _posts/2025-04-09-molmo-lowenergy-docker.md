---
toc: true
layout: post
description: The version of Molmo relies on old Transformers
title: Low-energy dockerfile for Molmo
categories: [docker, laziness, molmo, hsi]
---


```docker
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

RUN pip install --upgrade pip setuptools wheel
RUN pip install numpy==1.26.4 \
    torch==2.1.0 \
    torchvision==0.16.0 \
    transformers==4.36.2 \
    accelerate==0.25.0 \
    sentencepiece \
    safetensors einops \
    tensorflow-cpu==2.15.0
```


Build with:

```bash
docker build -t molmo .
```

Run with:

```bash
docker run -it --entrypoint /bin/bash -v'/home/joregan/rs_results:/results' --gpus all molmo
```

