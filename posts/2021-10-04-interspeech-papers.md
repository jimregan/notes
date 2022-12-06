---
toc: true
layout: post
hidden: true
description: Interesting papers from Interspeech
title: Interspeech papers
categories: [links]
---

[End-to-End Spelling Correction Conditioned on Acoustic Feature for Code-Switching Speech Recognition](https://www.isca-speech.org/archive/interspeech_2021/zhang21d_interspeech.html)

Shuai Zhang, Jiangyan Yi, Zhengkun Tian, Ye Bai, Jianhua Tao, Xuefei Liu, Zhengqi Wen

[PDF](https://www.isca-speech.org/archive/pdfs/interspeech_2021/zhang21d_interspeech.pdf)

```bibtex
{% raw %}
@inproceedings{zhang21d_interspeech,
  author={Shuai Zhang and Jiangyan Yi and Zhengkun Tian and Ye Bai and Jianhua Tao and Xuefei Liu and Zhengqi Wen},
  title={{End-to-End Spelling Correction Conditioned on Acoustic Feature for Code-Switching Speech Recognition}},
  year=2021,
  booktitle={Proc. Interspeech 2021},
  pages={266--270},
  doi={10.21437/Interspeech.2021-1242}
}
{% endraw %}
```

Spell checking as conditioned language model for code-switching in ASR.

Dataset:
- ASRU 2019 Mandarin-English code-switching Challenge dataset
  - 500 hours Mandarin
  - 200 hours code-switching
  - only used code-switching

Augmentation:
- ASR text:
  - 10-fold cross validation
  - beam size 10
- audio:
  - SpecAugment
  - dropout

Metric:
- Mix error rate (MER): WER for English, CER for Mandarin

Experimental setup:
- ASR
  - Kaldi
  - 40-dim Mel filter-bank
  - 25ms windowing
  - 10ms frame shift
  - 3 * 2D CNN downsampling layers w/ stride 2 for acoustic features
  - attention dimensions 256 for both encode and decoder
  - 4 heards
  - position-wise feed-forward networks dim 1024
  - 12 encoder blocks, 6 decoder blocks
- LM
  - 6-gram, KenLM
  - unidirectional LSTM
- Spelling correction
  - Encoder/decoder dims 256, num. heads: 4
  - position-wise feed-forward networks dim 512
  - dimension conversion layer to unify text & acoustic features
  - uniform label smoothing, 0.1
  - residual dropout: 0.1 applied to each sub-block
  - learning rate set by warm up
  - average last 5 checkpoints
  - wordpiece vocab: 1k for English, Chinese characters appearing more than 5 times in training set

---

[Phoneme Recognition Through Fine Tuning of Phonetic Representations: A Case Study on Luhya Language Varieties](https://www.isca-speech.org/archive/interspeech_2021/siminyu21_interspeech.html)

Kathleen Siminyu, Xinjian Li, Antonios Anastasopoulos, David R. Mortensen, Michael R. Marlo, Graham Neubig

[PDF](https://www.isca-speech.org/archive/pdfs/interspeech_2021/siminyu21_interspeech.pdf),
[arXiv](https://arxiv.org/abs/2104.01624)

```bibtex
{% raw %}
@inproceedings{siminyu21_interspeech,
  author={Kathleen Siminyu and Xinjian Li and Antonios Anastasopoulos and David R. Mortensen and Michael R. Marlo and Graham Neubig},
  title={{Phoneme Recognition Through Fine Tuning of Phonetic Representations: A Case Study on Luhya Language Varieties}},
  year=2021,
  booktitle={Proc. Interspeech 2021},
  pages={271--275},
  doi={10.21437/Interspeech.2021-1434}
}
{% endraw %}
```

Fine tuning of [allosaurus](https://github.com/xinjli/allosaurus) ("universal phone recognizer") for three varieties of Luhya.

Data:
- Saamia
  - bible.is via [CMU Wilderness](https://github.com/festvox/datasets-CMU_Wilderness)
  - 18.2 hours
- Bukusu
  - Dictionary pronunciations
  - 3.7 hours
- East Tusom
  - [Tusom2021](https://github.com/dmort27/tusom2021)
  - 55.3 minutes
- G2P with epitran
- Splits:
  - Bukusu: 6442 (train), 1001 (dev), 2458 (test)
  - Saamia: 7254 (train), 1000 (dev), 1500 (test)
  - East Tusom: 1600 (train), 400 (dev), 392 (test)

Experiment:
  - sizes: 10, 25, 50, 100, 250, 500 and 1000 (approx. doubling progression)
  - fine-tuning is done on one model: same encoder
    - 6 layer bilstm
    - hidden size 1024 per layer
  - 250 epochs of fine tuning

Results: PER (relative improvement)

|                      | Bukusu       | Saamia       | East Tusom   |
| -------------------- | ------------ | ------------ | ------------ |
| Allosaurus           | 72.8         | 63.7         | 67.5         |
| & constraint         | 52.5         | 37.4         | 56.7         |
| -------------------- | ------------ | ------------ | ------------ |
| & fine-tuning (100)  | 41.2 (21.5%) | 15.5 (58.5%) | 44.8 (20.9%) |
| & fine-tuning (1000) | 17.3 (67.0%) | 11.7 (65.7%) | 34.6 (38.9%) |
| & fine-tuning (all)  | 5.2 (90.1%)  | 9.2 (75.4%)  | 33.1 (41.6%) |

---

[Exploring wav2vec 2.0 on Speaker Verification and Language Identification](https://www.isca-speech.org/archive/interspeech_2021/fan21_interspeech.html)

Zhiyun Fan, Meng Li, Shiyu Zhou, Bo Xu

[PDF](https://www.isca-speech.org/archive/pdfs/interspeech_2021/fan21_interspeech.pdf)

```bibtex
{% raw %}
@inproceedings{fan21_interspeech,
  author={Zhiyun Fan and Meng Li and Shiyu Zhou and Bo Xu},
  title={{Exploring wav2vec 2.0 on Speaker Verification and Language Identification}},
  year=2021,
  booktitle={Proc. Interspeech 2021},
  pages={1509--1513},
  doi={10.21437/Interspeech.2021-1280}
}
{% endraw %}
```

Finetunes **monolingual English** wav2vec model for speaker verification and/or language ID.

- Fine tuning
  - average pooling layer and fully connected layer
  - Loss: cross-entropy (AM-softmax for speaker classification)

- Fine tuning, multi-task (speaker + language)
  - average pooling, two parallel fully connected layers
  - loss is weighted sum of individual losses

- Datasets
  - VoxCeleb1 (speaker verification)
  - AP17-OLR (language ID)

- Metric
  - Equal error rate (EER)

Results (single):
- SV: 3.61
- LID: 3.47

Results (multitask):
- SV: 4.18
- LID: 4.88

---

[Low Resource ASR: The Surprising Effectiveness of High Resource Transliteration](https://www.isca-speech.org/archive/interspeech_2021/khare21_interspeech.html)

Shreya Khare, Ashish Mittal, Anuj Diwan, Sunita Sarawagi, Preethi Jyothi, Samarth Bharadwaj

[pdf](https://www.isca-speech.org/archive/pdfs/interspeech_2021/khare21_interspeech.pdf)

```bibtex
{% raw %}
@inproceedings{khare21_interspeech,
  author={Shreya Khare and Ashish Mittal and Anuj Diwan and Sunita Sarawagi and Preethi Jyothi and Samarth Bharadwaj},
  title={{Low Resource ASR: The Surprising Effectiveness of High Resource Transliteration}},
  year=2021,
  booktitle={Proc. Interspeech 2021},
  pages={1529--1533},
  doi={10.21437/Interspeech.2021-2062}
{% endraw %}
}
```

Uses text in a second language transliterated to target language to augment training data for ASR.

> We observe that for languages like
> Hindi and Telugu where the KL distance in phone distribution
> is small *and* the transliteration PER is low, we get consistent
> gains across different architectures and training data sizes.

- G2P: epitran, [g2ps](https://github.com/uiuc-sst/g2ps)
- Tools: ESPnet, wav2vec2
- Datasets
  - Microsoft Speech Corpus (Indian Languages): Gujarati and Telugu
  - Hindi ASR Challenge dataset
  - OpenSLR Large Bengali dataset
  - Zeroth Korean
  - ALFFA Amharic

> there’s a significant improvement in performance across both training settings with using
> Hindi instead of English during pretraining. Using both transliterated English and Hindi data during pretraining for the 10-hour
> Gujarati task further reduces WERs from 55.8% to 32.4%

---

[Improving Accent Identification and Accented Speech Recognition Under a Framework of Self-Supervised Learning](https://www.isca-speech.org/archive/interspeech_2021/deng21b_interspeech.html)
[pdf](https://www.isca-speech.org/archive/pdfs/interspeech_2021/deng21b_interspeech.pdf)
```bibtex
{% raw %}
@inproceedings{deng21b_interspeech,
  author={Keqi Deng and Songjun Cao and Long Ma},
  title={{Improving Accent Identification and Accented Speech Recognition Under a Framework of Self-Supervised Learning}},
  year=2021,
  booktitle={Proc. Interspeech 2021},
  pages={1504--1508},
  doi={10.21437/Interspeech.2021-1186}
}
{% endraw %}
```

Fine tuning wav2vec2 for accented speech recognition/accent ID

Dataset:
  - LibriSpeech (pretrain)
  - AESRC2020 (finetune)

---

## TODO

[Robust wav2vec 2.0: Analyzing Domain Shift in Self-Supervised Pre-Training](https://www.isca-speech.org/archive/interspeech_2021/hsu21_interspeech.html)

[AST: Audio Spectrogram Transformer](https://www.isca-speech.org/archive/interspeech_2021/gong21b_interspeech.html)

[Raw Waveform Encoder with Multi-Scale Globally Attentive Locally Recurrent Networks for End-to-End Speech Recognition](https://www.isca-speech.org/archive/interspeech_2021/lam21_interspeech.html)

[Y-Vector: Multiscale Waveform Encoder for Speaker Embedding](https://www.isca-speech.org/archive/interspeech_2021/zhu21b_interspeech.html)

[Speech Acoustic Modelling Using Raw Source and Filter Components](https://www.isca-speech.org/archive/interspeech_2021/loweimi21_interspeech.html)

[Leveraging Phone Mask Training for Phonetic-Reduction-Robust E2E Uyghur Speech Recognition](https://www.isca-speech.org/archive/interspeech_2021/ma21_interspeech.html)

[Rethinking Evaluation in ASR: Are Our Models Robust Enough?](https://www.isca-speech.org/archive/interspeech_2021/likhomanenko21_interspeech.html)

[wav2vec-C: A Self-Supervised Model for Speech Representation Learning](https://www.isca-speech.org/archive/interspeech_2021/sadhu21_interspeech.html)

[Multimodal Speech Summarization Through Semantic Concept Learning](https://www.isca-speech.org/archive/interspeech_2021/palaskar21_interspeech.html)

[A Noise Robust Method for Word-Level Pronunciation Assessment](https://www.isca-speech.org/archive/interspeech_2021/lin21_interspeech.html)

[Improving RNN-T for Domain Scaling Using Semi-Supervised Training with Neural TTS](https://www.isca-speech.org/archive/interspeech_2021/deng21_interspeech.html)

[Phonetically Motivated Self-Supervised Speech Representation Learning](https://www.isca-speech.org/archive/interspeech_2021/yue21_interspeech.html)

[slimIPL: Language-Model-Free Iterative Pseudo-Labeling](https://www.isca-speech.org/archive/interspeech_2021/likhomanenko21b_interspeech.html)

[Semi-Supervision in ASR: Sequential MixMatch and Factorized TTS-Based Augmentation](https://www.isca-speech.org/archive/interspeech_2021/chen21c_interspeech.html)

[A Comparison of Supervised and Unsupervised Pre-Training of End-to-End Models](https://www.isca-speech.org/archive/interspeech_2021/misra21_interspeech.html)

[Momentum Pseudo-Labeling for Semi-Supervised Speech Recognition](https://www.isca-speech.org/archive/interspeech_2021/higuchi21_interspeech.html)

[On the Learning Dynamics of Semi-Supervised Training for ASR](https://www.isca-speech.org/archive/interspeech_2021/wallington21_interspeech.html)

[Improving Streaming Transformer Based ASR Under a Framework of Self-Supervised Learning](https://www.isca-speech.org/archive/interspeech_2021/cao21b_interspeech.html)

[Data Augmentation Methods for End-to-End Speech Recognition on Distant-Talk Scenarios](https://www.isca-speech.org/archive/interspeech_2021/tsunoo21_interspeech.html)

[Multi-Channel Transformer Transducer for Speech Recognition](https://www.isca-speech.org/archive/interspeech_2021/chang21_interspeech.html)

[Scaling Sparsemax Based Channel Selection for Speech Recognition with ad-hoc Microphone Arrays](https://www.isca-speech.org/archive/interspeech_2021/chen21b_interspeech.html)

[IR-GAN: Room Impulse Response Generator for Far-Field Speech Recognition](https://www.isca-speech.org/archive/interspeech_2021/ratnarajah21_interspeech.html)

[Noise Robust Acoustic Modeling for Single-Channel Speech Recognition Based on a Stream-Wise Transformer Architecture](https://www.isca-speech.org/archive/interspeech_2021/fujimoto21_interspeech.html)

[Phoneme-Aware and Channel-Wise Attentive Learning for Text Dependent Speaker Verification](https://www.isca-speech.org/archive/interspeech_2021/liu21_interspeech.html)

