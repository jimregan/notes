---
toc: false
layout: post
hidden: true
description: Old note
title: ImageTerrier command
categories: [evernote, imageterrier]
---

## ImageTerrier command

```bash
/usr/bin/java -Xshare:off -Xmx6G -Djava.awt.headless=true -XX:-UseGCOverheadLimit \
-Dbundle.size=1000 -Dmemory.reserved=400000000 -cp /Users/jim/Downloads/ImageTerrierTools-3.0.1-jar-with-dependencies.jar \
org.imageterrier.basictools.BasicIndexer -o idx -qt RANDOM -p BYTE -k 100000 -t POSITION -pm SPATIAL_SCALE_ORI \
-nb 8,8,8,8 -mins 0.0,0.0,0.0,-3.14157 -maxs 1000.0,1000.0,150.0,3.14157 .
```

