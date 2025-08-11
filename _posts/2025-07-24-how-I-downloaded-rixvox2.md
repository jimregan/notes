---
toc: true
layout: post
description: ...because I need to re-do this.
title: How I downloaded Rixvox-v2
categories: [rixvox2, huggingface]
---

<!-- Basically, the dataset is too large to download directly, so I used the Hugging Face CLI to download it into a local cache directory. -->

Basically, the dataset is too large to download to local storage, so I used the Hugging Face CLI to download it to a NAS directory.

(Also, I typed "basically" and copilot wrote the rest of the sentence for me, which is nice, though I had to correct the intention.)

What I hadn't known is that my supervisor was going to replace the NAS device, so I need to re-do this.

```bash
mkdir cache
huggingface-cli download --repo-type dataset KBLab/rixvox-v2 --cache-dir ./cache
```