---
toc: true
layout: post
hidden: true
description: Misc. interesting things.
title: Interesting links, 13/07/2022
categories: [links]
---

[patrick-kidger/equinox](https://github.com/patrick-kidger/equinox) --- Callable PyTrees and filtered transforms => neural networks in JAX.

[patrick-kidger/diffrax](https://github.com/patrick-kidger/diffrax) --- Numerical differential equation solvers in JAX. Autodifferentiable and GPU-capable.

---

[M-Adapter: Modality Adaptation for End-to-End Speech-to-Text Translation](https://arxiv.org/abs/2207.00952)

```bibtex
@misc{https://doi.org/10.48550/arxiv.2207.00952,
  doi = {10.48550/ARXIV.2207.00952},
  url = {https://arxiv.org/abs/2207.00952},
  author = {Zhao, Jinming and Yang, Hao and Shareghi, Ehsan and Haffari, Gholamreza},
  title = {M-Adapter: Modality Adaptation for End-to-End Speech-to-Text Translation},
  publisher = {arXiv},
  year = {2022},
  copyright = {arXiv.org perpetual, non-exclusive license}
}
```

---

{% twitter https://twitter.com/MetaAI/status/1544670269469507585 %}
[Code](https://github.com/facebookresearch/fairseq/tree/nllb) is open source, model [is not](https://github.com/facebookresearch/fairseq/blob/nllb/LICENSE.model.md)

---

[Trillson in transformers](https://github.com/huggingface/transformers/pull/17387)

---

[Emformer: Efficient Memory Transformer Based Acoustic Model for Low Latency Streaming Speech Recognition](https://ieeexplore.ieee.org/document/9414560)

```bibtex
@INPROCEEDINGS{9414560,
  author={Shi, Yangyang and Wang, Yongqiang and Wu, Chunyang and Yeh, Ching-Feng and Chan, Julian and Zhang, Frank and Le, Duc and Seltzer, Mike},
  booktitle={ICASSP 2021 - 2021 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP)}, 
  title={Emformer: Efficient Memory Transformer Based Acoustic Model for Low Latency Streaming Speech Recognition}, 
  year={2021},
  volume={},
  number={},
  pages={6783-6787},
  doi={10.1109/ICASSP39728.2021.9414560}}
```

---

[lumaku/ctc-segmentation](https://github.com/lumaku/ctc-segmentation) --- Segment an audio file and obtain utterance alignments.

---

{% twitter https://mobile.twitter.com/NimaBoscarino/status/1535331680805801984 %}

---

[How much data do you need for a good MFA alignment?](https://memcauliffe.com/how-much-data-do-you-need-for-a-good-mfa-alignment.html)

> If you care only about alignments of the training data, 3-5 hours should be enough.
> > Caveat: increasing the number of speakers/varieties in the training data will likely need more training data
> > If you care about generating models for more widespread use, 8-10 should be enough for generalizing to the same variety
> The more speakers the better, but also more speakers should need more data
> > I usually recommend about 20 hours for a decently performant model

---

[google-research/t5x](https://github.com/google-research/t5x) --- essentially a new and improved implementation of the T5 codebase (based on Mesh TensorFlow) in JAX and Flax.

[google/seqio](https://github.com/google/seqio) --- Task-based datasets, preprocessing, and evaluation for sequence models.

---

[r/weirddalle](https://www.reddit.com/r/weirddalle/)

---


