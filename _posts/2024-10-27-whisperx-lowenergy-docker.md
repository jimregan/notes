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
RUN apt install -y git
RUN pip install git+https://github.com/federicotorrielli/BetterWhisperX
RUN python -c 'from faster_whisper.utils import download_model; download_model("large-v3")'
```

Run with:

```bash
docker run -it --entrypoint /bin/bash -v'/home/joregan/tmpf:/audio' --gpus all whisperx
```

