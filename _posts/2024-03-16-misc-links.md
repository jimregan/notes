---
toc: true
layout: post
hidden: true
description: Misc. interesting things.
title: Interesting links, 16/03/2024
categories: [links]
---

[TMUX — Sharing terminal between Users](https://micropyramid.medium.com/tmux-sharing-terminal-between-users-84f2e311c64f)

```bash
tmux -S /tmp/socket
chmod 777 /tmp/socket
# other user does:
tmux -S /tmp/socket attach
```

