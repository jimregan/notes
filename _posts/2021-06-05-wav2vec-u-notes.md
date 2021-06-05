---
toc: true
layout: post
title: wav2vec-u notes
description: tl;dr - wav2vec-u is difficult to get running
categories: [wav2vec-u]
---

## The skippable blah

[wav2vec unsupervised](https://arxiv.org/abs/1904.05862) has caught a bit of attention. 

There has been a mixed bag of expectations: there was [a blog post](https://ai.facebook.com/blog/wav2vec-unsupervised-speech-recognition-without-supervision/), they even had a video:

{% twitter https://twitter.com/facebookai/status/1399750058883444738 %}

So, a few people have had the expectation that it would be quite a bit easier than it turned out to.

I've been beating my head against multiple walls for over a decade, with various pieces of research software for various purposes, so my expectations were a little different. Just looking at the [directory](https://github.com/pytorch/fairseq/tree/master/examples/wav2vec/unsupervised), the third subdirectory is `kaldi_self_train`, which is the first red flag: this will not be easy. Scrolling down, among the first instructions are zsh scripts. zsh is a great shell, and using it as a shell was a sign of sophistication in the late 90s, but it isn't the most universal shell, so if your scripts are zsh scripts, that's a pretty good sign you've never tried to run them on a second computer. That said, trying to use any kind of software on Linux in the late 90s involved some sort of beating of heads against walls, so that contributes too.

I like Kaggle. A lot. I like the workflow, and being able to use the output of one notebook as the input to another. I like being able to run something, and not have to babysit it in case it disconnects, like with Colab. So I've tried to do as much of this as possible on Kaggle.

But the GPU images on Kaggle are seriously broken. It could be by design: the handful of things I've tried that are run purely as a notebook seem to work well. Maybe conda is deliberately cobbled, maybe it's unintentional, but it fails more often than not. So anything that involves using a GPU: switch to Colab.

## Caveat

These are my notes for my own use, because once I've done a full trial run, I have some data I want to try out. I'm deliberately not adding additional text, mostly because I want the trial run to go as quickly as possible; that's failing for other reasons, but such is life.

What I've done was based on my understanding, or best guess. I can guarantee that I was not smoking any illegal substances, but considering where I live, I can't guarantee that there was no second-hand smoke.

There is [an issue](https://github.com/pytorch/fairseq/issues/3591) on fairseq's github where Alexei Baevski has said that better instructions are coming in a week or so, so maybe bide your time; he also offered to answer questions on that thread, so if you have questions, your best bet is to ask there.

## Step 0: Data

In an ideal world, Kaggle's dataset uploader would Do The Right Thing when given a link to a zip file, or, rather, one of two Right Things: just download it, or download and unzip. Instead, it creates a directory for every file in the zip.

🤦

Cool, I'll just do that in a [notebook]({% post_url 2021-05-25-download-common-voice-swedish %}).

wav2vec-u (and just about everything else in the world of ASR, ever) needs audio sampled at 16 kHz, and uses `soundfile`, so MP3s are not welcome, so I'll do that in [another notebook]({% post_url 2021-05-25-common-voice-swedish-16bit-wav %}).

## Step 0.1: ltr/wrd/phn files

Preparing these files is mentioned in passing, as though they're self-explanatory. Which they are, if you happen to have played with phoneme-based ASR as well as wav2letter. So, not really.

What I ended up doing is [this]({% post_url 2021-05-26-wav2vec-u-cv-swedish-prep-ltr-phn-wrd %}); I _should have_ changed the tab separation in the `dict.*` files to a space, because that's what's usually given to Kaldi, but IIRC, it handles tab. So change:

```
paste /tmp/$i.wl /tmp/$i.wl.phn > dict.$i
```

to:

```
paste /tmp/$i.wl /tmp/$i.wl.phn | tr '\t' ' ' > dict.$i
```

or equivalent.

Caveat: I can't say for sure if these are actually correct outputs, and I'm not even sure they're actually used by default, aside from the `prepare_audio.sh` script dying if they're missing.

There are some notes in [that notebook]({% post_url 2021-05-26-wav2vec-u-cv-swedish-prep-ltr-phn-wrd %}) where I tracked down and corrected for espeak's language switching; feel free to ignore that if you're not borderline OCD.

## Step 0.2: Preparing TSVs

Another thing that's glossed over a bit is the TSV files, which are more pseudo-TSV.

"Similar to wav2vec 2.0" is more-or-less true, in that you can figure it out if you look at [this script](https://github.com/pytorch/fairseq/blob/master/examples/wav2vec/libri_labels.py); basically, the format is:

```
/path/to/my/audio/
file1.wav	[number of frames]
file2.wav	[number of frames]
... (etc.)
```

I used [this notebook]({% post_url 2021-05-25-wav2vec-u-cv-swedish-tsv %}) to convert Common Voice TSV to these pseudo-TSVs, but the number of frames aren't read by anything, so you can get away with a file list, as long as the first line is the path.

## Step 1: VAD/Silence trimming

There's a passing mention of rVAD, like it's a common piece of software that you should just be able to install. It's not: it's [here](https://github.com/zhenghuatan/rVADfast). Or, you know, save yourself the trouble and copy the relevant steps from the [notebook]({% post_url 2021-05-25-wav2vec-u-cv-swedish-vads %})

This went fairly smoothly; I wrestled with Kaggle a bit, but I think any problems here were of my own creation.

## Step 2: `prepare_audio.sh`

My notebook for [prepare_audio.sh]({% post_url 2021-05-27-wav2vec-u-cv-swedish-audio %}) is quite short; basically, you need the `dict.*`, `*.wrd`, `*.ltr`, and `*.phn` files from Step 0.1, and:

```
pip install npy-append-array faiss-gpu
```

(also, possibly, `apt install zsh`)

Also: wow! This used GPU on Kaggle, and actually worked.

## Step 3: `prepare_text.sh`

This needs Kaldi to compile FSTs. On Kaggle, I used [this notebook]({% post_url 2021-05-15-extract-prebuilt-kaldi-from-docker %}) to extract a pre-built version from the official docker images. DNN parts won't run, because they're compiled for an earlier version of CUDA, but they're not necessary for this step.

If you're using Colab, [this question](https://stackoverflow.com/questions/49771968/is-it-possible-to-install-kaldi-on-google-colab) on Stack Overflow is for you:

```
!pip install kora -q
import kora.install.kaldi
```

The version of Kaldi there is also from the official docker image (that's where I got the idea), but it also downloads and unpacks it for you. Which is nice.

My notebook for running `prepare_text.sh` has more notes than usual: [check it out]({% post_url 2021-05-26-wav2vec-u-cv-swedish-text-prep %})

## Step 4: GAN training

This doesn't work on Kaggle, because GPU. It does, however, run on CPU—albeit 8-9 times slower—so I've been chaining together calls, starting with [this]({% post_url 2021-06-01-wav2vec-u-cv-swedish-gan-cpu1 %}), leading up to (at the time of writing) [this]({% post_url 2021-06-05-wav2vec-u-cv-swedish-gan-cpu8 %}).

The good news is, it runs fine on Colab: [notebook here]({% post_url 2021-05-30-wav2vec-u-cv-swedish-gan %}).

(By "fine", I mean "with [this patch](https://github.com/pytorch/fairseq/pull/3569) added, running from [this branch](https://github.com/jimregan/fairseq/tree/issue3581) where everything has been moved around." Close enough.)

## Fin

I'm still waiting for GAN training to finish, so I can't comment on anything else.


