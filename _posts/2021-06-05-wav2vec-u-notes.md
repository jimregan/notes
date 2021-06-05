---
toc: true
layout: post
title: wav2vec-u notes
description: Comparing Irish varieties
categories: [wav2vec-u]
---

[wav2vec unsupervised](https://arxiv.org/abs/1904.05862) has caught a bit of attention. 

There has been a mixed bag of expectations: there was [a blog post](https://ai.facebook.com/blog/wav2vec-unsupervised-speech-recognition-without-supervision/), they even had a video:

{% twitter https://twitter.com/facebookai/status/1399750058883444738 %}

So, quite a few people have had the expectation that it would be quite a bit easier than it turned out to.

I've been beating my head against multiple walls for over a decade, with various pieces of research software for various purposes, so my expectations were a little different. Just looking at the [directory](https://github.com/pytorch/fairseq/tree/master/examples/wav2vec/unsupervised), the third subdirectory is `kaldi_self_train`, which is the first red flag: this will not be easy. Scrolling down, among the first instructions are zsh scripts. zsh is a great shell, and using it as a shell was a sign of sophistication in the late 90s, but it isn't the most universal shell, so if your scripts are zsh scripts, that's a pretty good sign you've never tried to run them on a second computer.

