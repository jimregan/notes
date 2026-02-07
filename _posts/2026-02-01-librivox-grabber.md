---
toc: true
layout: post
hidden: true
description: For grabbing similar books
title: Librivox grabber
categories: [librivox]
---

```bash
for i in "$@"
do
        d=$(echo $i|awk -F/ '{print $4}')
        mkdir $d
        pushd $d
        wget $i
        lynx -dump $i |grep mp3|grep -v 64k|awk '{print $NF}' > files
        wget -i files
        popd
done
```

