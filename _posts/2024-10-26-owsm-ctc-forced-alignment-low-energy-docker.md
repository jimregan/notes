---
toc: true
layout: post
description: I have to use docker.
title: Low-energy dockerfile for owsm-ctc forced alignment
categories: [docker, laziness, ctc-forced-aligner, owsm]
---

```docker
FROM pytorch/pytorch
RUN apt update
RUN apt install -y git git-lfs g++
RUN git lfs install
RUN pip install librosa
RUN pip install git+https://github.com/pyf98/espnet@owsm-ctc
RUN pip install espnet_model_zoo
RUN git clone https://huggingface.co/pyf98/owsm_ctc_v3.2_ft_1B

COPY aligner.py /workspace
```

And this is `aligner.py`

```python
import soundfile as sf
from espnet2.bin.s2t_ctc_align import CTCSegmentation
import argparse


def get_aligner(lang_sym="<eng>"):
    aligner = CTCSegmentation(
        s2t_model_file="owsm_ctc_v3.2_ft_1B/exp/s2t_train_s2t_multitask-ctc_ebf27_conv2d8_size1024_raw_bpe50000/valid.total_count.ave_5best.till45epoch.pth",
        fs=16000,
        ngpu=1,
        batch_size=16,
        kaldi_style_text=True,
        time_stamps="fixed",
        samples_to_frames_ratio=1280,
        lang_sym=lang_sym,
        task_sym="<asr>",
        context_len_in_secs=2,
        frames_per_sec=12.5,
    )


def getargs():
    parser = argparse.ArgumentParser()
    parser.add_argument('text', type=argparse.FileType('r'))

    parser.add_argument('--language', type=str, default="eng")
    return parser.parse_args()
```
