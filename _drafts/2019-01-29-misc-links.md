---
toc: false
layout: post
hidden: true
description: Misc. interesting things.
title: Interesting links, 29/1/2019
categories: [links]
---

[FstContrib](http://www.openfst.org/twiki/bin/view/Contrib/FstContrib)

[OpenGrm Libraries](http://www.opengrm.org/twiki/bin/view/GRM/WebHome)

[OpenGrm Thrax Grammar Compiler](http://www.opengrm.org/twiki/bin/view/GRM/ThraxQuickTour)

[OpenGrm Thrax tools](http://www.opengrm.org/twiki/bin/view/Contrib/ThraxContrib)

[mjansche/tts-tutorial](https://github.com/mjansche/tts-tutorial)

[google/sparrowhawk](https://github.com/google/sparrowhawk)

[google/language-resources](https://github.com/google/language-resources)

[Free Linguistic Environment](https://gorilla.linguistlist.org/software/) -- a grammar engineering platform for LFG. [git](https://bitbucket.org/dcavar/fle/src/master/)

[dcavar/treebankparsersa](https://bitbucket.org/dcavar/treebankparsersa/overview) -- This is a tool that reads treebank files and generates a probabilistic grammar for use in FLE.

[Practical Instructions for Working with LFG](http://www.fb10.uni-bremen.de/khwagner/lfg/pdf/wescoat.pdf)

[Grammar Development with LFG and XLE](http://ling.uni-konstanz.de/pages/home/butt/main/material/gd-lesson2.pdf)

```
S --> NP: (^ SUBJ)=!
 (! CASE)=NOM;
 VP: ^=!.

 "indicate comments"
VP --> V: ^=!; "head"
 (NP: (^ OBJ)=! "() = optionality"
 (! CASE)=ACC)
 PP*: ! $ (^ ADJUNCT). "$ = set, * = Kleene star"
```

[astorfi/TensorFlow-World](https://github.com/astorfi/TensorFlow-World) -- Simple and ready-to-use tutorials for TensorFlow
