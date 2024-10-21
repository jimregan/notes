---
toc: true
layout: post
description: I have to use docker.
title: Low-energy dockerfile for WhisperX
categories: [docker, laziness, whisperx]
---

```docker
FROM pytorch/pytorch
RUN apt update
RUN apt install -y git
RUN pip install git+https://github.com/m-bain/whisperX
#RUN python -c 'from whisperx.asr import load_model; load_model("large-v3", "cpu")'
RUN python -c 'from faster_whisper.utils import download_model; download_model("large-v3")'
```

Run with:

```bash
docker run -it --entrypoint /bin/bash -v'/home/joregan/tmpf:/audio' --gpus all whisperx
```

