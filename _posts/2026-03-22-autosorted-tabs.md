---
toc: true
layout: post
hidden: true
description: Misc. interesting things.
title: Claude sorted tabs, 22/03/2026
categories: [links]
---


# Parliamentary Corpora

## ParlaMint / ParlaCLARIN

- [ParlaMint: Comparable and Interoperable Parliamentary Corpora (CLARIN)](https://www.clarin.eu/parlamint#publications)
- [ParlaMint I and II project information](https://www.clarin.eu/parlamint-project-information#parlamint-i-july-2020-may-2021)
- [Multilingual comparable corpora of parliamentary debates ParlaMint 5.0 (CLARIN.SI)](https://www.clarin.si/repository/xmlui/handle/11356/2004)
- [clarin-eric/ParlaMint GitHub](https://github.com/clarin-eric/ParlaMint?tab=readme-ov-file)
- [Parla-CLARIN TEI Schema for Corpora of Parliamentary Proceedings](https://clarin-eric.github.io/parla-clarin/#sec-speechvideo)
- [clarin-eric/parla-clarin: Schema for modelling parliamentary debates](https://github.com/clarin-eric/parla-clarin?tab=readme-ov-file)
- [ParlaCLARIN IV Workshop on Creating, Analysing, and Increasing Accessibility of Parliamentary Corpora](https://aclanthology.org/2024.parlaclarin-1.0.pdf)

## Swerik / Riksdagen

- [swerik-project repositories](https://github.com/orgs/swerik-project/repositories)
- [The Swedish Parliament Corpus 1867 – 2022 (LREC 2024 paper)](https://aclanthology.org/2024.lrec-main.1400.pdf)
- [swerik-project/riksdagen-records](https://github.com/swerik-project/riksdagen-records)
- [swerik-project/riksdagen-motions](https://github.com/swerik-project/riksdagen-motions)
- [swerik-project/riksdagen-persons: Metadata on politicians](https://github.com/swerik-project/riksdagen-persons)
- [swerik-project/pyparlaclarin: Python package for Parla-CLARIN XML](https://github.com/swerik-project/pyparlaclarin)
- [swerik-project/riksdagen-volumeG-alto: Alto files for OCRd volume G](https://github.com/swerik-project/riksdagen-volumeG-alto)
- [corpus-walkthrough.ipynb (Colab)](https://colab.research.google.com/github/swerik-project/pyriksdagen/blob/main/examples/corpus-walkthrough.ipynb)
- [Parliamentary documents, laws and legislative history | Sveriges riksdag](https://www.riksdagen.se/en/contact-and-visit/the-riksdag-library/parliamentary-documents-laws-and-legislative-history/)

## Other corpora / projects

- [ParlaSpeech - Parliamentary Speech Corpus](https://clarinsi.github.io/parlaspeech/)
- [How to Use the ParlaSpeech Corpus Through a Concordancer](https://clarinsi.github.io/parlaspeech/concordancer/concordancer-guide.html)
- [The siParl corpus of Slovene parliamentary proceedings](https://aclanthology.org/2020.parlaclarin-1.6/)
- [KBLab/rixvox-v2 (Hugging Face)](https://huggingface.co/datasets/KBLab/rixvox-v2)
- [Hansard - UK Parliament](https://hansard.parliament.uk/)
- [ajdapretnar/AI-perspectives: AI in British and Slovenian parliament](https://github.com/ajdapretnar/AI-perspectives)

## Related papers

- [Encoding Interruptions in Parliamentary Data: From Applause to Interjections and Laughter](https://journals.openedition.org/jtei/4214)
- [Qualitative Comparison of Native and Machine-Translated Parliamentary Debates](https://ceur-ws.org/Vol-3133/paper10.pdf)
- [Voices of the Parliament | Modern Languages Open](https://modernlanguagesopen.org/articles/10.3828/mlo.v0i0.295)

## CLARIN resource families

- [Parliamentary Corpora | CLARIN](https://www.clarin.eu/resource-families/parliamentary-corpora)
- [Legal Corpora | CLARIN](https://www.clarin.eu/resource-families/legal-corpora)
- [Sign Language Resources | CLARIN](https://www.clarin.eu/resource-families/sign-language-resources)
- [Licenses and CLARIN Categories](https://www.clarin.eu/content/licenses-and-clarin-categories)
- [CLARIN Licensing Framework](https://www.clarin.eu/content/clarin-licensing-framework)
- [JRC EU DGT Translation Memory Parsebank DGT-UD 1.0](https://www.clarin.si/repository/xmlui/handle/11356/1197)


# Grapheme-to-Phoneme (G2P)

## Tools / models

- [spring-media/DeepPhonemizer: Grapheme to phoneme with deep learning](https://github.com/spring-media/DeepPhonemizer?tab=readme-ov-file)
- [DeepPhonemizer training notebook (Colab)](https://colab.research.google.com/github/as-ideas/DeepPhonemizer/blob/main/dp/notebooks/Training_Example.ipynb)
- [lingjzhu/CharsiuG2P: Multilingual G2P in 100 languages](https://github.com/lingjzhu/CharsiuG2P)
- [charsiu/g2p_multilingual_byT5_small_100 (Hugging Face)](https://huggingface.co/charsiu/g2p_multilingual_byT5_small_100)
- [CharsiuG2P fine-tuning low-resource notebook](https://github.com/lingjzhu/CharsiuG2P/blob/main/notebooks/finetuning_low_resource.ipynb)
- [fdemelo/g2p-mbyt5-12l-ipa-childes-espeak (Hugging Face)](https://huggingface.co/fdemelo/g2p-mbyt5-12l-ipa-childes-espeak)
- [rhasspy/wiktionary2dict: Extract IPA pronunciations from Wiktionary XML dump](https://github.com/rhasspy/wiktionary2dict)
- [open-dict-data/ipa-dict: Monolingual wordlists with IPA pronunciation](https://github.com/open-dict-data/ipa-dict?tab=readme-ov-file)
- [CUNY-CL/wikipron (phoneme data)](https://github.com/CUNY-CL/wikipron/tree/master/data/phones/phones)

## Papers

- [ByT5 model for massively multilingual G2P (2204.03067)](https://arxiv.org/abs/2204.03067)
- [PolyIPA: Multilingual Phoneme-to-Grapheme Conversion (2412.09102)](https://arxiv.org/abs/2412.09102)
- [SoundChoice: G2P Models with Semantic Disambiguation (Interspeech 2022)](https://www.isca-archive.org/interspeech_2022/ploujnikov22_interspeech.html)
- [Transformer Based G2P Conversion (Interspeech 2019)](https://www.isca-archive.org/interspeech_2019/yolchuyeva19_interspeech.html#)
- [T5G2P: Using Text-to-Text Transfer Transformer for G2P (Interspeech 2021)](https://www.isca-archive.org/interspeech_2021/rezackova21_interspeech.html#)
- [G2P using LSTM recurrent neural networks (IEEE ICASSP 2015)](https://ieeexplore.ieee.org/document/7178767)
- [Massively Multilingual Neural G2P Conversion (ACL 2017)](https://aclanthology.org/W17-5403.pdf)
- [Joint-sequence models for G2P conversion (ScienceDirect)](https://www.sciencedirect.com/science/article/pii/S0167639308000046)
- [Jointly learning to align and convert graphemes to phonemes (ASRU 2017)](https://ieeexplore.ieee.org/abstract/document/7846248)
- [Italianising English words with G2P in TTS (Uppsala thesis)](https://uu.diva-portal.org/smash/record.jsf?pid=diva2%3A1868326&dswid=6766)
- [Stress Assignment in Letter to Sound Rules (ACL 1985)](https://aclanthology.org/P85-1030.pdf)
- [Phoneme-to-Grapheme Conversion Based Large-Scale Pre-Training for ASR (Interspeech 2020)](https://www.isca-archive.org/interspeech_2020/masumura20_interspeech.pdf)
- [Knowledge of language origin improves pronunciation of proper names (ResearchGate)](https://www.researchgate.net/publication/362423262_Knowledge_of_language_origin_improves_pronunciation_accuracy_of_proper_names)
- [Improving Proper Name Recognition by Adding Learned Pronunciation Variants (LREC 2010)](https://aclanthology.org/L10-1195/)
- [Galescu 2002 (ICSLP) - joint grapheme-phoneme alignment](https://www.isca-archive.org/icslp_2002/galescu02_icslp.pdf)

## Pronunciation lexicons (Scandinavian)

- [NB Pronunciation (Norsk ordbank) - Språkbanken](https://www.nb.no/sprakbanken/ressurskatalog/oai-nb-no-sbr-79/)
- [NB Uttale Work on Dialects (PDF)](https://www.nb.no/sbfil/uttaleleksikon/NB_Uttale_Work_on_Dialects.pdf)
- [NST uttaleleksikon for dansk - Språkbanken](https://www.nb.no/sprakbanken/ressurskatalog/oai-nb-no-sbr-26/)
- [Lingit uttaleleksikon for nynorsk - Språkbanken](https://www.nb.no/sprakbanken/ressurskatalog/oai-nb-no-sbr-65/)
- [Norsk ordbank - bokmål 2005 - Språkbanken](https://www.nb.no/sprakbanken/ressurskatalog/oai-nb-no-sbr-5/)
- [Norsk ordbank - nynorsk 2012 - Språkbanken](https://www.nb.no/sprakbanken/ressurskatalog/oai-nb-no-sbr-41/)

## Pronunciation dictionaries / data

- [flexthink/librig2p-nostress-space (Hugging Face)](https://huggingface.co/datasets/flexthink/librig2p-nostress-space/viewer/default/sentence_train?row=10)
- [australian-lexicon: Australian IPA phonemes](https://github.com/twocs/australian-lexicon/blob/master/pronunciation_dictionary/australian-ipa-phonemes.xml)
- [GlobalPhone Language Models](https://www.csl.uni-bremen.de/GlobalPhone/)
- [CMU Sphinx Acoustic and Language Models (SourceForge)](https://sourceforge.net/projects/cmusphinx/files/Acoustic%20and%20Language%20Models/)
