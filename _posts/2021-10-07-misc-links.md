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

[spaCy : en : test_noun_chunks.py](https://github.com/explosion/spaCy/blob/master/spacy/tests/lang/en/test_noun_chunks.py)

[spacy/lang/en/syntax_iterators.py](https://github.com/explosion/spaCy/blob/master/spacy/lang/en/syntax_iterators.py)

[Add task template for automatic speech recognition](https://github.com/huggingface/datasets/pull/2533)

```python
task = AutomaticSpeechRecognition(audio_file_column="file", transcription_column="text")
ds.prepare_for_task(task)
```

[Create Audio feature #2324](https://github.com/huggingface/datasets/pull/2324)

[BigSSL: Exploring the Frontier of Large-Scale Semi-Supervised Learning for Automatic Speech Recognition](https://arxiv.org/abs/2109.13226)

> We summarize the results of a host of efforts using giant automatic speech recognition (ASR) models pre-trained using large, diverse unlabeled datasets containing approximately a million hours of audio. We find that the combination of pre-training, self-training and scaling up model size greatly increases data efficiency, even for extremely large tasks with tens of thousands of hours of labeled data. In particular, on an ASR task with 34k hours of labeled data, by fine-tuning an 8 billion parameter pre-trained Conformer model we can match state-of-the-art (SoTA) performance with only 3% of the training data and significantly improve SoTA with the full training set. We also report on the universal benefits gained from using big pre-trained and self-trained models for a large set of downstream tasks that cover a wide range of speech domains and span multiple orders of magnitudes of dataset sizes, including obtaining SoTA performance on many public benchmarks. In addition, we utilize the learned representation of pre-trained networks to achieve SoTA results on non-ASR tasks.

[Turn-to-Diarize: Online Speaker Diarization Constrained by Transformer Transducer Speaker Turn Detection](https://arxiv.org/abs/2109.11641)

> In this paper, we present a novel speaker diarization system for streaming on-device applications. In this system, we use a transformer transducer to detect the speaker turns, represent each speaker turn by a speaker embedding, then cluster these embeddings with constraints from the detected speaker turns. Compared with conventional clustering-based diarization systems, our system largely reduces the computational cost of clustering due to the sparsity of speaker turns. Unlike other supervised speaker diarization systems which require annotations of time-stamped speaker labels for training, our system only requires including speaker turn tokens during the transcribing process, which largely reduces the human efforts involved in data collection.

[flite_sapi_usenglish.c](https://github.com/festvox/flite/blob/master/sapi/FliteTTSEngineObj/flite_sapi_usenglish.c),
[FliteTTSEngineObj.cpp](https://github.com/festvox/flite/blob/master/sapi/FliteTTSEngineObj/FliteTTSEngineObj.cpp)

[Wav2vec2 pretraining 2 #13520](https://github.com/huggingface/transformers/pull/13520)

[Seoladh Gaelscéal - nuacht24](https://www.youtube.com/watch?v=3BIdtsKnXtM)

[nuacht24](https://www.youtube.com/channel/UCsQv0m-VbJGW3RFugpGKwMA)

[Ar Chanúintí na Gaeilge](https://antuairisceoir.wordpress.com/2013/12/04/ar-chanuinti-na-gaeilge/) (audio)

[rspeer/python-ftfy](https://github.com/rspeer/python-ftfy) --- Fixes mojibake and other glitches in Unicode text, after the fact.

[tkipf/gcn](https://github.com/tkipf/gcn) --- Implementation of Graph Convolutional Networks in TensorFlow

[Grapheme-to-Phoneme Transduction for Cross-Language ASR](https://link.springer.com/chapter/10.1007%2F978-3-030-59430-5_1),
[preprint](http://camille-g.com/slsp20.pdf)

```bibtex
{% raw %}
@InProceedings{hasegawa20g2p,
author="Hasegawa-Johnson, Mark
and Rolston, Leanne
and Goudeseune, Camille
and Levow, Gina-Anne
and Kirchhoff, Katrin",
editor="Espinosa-Anke, Luis
and Mart{\'i}n-Vide, Carlos
and Spasi{\'{c}}, Irena",
title="Grapheme-to-Phoneme Transduction for Cross-Language ASR",
booktitle="Statistical Language and Speech Processing",
year="2020",
publisher="Springer International Publishing",
address="Cham",
pages="3--19",
doi="10.1007/978-3-030-59430-5_1",
isbn="978-3-030-59430-5"
}
{% endraw %}
```