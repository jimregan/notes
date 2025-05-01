---
toc: true
layout: post
description: There are a lot of semi-unwritten details
title: Low-energy dockerfile for GroundingGPT
categories: [docker, laziness, groundinggpt, hsi]
---


```docker
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-devel

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y git curl libglib2.0-0 libsm6 libxext6 libxrender-dev python3-opencv
RUN pip install --upgrade pip setuptools wheel

RUN git clone https://github.com/lzw-lzw/GroundingGPT.git
WORKDIR GroundingGPT

RUN pip install flash-attn==2.4.1
RUN pip install -r requirements.txt
RUN pip install -U huggingface_hub
RUN pip install webdataset

RUN apt install git-lfs
RUN git lfs install
RUN mkdir /ckpt
RUN git clone https://huggingface.co/zwli/GroundingGPT /ckpt/GroundingGPT
RUN mkdir /ckpt/imagebind
RUN curl https://dl.fbaipublicfiles.com/imagebind/imagebind_huge.pth > /ckpt/imagebind/imagebind_huge.pth
RUN curl https://storage.googleapis.com/sfr-vision-language-research/LAVIS/models/BLIP2/blip2_pretrained_flant5xxl.pth > /ckpt/blip2_pretrained_flant5xxl.pth

ENV TRANSFORMERS_DYNAMIC_MODULE_NAME="trusted"
```


Build with:

```bash
docker build -t ggpt .
```

Run with:

```bash
docker run -it --entrypoint /bin/bash -v'/home/joregan/rs_results:/results' --gpus all ggpt
```
