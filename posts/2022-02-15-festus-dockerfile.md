---
toc: false
layout: post
hidden: true
description: Start of Dockerfile for festus
title: Festus Dockerfile
categories: [docker, festus, todo]
---

```docker
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update && apt install -y g++ git && \
    apt install -y apt-transport-https ca-certificates

RUN apt install -y curl gnupg pkg-config zip zlib1g-dev unzip python
# This stuff doesn't work, the apt repo seems broken
#RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
#RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
#RUN apt update
#RUN apt install -y bazel

RUN curl -L https://github.com/bazelbuild/bazel/releases/download/6.0.0-pre.20220201.3/bazel-6.0.0-pre.20220201.3-linux-arm64 > /usr/local/bin/bazel
RUN chmod a+x /usr/local/bin/bazel

RUN bazel version

RUN git clone https://github.com/google/language-resources/
RUN cd language-resources && \
    cat WORKSPACE | sed -e 's/googletest-master/googletest-main/;s!googletest/archive/master!googletest/archive/main!;s!re2-master!re2-main!;s!/re2/archive/master!/re2/archive/main!;s/benchmark-master/benchmark-main/;s!benchmark/archive/master!benchmark/archive/main!;s/abseil-py-master/abseil-py-main/;s!abseil-py/archive/master!abseil-py/archive/main!;' > TMP && \
    mv TMP WORKSPACE && \
    cd festus && \
    bazel build //festus:ngramfinalize && \
    bazel build //festus:make-alignable-symbols && \
    bazel build //festus:fst2re && \
    bazel build //festus:fstnbinom && \
    bazel build //festus:fstrmepscycle && \
    bazel build //festus:best-labeling && \
    bazel build //festus:lexicon-diagnostics && \
    bazel build //festus:make-runtime-fsts
```
