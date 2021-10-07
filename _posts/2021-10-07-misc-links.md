---
toc: true
layout: post
hidden: true
description: Misc. interesting things.
title: Interesting links, 7/10/2021
categories: [links]
---

[CMU Advanced NLP 2021 (10): Prompting + Sequence-to-sequence Pre-training](https://www.youtube.com/watch?v=TE6urdkTR4I)

[gong-io/gecko](https://github.com/gong-io/gecko) --- Gecko - A Tool for Effective Annotation of Human Conversations

[datasets - opus_dogc.py](https://github.com/huggingface/datasets/blob/3db67f5ff6cbf807b129d2b4d1107af27623b608/datasets/opus_dogc/opus_dogc.py)

```python
    def _generate_examples(self, filepath):
        xml_lang = "{http://www.w3.org/XML/1998/namespace}lang"
        with open(filepath, encoding="utf-8") as f:
            id_ = 0
            for _, elem in ET.iterparse(f):
                if elem.tag == "tuv":
                    language = elem.attrib[xml_lang]
                    sentence = elem.find("seg").text
                    if language == "ca":
                        ca_sentence = sentence
                    elif language == "es":
                        es_sentence = sentence
                elif elem.tag == "tu":
                    yield id_, {
                        "translation": {"ca": ca_sentence, "es": es_sentence},
                    }
                    id_ += 1
                    elem.clear()
```

[_parse_tmx()](https://github.com/huggingface/datasets/blob/ed8b06750224a534de5773590b0a491318f3ae6a/datasets/wmt16/wmt_utils.py#L926)

