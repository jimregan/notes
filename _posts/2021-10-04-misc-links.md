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
}
```

Uses text in a second language transliterated to target language to augment training data for ASR.

---

[Improving Accent Identification and Accented Speech Recognition Under a Framework of Self-Supervised Learning](https://www.isca-speech.org/archive/interspeech_2021/deng21b_interspeech.html)
[pdf](https://www.isca-speech.org/archive/pdfs/interspeech_2021/deng21b_interspeech.pdf)
```bibtex
@inproceedings{deng21b_interspeech,
  author={Keqi Deng and Songjun Cao and Long Ma},
  title={{Improving Accent Identification and Accented Speech Recognition Under a Framework of Self-Supervised Learning}},
  year=2021,
  booktitle={Proc. Interspeech 2021},
  pages={1504--1508},
  doi={10.21437/Interspeech.2021-1186}
}
```
