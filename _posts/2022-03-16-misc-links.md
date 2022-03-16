---
toc: true
layout: post
hidden: true
description: Misc. interesting things.
title: Interesting links, 16/03/2022
categories: [links]
---

[Transformer Memory as a Differentiable Search Index](https://arxiv.org/abs/2202.06991)

[It's Raw! Audio Generation with State-Space Models](https://arxiv.org/abs/2202.09729),
[code](https://github.com/hazyresearch/state-spaces)

[Learning Discrete Representations via Constrained Clustering for Effective and Efficient Dense Retrieval](https://arxiv.org/abs/2110.05789),
[code](https://github.com/jingtaozhan/RepCONC)

[Hierarchical Perceiver](https://arxiv.org/abs/2202.10890)

[mSLAM: Massively multilingual joint pre-training for speech and text](https://arxiv.org/abs/2202.01374)

[Who spoke when! How to Build your own Speaker Diarization Module](https://medium.com/saarthi-ai/who-spoke-when-build-your-own-speaker-diarization-module-from-scratch-e7d725ee279),
[code](https://github.com/resemble-ai/Resemblyzer)

{% twitter https://twitter.com/brianyan918/status/1420860185632022531 %}

[Differentiable Allophone Graphs for Language-Universal Speech Recognition](https://arxiv.org/abs/2107.11628)

[NLP Seminar 220216 - Omar Sanseviero \(Hugging Face\)](https://www.youtube.com/watch?v=T2DUg7iFN5M)

[11L – Speech recognition and Graph Transformer Networks](https://www.youtube.com/watch?v=Of9s8epjflU)

[How can I get duration of all video files in a folder containing multiple subfolders?](https://askubuntu.com/questions/959520/how-can-i-get-duration-of-all-video-files-in-a-folder-containing-multiple-subfol)

```sh
exiftool -n -q -p '${Duration;our $sum;$_=ConvertDuration($sum+=$_)}' ./*.mp4| tail -n1
```


