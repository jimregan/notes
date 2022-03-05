---
toc: true
layout: post
hidden: true
description: Misc. interesting things.
title: Interesting links, 25/10/2021
categories: [links]
---

[Swedish conversation fillers](https://www.youtube.com/watch?v=Tq1w8cMvAu0)
- Vad heter det? / Vahettere
- Hur/vad var det nu, då
- Vad skulle jag säga nu, då
- Du vet (y'know)
- Typ/liksom (...like)
- Så att (so that...)

[jmccrae/irish_saffron](https://github.com/jmccrae/irish_saffron)

[chartbeat-labs/textacy](https://github.com/chartbeat-labs/textacy)

[Swagger editor](https://editor.swagger.io/)

[Using OntoLex-Lemon for Representing and Interlinking Lexicographic Collections of Bavarian Dialects](https://aclanthology.org/2020.ldl-1.9/)

```bibtex
@inproceedings{abgaz-2020-using,
    title = "Using {O}nto{L}ex-Lemon for Representing and Interlinking Lexicographic Collections of {B}avarian Dialects",
    author = "Abgaz, Yalemisew",
    booktitle = "Proceedings of the 7th Workshop on Linked Data in Linguistics (LDL-2020)",
    month = may,
    year = "2020",
    address = "Marseille, France",
    publisher = "European Language Resources Association",
    url = "https://aclanthology.org/2020.ldl-1.9",
    pages = "61--69",
    language = "English",
    ISBN = "979-10-95546-36-8",
}
```

[pdf](https://aclanthology.org/2020.ldl-1.9.pdf), [code](https://github.com/yalemisewAbgaz/TEI-XML_Mapping) (not open source)

[ming024/FastSpeech2](https://github.com/ming024/FastSpeech2) --- An implementation of Microsoft's "FastSpeech 2: Fast and High-Quality End-to-End Text to Speech"

[bigscience-workshop/promptsource](https://github.com/bigscience-workshop/promptsource)

[aimhubio/aim](https://github.com/aimhubio/aim)

```python
from aim.hugging_face import AimCallback

# ...
aim_callback = AimCallback(repo='/path/to/logs/dir', experiment='mnli')
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset if training_args.do_train else None,
    eval_dataset=eval_dataset if training_args.do_eval else None,
    callbacks=[aim_callback],
    # ...
)
```

[d99kris/spacy-cpp](https://github.com/d99kris/spacy-cpp)

[r9y9/nnmnkwii](https://github.com/r9y9/nnmnkwii)

[R2R](http://wifo5-03.informatik.uni-mannheim.de/bizer/r2r/)
