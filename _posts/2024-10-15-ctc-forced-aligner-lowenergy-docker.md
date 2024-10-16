---
toc: true
layout: post
description: I have to use docker.
title: Low-energy dockerfile for ctc-forced-aligner
categories: [docker, laziness, ctc-forced-aligner]
---

Uses [MahmoudAshraf97/ctc-forced-aligner](https://github.com/MahmoudAshraf97/ctc-forced-aligner)


```docker
FROM pytorch/pytorch
RUN apt update
RUN apt install -y git g++
RUN pip install git+https://github.com/MahmoudAshraf97/ctc-forced-aligner.git
```

Run with:

```bash
docker run -it --entrypoint /bin/bash -v'/home/joregan/tmpf:/audio' --gpus all ctc-forced-aligner
```

