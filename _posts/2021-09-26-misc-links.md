---
toc: true
layout: post
hidden: true
description: Misc. interesting things.
title: Interesting links, 26/9/2021
categories: [links]
---

[A Framework for Any-to-Any Voice Conversion with Self-Supervised Pretrained Representations](https://pythonawesome.com/a-framework-for-any-to-any-voice-conversion-with-self-supervised-pretrained-representations/)

[howard1337/S2VC](https://github.com/howard1337/S2VC)

[yistLin/universal-vocoder](https://github.com/yistLin/universal-vocoder); paper: [Towards achieving robust universal neural vocoding](https://arxiv.org/abs/1811.06292)

[cywang97/unispeech](https://github.com/cywang97/unispeech);
paper: [UniSpeech: Unified Speech Representation Learning with Labeled and Unlabeled Data](https://arxiv.org/abs/2101.07597)

[microsoft/unilm](https://github.com/microsoft/unilm) --- UniLM AI - Large-scale Self-supervised Pre-training across Tasks, Languages, and Modalities

[Continual-wav2vec2: an Application of Continual Learning for Self-Supervised Automatic Speech Recognition](https://arxiv.org/abs/2107.13530)

[Interactive demo: LayoutLMv2](https://huggingface.co/spaces/nielsr/LayoutLMv2-FUNSD)

[Improving Pretrained Cross-Lingual Language Models via Self-Labeled Word Alignment](https://aclanthology.org/2021.acl-long.265/);
[CZWin32768/XLM-Align](https://github.com/CZWin32768/XLM-Align)

[waydroid/waydroid](https://github.com/waydroid/waydroid)

[huseinzol05/malaya-speech](https://github.com/huseinzol05/malaya-speech)

[Fine-tuning XLSR-Wav2Vec2 for WOLOF ASR with 🤗](https://www.kaggle.com/kingabzpro/fine-tuning-xlsr-wav2vec2-for-wolof-asr-with)

```python
model = Wav2Vec2ForCTC.from_pretrained(
    "facebook/wav2vec2-large-xlsr-53", 
    attention_dropout=0.1,
    hidden_dropout=0.1,
    feat_proj_dropout=0.0,
    mask_time_prob=0.05,
    layerdrop=0.1,
    gradient_checkpointing=True,
    ctc_loss_reduction="mean",
    pad_token_id=processor.tokenizer.pad_token_id,
    vocab_size=len(processor.tokenizer)
)

training_args = TrainingArguments(
  output_dir="./wav2vec2-large-xlsr-WOLOF",
  group_by_length=True,
  per_device_train_batch_size=16,
  gradient_accumulation_steps=2,
  evaluation_strategy="steps",
  num_train_epochs=40,
  fp16=True,
  save_steps=500,
  eval_steps=500,
  logging_steps=500,
  learning_rate=3e-4,
  warmup_steps=1000,
  save_total_limit=2,
)
```

[run_spleeter.py](https://github.com/Appen/UHV-OTS-Speech/blob/main/source_separation/run_spleeter.py)

[Few-shot Intent Classification and Slot Filling with Retrieved Examples](https://aclanthology.org/2021.naacl-main.59.pdf)

[Comparing CTC and LFMMI for out-of-domain adaptation of wav2vec 2.0 acoustic model](https://arxiv.org/abs/2104.02558)

[Unsupervised Cross-Modal Alignment of Speech and Text Embedding Spaces](https://ckbjimmy.github.io/docs/chung2018unsupervised_p.pdf)

