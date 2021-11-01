---
toc: true
layout: post
hidden: true
description: What it takes to get it to run
title: Flashlight docker, 20/10/2021
categories: [flashlight, docker]
---

```bash
$ docker pull flml/flashlight:cuda-latest
cuda-latest: Pulling from flml/flashlight
Digest: sha256:fbf98d7b813c05605a930c99d28942106232de0f2051ba8bd6f9066e22d5c1b6
```

```bash
$ docker run -it  flml/flashlight:cuda-latest bash
```

```bash
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/compilers_and_libraries_2020.4.304/linux/mkl/lib/intel64_lin/:/opt/arrayfire/lib/
# ldconfig
```
