---
toc: true
layout: post
hidden: true
description: Misc. interesting things.
title: Interesting links, roughly 15/9/2021
categories: [links]
---

[H5P](https://h5p.org/) -- used for learning materials on TG4 and Tuairisc

Commits on transformers: [Add SpeechEncoderDecoder & Speech2Text2](https://github.com/huggingface/transformers/commit/0b8c84e110bf9012f30a85c40b9ff8ea868689fd),
[Add the AudioClassificationPipeline](https://github.com/huggingface/transformers/commit/b9c6a976949681113c8686215ebdef4de53b3d2f),
[Add Wav2Vec2 & Hubert ForSequenceClassification](https://github.com/huggingface/transformers/commit/b6f332ecaf18054109294dd2efa1a5e6aa274a03) (based on converting s3rpl checkpoints)

[monologg/JointBERT](https://github.com/monologg/JointBERT) -- (Unofficial) Pytorch implementation of [JointBERT: BERT for Joint Intent Classification and Slot Filling](https://arxiv.org/abs/1902.10909)

[deezer/spleeter](https://github.com/deezer/spleeter) -- Deezer source separation library including pretrained models.

[VoxLingua107: a Dataset for Spoken Language Recognition](https://arxiv.org/abs/2011.12998) -- no Irish

[Appen/UHV-OTS-Speech](https://github.com/Appen/UHV-OTS-Speech) -- A data annotation pipeline to generate high-quality, large-scale speech datasets with machine pre-labeling and fully manual auditing.
[Paper](https://openreview.net/forum?id=-OFOwaDriw7)

[The Effects of Automatic Speech Recognition Quality on Human Transcription Latency](https://www.cs.cmu.edu/~fmetze/interACT/Publications_files/publications/asr_threshold_w4a.pdf)

```bibtex
@inproceedings{gaur16latency,
  author    = {Yashesh Gaur and
               Walter S. Lasecki and
               Florian Metze and
               Jeffrey P. Bigham},
  editor    = {Gregory R. Gay and
               Tiago Jo{\~{a}}o Guerreiro},
  title     = {{The Effects of Automatic Speech Recognition Quality on Human Transcription Latency}},
  booktitle = {Proceedings of the 13th Web for All Conference, {W4A} '16, Montreal,
               Canada, April 11-13, 2016},
  pages     = {23:1--23:8},
  publisher = {{ACM}},
  year      = {2016},
  doi       = {10.1145/2899475.2899478},
}
```

[BirgerMoell/tmh](https://github.com/BirgerMoell/tmh)

[as-ideas/DeepPhonemizer](https://github.com/as-ideas/DeepPhonemizer)
See: [Transformer based Grapheme-to-Phoneme Conversion](https://arxiv.org/abs/2004.06338)

[Unifying Speech and Gesture Synthesis](https://www.unite.ai/unifying-speech-and-gesture-synthesis/)

[Locals create CD-ROM celebrating Gaeltacht area of Dun Chaochain](https://www.irishtimes.com/news/locals-create-cd-rom-celebrating-gaeltacht-area-of-dun-chaochain-1.210322)

Facebook's latest:
[Textless NLP: Generating expressive speech from raw audio](https://ai.facebook.com/blog/textless-nlp-generating-expressive-speech-from-raw-audio)
[Demo](https://speechbot.github.io/pgslm/)
[Code](https://github.com/pytorch/fairseq/tree/main/examples/textless_nlp),
[Generative Spoken Language Modeling from Raw Audio](https://arxiv.org/abs/2102.01192),
[Speech Resynthesis from Discrete Disentangled Self-Supervised Representations](https://arxiv.org/abs/2104.00355),
[Text-Free Prosody-Aware Generative Spoken Language Modeling](https://arxiv.org/abs/2109.03264)

[AIdeaLab/wav2vec2_docker](https://github.com/AIdeaLab/wav2vec2_docker) -- pretraining wav2vec docker for sagemaker

[as-ideas/DeepForcedAligner](https://github.com/as-ideas/DeepForcedAligner)

[citizensinformation.ie mojibake](https://www.citizensinformation.ie/ga/reuse_psi.html)

[kingabzpro/fine-tuning-xlsr-wav2vec2-for-wolof-asr-with](https://www.kaggle.com/kingabzpro/fine-tuning-xlsr-wav2vec2-for-wolof-asr-with)

[ceyda/wav2vec2-base-760](https://huggingface.co/ceyda/wav2vec2-base-760) -- Turkish wav2vec2 base model

[Excessive GPU-GPU communication with GPT2 making multi-GPU training slow?](https://github.com/huggingface/transformers/issues/9371)

[Vosk LM](https://alphacephei.com/vosk/lm)

[Svito-zar/gesticulator](https://github.com/Svito-zar/gesticulator)

`run_cleanup_segmentation.sh` from [malach](https://github.com/kaldi-asr/kaldi/blob/master/egs/malach/s5/local/run_cleanup_segmentation.sh), based on
[AMI](https://github.com/kaldi-asr/kaldi/blob/master/egs/ami/s5b/local/run_cleanup_segmentation.sh), in turn based on
[Tedlium](https://github.com/kaldi-asr/kaldi/blob/master/egs/tedlium/s5_r2/local/run_segmentation_long_utts.sh)
