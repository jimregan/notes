---
toc: false
layout: post
hidden: true
description: ChatGPT paper summary
title: Whisper based Cross-Lingual Phoneme Recognition between Vietnamese and English
categories: [chatgpt, summary]
---

[paper](https://link.springer.com/chapter/10.1007/978-3-032-00972-2_20),
[arXiv](https://arxiv.org/abs/2508.19270)

```bibtex
@InProceedings{nguyen2026whisper,
author="Nguyen, Huu Nhat Minh
and Tran, Nguyen Anh
and Truong, Dinh Dung
and Vo, Van Nam
and Le, Pham Tuyen",
editor="Nguyen, Ngoc Thanh
and Huynh, Cong-Phap
and Nguyen, Thanh Thuy
and Le-Khac, Nhien-An
and Seng, Sopheap
and Nguyen, Quang-Vu",
title="Whisper Based Cross-Lingual Phoneme Recognition Between Vietnamese and English",
booktitle="The 14th Conference on Information Technology and its Applications",
year="2026",
publisher="Springer Nature Switzerland",
address="Cham",
pages="259--271",
isbn="978-3-032-00972-2"
}
```

This paper proposes a bilingual phoneme-recognition system for Vietnamese and English, specifically targeting the messiness of real-world “Vietlish” speech: English words pronounced with Vietnamese phonology, mixed-language utterances, and code-switching. 

The core problem the authors tackle is that Vietnamese and English encode pronunciation very differently. Vietnamese is tonal, meaning pitch changes alter meaning, while English relies more on stress, rhythm, and irregular pronunciation. Existing multilingual ASR systems — including Whisper-derived systems — struggle when Vietnamese speakers insert English words into speech or pronounce English using Vietnamese phonetic patterns. 

The paper’s two main contributions are:

1. A cross-lingual phoneme representation that maps English pronunciation into a Vietnamese-compatible phonological structure.
2. An end-to-end encoder–decoder architecture using a frozen PhoWhisper encoder and Transformer decoder for phoneme recognition. 

The phoneme representation work is probably the most interesting part of the paper. The authors build a shared phoneme inventory based on Vietnamese syllable structure — Initial, Rhyme, Tone, etc. — and then adapt English words into that system. 

They distinguish between:

* **Standard English pronunciation**
* **Localized Vietnamese-style pronunciation (“Vietlish”)**

For example, an English word like *message* may be pronounced approximately according to Vietnamese syllable constraints rather than canonical English phonology. The system attempts to normalize both pronunciations into a unified phoneme representation. The diagram on page 5 shows this conversion pipeline visually, including how tones and syllable boundaries are represented. 

Architecturally, the model combines:

* a **frozen PhoWhisper encoder** trained on Vietnamese ASR,
* with a **Transformer decoder** that autoregressively predicts phoneme sequences. 

The encoder extracts acoustic features from log-mel spectrograms using convolutional layers and Whisper attention blocks. The decoder then uses self-attention plus cross-attention to map audio features into phoneme sequences. One implementation detail they emphasize is the use of *multiple cross-attention mechanisms* to avoid losing encoded information through deep Transformer stacks. 

The experimental section uses both:

* real Vietnamese datasets (VLSP 2020, Common Voice, VIVOS, FOSD),
* and a synthetic bilingual dataset constructed from English words, Vietlish pronunciations, and interleaved Vietnamese-English speech. 

The synthetic dataset design is fairly elaborate:

* “Native English” uses Cambridge Dictionary audio,
* “Vietlish” converts English words into Vietnamese phonetic approximations,
* “IEV” contains mixed-language utterances with alternating Vietnamese and English words. 

They compare four architectures:

* Whisper-GRU
* Whisper-LSTM
* Wav2Vec2-Transformer
* Whisper-Transformer 

The Whisper-Transformer model consistently wins by a large margin.

On Vietnamese datasets:

* VIVOS PER: **8.85%**
* Common Voice PER: **13.02%**
* FOSD PER: **16.7%**
* VLSP 2020 PER: **22.4%** 

On synthetic bilingual datasets:

* IEV PER: **7.02%**
* Vietlish PER: **16.21%**
* Native English PER: **28.55%** 

The striking thing is how badly the simpler GRU/LSTM systems perform, especially on English. Some PER values exceed 100%, which implies catastrophic insertion/deletion/substitution behavior in phoneme prediction. The authors argue that the Transformer decoder is much better at handling long-range dependencies and code-switching structure. 

The paper’s strengths:

* sensible framing of Vietlish/code-switching as a phonological problem rather than purely lexical,
* practical bilingual phoneme mapping,
* decent engineering integration of PhoWhisper with a Transformer decoder,
* synthetic dataset construction tailored to Vietnamese-English mixing.

But there are also limitations:

* the English dataset is tiny (~6 hours training audio), which weakens claims about robust bilingual generalization,
* much of the bilingual data is synthetic rather than naturally occurring conversational speech,
* evaluation focuses only on PER, not downstream ASR usefulness,
* comparisons against modern multilingual Whisper fine-tuning baselines are limited,
* the paper sometimes overstates novelty; many ideas derive directly from established encoder–decoder and multilingual phoneme-recognition work.

Overall, the paper is less a breakthrough in multilingual speech modeling than a solid applied engineering paper focused on Vietnamese-English code-switching and accent localization. The most original piece is the phoneme normalization strategy for Vietlish pronunciation. The architecture itself is relatively conventional, but the results suggest that combining PhoWhisper with a Transformer decoder is effective for this specific bilingual setting. 

