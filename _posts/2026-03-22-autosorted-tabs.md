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

- [Parliamentary Corpora](https://www.clarin.eu/resource-families/parliamentary-corpora)
- [Legal Corpora](https://www.clarin.eu/resource-families/legal-corpora)
- [Sign Language Resources](https://www.clarin.eu/resource-families/sign-language-resources)
- [Licenses and CLARIN Categories](https://www.clarin.eu/content/licenses-and-clarin-categories)
- [CLARIN Licensing Framework](https://www.clarin.eu/content/clarin-licensing-framework)
- [JRC EU DGT Translation Memory Parsebank DGT-UD 1.0](https://www.clarin.si/repository/xmlui/handle/11356/1197)


# Grapheme-to-Phoneme (G2P)

## Tools / models

- [spring-media/DeepPhonemizer: Grapheme to phoneme with deep learning](https://github.com/spring-media/DeepPhonemizer?tab=readme-ov-file)
- [DeepPhonemizer training notebook (Colab)](https://colab.research.google.com/github/as-ideas/DeepPhonemizer/blob/main/dp/notebooks/Training_Example.ipynb)
- [lingjzhu/CharsiuG2P: Multilingual G2P in 100 languages](https://github.com/lingjzhu/CharsiuG2P)
- [charsiu/g2p_multilingual_byT5_small_100](https://huggingface.co/charsiu/g2p_multilingual_byT5_small_100)
- [CharsiuG2P fine-tuning low-resource notebook](https://github.com/lingjzhu/CharsiuG2P/blob/main/notebooks/finetuning_low_resource.ipynb)
- [fdemelo/g2p-mbyt5-12l-ipa-childes-espeak](https://huggingface.co/fdemelo/g2p-mbyt5-12l-ipa-childes-espeak)
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
- [Italianising English words with G2P in TTS](https://uu.diva-portal.org/smash/record.jsf?pid=diva2%3A1868326&dswid=6766)
- [Stress Assignment in Letter to Sound Rules](https://aclanthology.org/P85-1030.pdf)
- [Phoneme-to-Grapheme Conversion Based Large-Scale Pre-Training for ASR](https://www.isca-archive.org/interspeech_2020/masumura20_interspeech.pdf)
- [Knowledge of language origin improves pronunciation of proper names](https://www.researchgate.net/publication/362423262_Knowledge_of_language_origin_improves_pronunciation_accuracy_of_proper_names)
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

# Northern Sami

## Corpora

- [Giellagas corpus (Kielipankki)](https://www.kielipankki.fi/aineistot/giellagas/)
- [Giellagas license page](https://www.kielipankki.fi/lic/giellagas/?lang=en)
- [Kielipankki access](https://www.kielipankki.fi/access/)
- [LIA sápmi - LIA corpus of Sami dialects (Språkbanken)](https://www.nb.no/sprakbanken/en/resource-catalogue/oai-tekstlab-uio-no-lia-sapmi/)
- [Northern Sami YleAreena Subtitle Corpus (Zenodo)](https://zenodo.org/records/14176353)
- [Northern Saami interactive text corpus (Giellatekno)](https://giellatekno.uit.no/text.en.html)
- [COMEDI editor (Clarino)](https://clarino.uib.no/comedi/editor/lb-201407302)
- [UD_North_Sami-Giella](https://github.com/UniversalDependencies/UD_North_Sami-Giella)

## ASR models

- [GetmanY1/wav2vec2-large-sami-22k-finetuned](https://huggingface.co/GetmanY1/wav2vec2-large-sami-22k-finetuned)
- [Fine-Tune W2V2-Bert for low-resource ASR](https://huggingface.co/blog/fine-tune-w2v2-bert)
- [facebook/w2v-bert-2.0](https://huggingface.co/facebook/w2v-bert-2.0)
- [SeamlessM4T-v2 docs](https://huggingface.co/docs/transformers/main/en/model_doc/seamless_m4t_v2)
- [facebook/seamless-m4t-v2-large](https://huggingface.co/facebook/seamless-m4t-v2-large)
- [divvun-tts/multi-sami HF Space](https://huggingface.co/spaces/divvun-tts/multi-sami)
- [Getman 2024 Interspeech paper](https://www.isca-archive.org/interspeech_2024/getman24b_interspeech.pdf)
- [anyspeech/zipa-large-crctc-ns-800k](https://huggingface.co/anyspeech/zipa-large-crctc-ns-800k)

## Phonetics / phonology

- [Guide to North Sámi Pronunciation (Oahpa Muinna)](https://oahpamuinna.wordpress.com/2021/12/28/guide-to-north-sami-pronunciation/)
- [Forvo: Northern Sami pronunciation dictionary](https://forvo.com/languages/sme/)
- [Forvo: čáhci pronunciation](https://forvo.com/word/%C4%8D%C3%A1hci/#sme)
- [Wiktionnaire: Annexe:Prononciation/same du Nord](https://fr.wiktionary.org/wiki/Annexe:Prononciation/same_du_Nord)
- [Wayback: Odden Saami phonology PDF](https://web.archive.org/web/20141209061155/http://www.ling.ohio-state.edu/~odden/Saami.pdf)
- [Sami Grammar - Vocabulary (archived)](https://web.archive.org/web/20190504031515/https://people.uta.fi/~km56049/same/svocab.html)
- [The acoustic manifestation of consonant gradation in Northern Sami (KTH)](https://kth-ch.primo.exlibrisgroup.com/discovery/fulldisplay?docid=cdi_crossref_primary_10_1121_1_2935810&context=PC&vid=46KTH_INST:46KTH_VU1_L&lang=en&search_scope=MyInst_and_CI&adaptor=Primo%20Central&tab=Everything&query=any,contains,Northern%20S%C3%A1mi%20phonetics&offset=0)
- [An analysis of North Saami gradation](https://www-jstor-org.focus.lib.kth.se/stable/23325576)
- [Dialectal variation of duration patterns in Finnmark North Sámi (KTH)](https://kth-ch.primo.exlibrisgroup.com/discovery/fulldisplay?docid=cdi_crossref_citationtrail_10_1121_10_0000994&context=PC&vid=46KTH_INST:46KTH_VU1_L&lang=en&search_scope=MyInst_and_CI&adaptor=Primo%20Central&tab=Everything&query=any,contains,North%20S%C3%A1mi%20phonetics&offset=0)
- [Initially and Finally Stressed Vowel Sequences of Guovdageaidnu Dialect (KTH)](https://kth-ch.primo.exlibrisgroup.com/discovery/fulldisplay?docid=cdi_proquest_miscellaneous_85665862&context=PC&vid=46KTH_INST:46KTH_VU1_L&lang=en&search_scope=MyInst_and_CI&adaptor=Primo%20Central&tab=Everything&query=any,contains,North%20S%C3%A1mi%20phonetics&offset=0)
- [Helsinki paper (content link)](https://helda.helsinki.fi/server/api/core/bitstreams/05486b7f-e5ab-44a4-8540-3affa4fc5a35/content)

## Learning resources / language documentation

- [DigiSami project](https://blogs.helsinki.fi/digisami-project/)
- [DigiSami IT paper](https://blogs.helsinki.fi/digisami-project/files/2020/02/ds-it.pdf)
- [Yle: Say it in Saami soundboard](http://sayitinsaami.yle.fi/soundboard/)
- [Learn North-Sámi part 1 (YouTube)](https://www.youtube.com/watch?v=kyv058EeNR0&t=321s)
- [About the Sámi languages (YouTube)](https://www.youtube.com/watch?v=Njk18l5BxqA)
- [Finnish-Samish YouTube channel](https://www.youtube.com/@Finnish-Samish/videos)
- [Northern sami - 10 common words (YouTube)](https://www.youtube.com/watch?v=uPX6qb1eao8)
- [Numbers in Northern Sami 1-100 (YouTube)](https://www.youtube.com/watch?v=Ni9IHyGHDng)
- [From Language to Language From Mind to Nation 9 (ovttas.no)](https://ovttas.no/girji_gielas-gillii-mielas-millii-9)
- [About the Sámi Parliament (Sametinget)](https://sametinget.no/about-the-sami-parliament/)
- [Radio and Television Archive - Kavi (Finland)](https://kavi.fi/en/radio-ja-televisioarkistointia-vuodesta-2008/)

# Multilingual / Low-Resource ASR

## Omnilingual ASR (Facebook Research)

- [facebookresearch/omnilingual-asr: Open-Source Multilingual Speech Recognition for 1600+ Languages](https://github.com/facebookresearch/omnilingual-asr?tab=readme-ov-file#installation)
- [facebook/omniASR-LLM-7B (Hugging Face)](https://huggingface.co/facebook/omniASR-LLM-7B)
- [omnilingual-asr data preparation README](https://github.com/facebookresearch/omnilingual-asr/blob/main/workflows/dataprep/README.md)
- [omnilingual-asr per-language results (7B LLM ASR)](https://github.com/facebookresearch/omnilingual-asr/blob/main/per_language_results_table_7B_llm_asr.csv)

## OWSM (Open Whisper-style Speech Models)

- [OWSM V4 Demo Space (ESPnet)](https://huggingface.co/spaces/espnet/OWSM_V4_Demo)
- [espnet/owsm_ctc_v3.1_1B (Hugging Face)](https://huggingface.co/espnet/owsm_ctc_v3.1_1B)

## Audio LLM / speech-language model frameworks

- [X-LANCE/SLAM-LLM: Speech, Language, Audio, Music with LLM](https://github.com/X-LANCE/SLAM-LLM)
- [SLAM-LLM speech-to-speech README](https://github.com/X-LANCE/SLAM-LLM/blob/main/examples/s2s/README.md)
- [FunAudioLLM/CosyVoice: Multilingual large voice generation model](https://github.com/FunAudioLLM/CosyVoice)
- [modelscope/FunASR](https://github.com/modelscope/FunASR)
- [Continuous Audio Language Models (2509.06926)](https://arxiv.org/abs/2509.06926)
- [Bridging the Modality Gap: Softly Discretizing Audio for LLM-based ASR (2506.05706)](https://arxiv.org/abs/2506.05706)
- [Retrieval Augmented Generation based context discovery for ASR (2509.19567)](https://arxiv.org/abs/2509.19567)
- [NLE: Non-autoregressive LLM-based ASR by Transcript Editing](https://arxiv.org/pdf/2603.08397)
- [Bridging the gap: Speech-LLM and end-to-end for multilingual conversational ASR](https://arxiv.org/pdf/2601.01461)

## W2V2 / multilingual fine-tuning

- [Fine-Tune W2V2-Bert for low-resource ASR (HF blog)](https://huggingface.co/blog/fine-tune-w2v2-bert)
- [facebook/w2v-bert-2.0 (Hugging Face)](https://huggingface.co/facebook/w2v-bert-2.0)
- [facebook/seamless-m4t-v2-large (Hugging Face)](https://huggingface.co/facebook/seamless-m4t-v2-large)
- [GetmanY1/wav2vec2-large-sami-22k-finetuned (Hugging Face)](https://huggingface.co/GetmanY1/wav2vec2-large-sami-22k-finetuned)
- [Getman 2024 Interspeech paper](https://www.isca-archive.org/interspeech_2024/getman24b_interspeech.pdf)
- [KBLab/kb-whisper-large (Hugging Face)](https://huggingface.co/KBLab/kb-whisper-large)

## SIGUL: Low-resource and endangered language NLP

- [SIGUL 2024 Proceedings (LREC-COLING)](https://aclanthology.org/events/lrec-2024/#2024sigul-1)
- [Assessing Pre-Built Speaker Recognition Models for Endangered Language Data](https://aclanthology.org/2024.sigul-1.4/)
- [Tandem Long-Short Duration-based Modeling for ASR](https://aclanthology.org/2024.sigul-1.40.pdf)
- [SIGUL 2026 Joint Workshop CfP](https://groups.google.com/g/open-linguistics/c/oDrgoVNUcf0)
- [LaTeLL 2026: Language Technologies for Low-resource Languages](https://latell.org/2026/)


# CTC Decoding and Forced Alignment

## CTC decoding

- [CTC Networks and Language Models: Prefix Beam Search Explained (Medium)](https://medium.com/corti-ai/ctc-networks-and-language-models-prefix-beam-search-explained-c11d1ee23306)
- [kensho-technologies/pyctcdecode: Fast and lightweight CTC beam search decoder](https://github.com/kensho-technologies/pyctcdecode)
- [torchaudio ctc_decoder documentation](https://docs.pytorch.org/audio/main/generated/torchaudio.models.decoder.ctc_decoder.html)
- [torchaudio CTCDecoder documentation](https://docs.pytorch.org/audio/main/generated/torchaudio.models.decoder.CTCDecoder.html#torchaudio.models.decoder.CTCDecoderLM)
- [ASR Inference with CTC Decoder tutorial (torchaudio)](https://docs.pytorch.org/audio/main/tutorials/asr_inference_with_ctc_decoder_tutorial.html)
- [ASR inference with CUDA CTC decoder tutorial](https://docs.pytorch.org/audio/2.5.0/tutorials/asr_inference_with_cuda_ctc_decoder_tutorial.html)
- [SpeechBrain CTC prefix beam search docs](https://speechbrain.readthedocs.io/en/latest/API/speechbrain.decoders.ctc.html#speechbrain.decoders.ctc.CTCPrefixBeamSearcher)
- [FlexCTC: GPU-powered CTC Beam Decoding With Advanced Contextual Abilities](https://arxiv.org/pdf/2508.07315)

## Forced alignment tools

- [lumaku/ctc-segmentation: Segment audio and obtain utterance alignments](https://github.com/lumaku/ctc-segmentation?tab=readme-ov-file)
- [m-bain/whisperX alignment module](https://github.com/m-bain/whisperX/blob/main/whisperx/alignment.py)
- [tabahi/bournemouth-forced-aligner](https://github.com/tabahi/bournemouth-forced-aligner/blob/main/examples/read_embeddings.py)
- [BFA: Real-time Multilingual Text-to-speech Forced Alignment (2509.23147)](https://arxiv.org/pdf/2509.23147)
- [tabahi/contexless-phonemes-CUPE](https://github.com/tabahi/contexless-phonemes-CUPE)
- [CUPE: Contextless Universal Phoneme Encoder (2508.15316)](https://arxiv.org/abs/2508.15316)
- [mlx-audio Qwen3 forced aligner](https://github.com/Blaizzy/mlx-audio/tree/main/mlx_audio/stt/models/qwen3_forced_aligner)
- [mlx-community/Qwen3-ForcedAligner-0.6B-4bit (Hugging Face)](https://huggingface.co/mlx-community/Qwen3-ForcedAligner-0.6B-4bit)
- [bertsky/nmalign: Forced alignment of string lists by fuzzy string matching](https://github.com/bertsky/nmalign?tab=readme-ov-file)
- [emilyahn/align_cs](https://github.com/emilyahn/align_cs)

## Phoneme recognition / IPA models

- [kgnlp/allophant: Multilingual phoneme recognizer with zero-shot generalization](https://github.com/kgnlp/allophant?tab=readme-ov-file)
- [lingjzhu/zipa: IPA-based ASR](https://github.com/lingjzhu/zipa/blob/main/ipa_simplified/unigram_127.vocab)
- [anyspeech/zipa-large-crctc-ns-800k (Hugging Face)](https://huggingface.co/anyspeech/zipa-large-crctc-ns-800k)
- [PRiSM: Benchmarking Phone Realization in Speech Models (2601.14046)](https://arxiv.org/abs/2601.14046)
- [lingjzhu/clap-ipa](https://github.com/lingjzhu/clap-ipa/blob/main/README.md)
- [anyspeech/ipapack_plus_meta (Hugging Face)](https://huggingface.co/datasets/anyspeech/ipapack_plus_meta)
- [allophoible](https://github.com/Aariciah/allophoible/blob/main/README.md)
- [xinjli/ucla-phonetic-corpus](https://github.com/xinjli/ucla-phonetic-corpus?tab=readme-ov-file)
- [VinAIResearch/XPhoneBERT (Interspeech 2023)](https://github.com/VinAIResearch/XPhoneBERT)

## Segmentation / other

- [felixkreuk/UnsupSeg: Unsupervised segmentation](https://github.com/felixkreuk/UnsupSeg/blob/master/predict.py)
- [Dysfluent WFST: Zero-Shot Speech Dysfluency Transcription (2505.16351)](https://arxiv.org/pdf/2505.16351)


# Disentangled Speech Representations / Voice Conversion

## Key models / implementations

- [Berkeley-Speech-Group/sparc: Speech Articulatory Coding](https://github.com/Berkeley-Speech-Group/Speech-Articulatory-Coding?tab=readme-ov-file)
- [SPARC demo notebook (Colab)](https://colab.research.google.com/drive/1TVGJJpOzPiesLPo46gZNCQLMl-y_QIKe#scrollTo=NCNkC9sk_Od3)
- [cheoljun95/Speech-Articulatory-Coding (Hugging Face model)](https://huggingface.co/cheoljun95/Speech-Articulatory-Coding/blob/main/model_english_1500k.yaml)
- [Berkeley-Speech-Group/sylber: Syllabic Embedding Representation of Speech](https://github.com/Berkeley-Speech-Group/sylber/tree/main)
- [light1726/SpeechTripleNet: End-to-End Disentangled Speech (content, timbre, prosody)](https://github.com/light1726/SpeechTripleNet?tab=readme-ov-file)
- [SpeechTripleNet demo page](https://speechtriplenet.github.io/)
- [auspicious3000/SpeechSplit: Unsupervised Speech Decomposition via Triple Information Bottleneck](https://github.com/auspicious3000/SpeechSplit/blob/master/make_spect_f0.py)
- [ContentVec: An Improved Self-Supervised Speech Representation by Disentangling Speakers (ICML 2022)](https://proceedings.mlr.press/v162/qian22b.html)
- [YoungSeng/SRD-VC](https://github.com/YoungSeng/SRD-VC/blob/master/f0_pcc.py)
- [synspeech.github.io: Learning Disentangled Speech Representations](https://synspeech.github.io/)

## Papers

- [Learning Disentangled Speech Representations (2311.03389)](https://arxiv.org/abs/2311.03389)
- [Learning Disentangled Speech Representations with Contrastive Learning and Time-Invariant Retrieval (2401.08096)](https://arxiv.org/abs/2401.08096)
- [VQ-CL: Learning Disentangled Speech with Contrastive Learning and Vector Quantization (ICASSP 2023)](https://ieeexplore.ieee.org/abstract/document/10095654)
- [SpeechTripleNet: End-to-End Disentangled Speech Representation Learning (ACM MM 2023)](https://dl.acm.org/doi/10.1145/3581783.3612485)
- [Unsupervised speech decomposition via triple information bottleneck (ICML 2020)](https://dl.acm.org/doi/10.5555/3524938.3525664)
- [Adversarially Learning Disentangled Speech Representations for Robust Multi-Factor Voice Conversion (Interspeech 2021)](https://www.isca-archive.org/interspeech_2021/wang21h_interspeech.html)
- [Disentangled Speech Representation for Cross-Lingual Voice Conversion Using β-VAE (IEEE 2023)](https://ieeexplore.ieee.org/document/10022787)
- [An Overview of Voice Conversion and its Challenges (2008.03648)](https://arxiv.org/abs/2008.03648)
- [ContentVec: An Improved Self-Supervised Speech Representation by Disentangling Speakers (2204.09224)](https://arxiv.org/abs/2204.09224)
- [MeanVoiceFlow: One-step Nonparallel Voice Conversion with Mean Flows (2602.18104)](https://arxiv.org/abs/2602.18104)
- [Speech to Speech Synthesis for Voice Impersonation (2602.16721)](https://arxiv.org/abs/2602.16721)
- [Representation Learning with Contrastive Predictive Coding (1807.03748)](https://arxiv.org/abs/1807.03748)
- [beta-VAE: Learning Basic Visual Concepts with a Constrained Variational Framework (OpenReview)](https://openreview.net/forum?id=Sy2fzU9gl)

## Pitch / prosody tools

- [maxrmorrison/torchcrepe: PyTorch CREPE pitch tracker](https://github.com/maxrmorrison/torchcrepe?tab=readme-ov-file)
- [interactiveaudiolab/penn: Pitch Estimating Neural Networks](https://github.com/interactiveaudiolab/penn?tab=readme-ov-file)
- [maxrmorrison/torbi: Viterbi decoding in PyTorch](https://github.com/maxrmorrison/torbi)
- [marl/crepe](https://github.com/marl/crepe/blob/master/crepe/core.py)

## Datasets

- [ylacombe/expresso (Hugging Face)](https://huggingface.co/datasets/ylacombe/expresso)
- [EXPRESSO dataset demo page](https://speechbot.github.io/expresso/)
- [EXPRESSO paper (Interspeech 2023, 2308.05725)](https://arxiv.org/pdf/2308.05725)


# Distributed Training

## Ray

- [ray-project/ray: AI compute engine and distributed runtime](https://github.com/ray-project/ray?tab=readme-ov-file)
- [Ray Train: Scalable Model Training](https://docs.ray.io/en/latest/train/train.html)
- [Ray Train Overview](https://docs.ray.io/en/latest/train/overview.html#train-overview)
- [Get Started with Distributed Training using PyTorch Lightning](https://docs.ray.io/en/latest/train/getting-started-pytorch-lightning.html#train-pytorch-lightning)
- [Get Started with Distributed Training using Hugging Face Transformers](https://docs.ray.io/en/latest/train/getting-started-transformers.html#train-pytorch-transformers)
- [Loading Data in Ray](https://docs.ray.io/en/latest/data/loading-data.html#loading-data-from-other-libraries)

## Submitit (Slurm)

- [facebookincubator/submitit: Python toolbox for submitting jobs to Slurm](https://github.com/facebookincubator/submitit?tab=readme-ov-file)
- [submitit examples](https://github.com/facebookincubator/submitit/blob/main/docs/examples.md)

## Lhotse

- [lhotse-speech/lhotse PR diff (patch-diff)](https://patch-diff.githubusercontent.com/raw/lhotse-speech/lhotse/pull/1506.diff)


# LibriVox and English Accent Data

## LibriVox wiki / data collection

- [LibriVox wiki main page](https://wiki.librivox.org/index.php?title=Main_Page)
- [Accents Table - LibriVox wiki](https://wiki.librivox.org/index.php?title=Accents_Table)
- [Recordings of Books on the Ambleside List](https://wiki.librivox.org/index.php?title=Recordings_of_Books_on_the_Ambleside_List)
- [Recordings of Books on the Ambleside List 2](https://wiki.librivox.org/index.php?title=Recordings_of_Books_on_the_Ambleside_List_2)
- [Other British Readers on LibriVox (RuthieG's CataBlog)](https://golding.wordpress.com/home/other-british-readers-on-librivox/)

## Multi-accent speech datasets

- [Open-source Multi-speaker Corpora of English Accents in the British Isles (LREC 2020)](https://aclanthology.org/2020.lrec-1.804.pdf)
- [The Edinburgh International Accents of English Corpus](https://datashare.ed.ac.uk/handle/10283/8983)
- [The Voice Bank Corpus: Large Regional Accent Speech Database (IEEE 2013)](https://ieeexplore.ieee.org/document/6709856)
- [CSTR VCTK Corpus: English Multi-speaker Corpus](https://datashare.ed.ac.uk/handle/10283/3443)
- [KBLab/rixvox-v2 (Swedish) (Hugging Face)](https://huggingface.co/datasets/KBLab/rixvox-v2)
- [Google Nigerian English (MFA models)](https://mfa-models.readthedocs.io/en/latest/corpus/English/Google%20Nigerian%20English.html)
- [kth-tmh/google-britain-ireland (Hugging Face)](https://huggingface.co/datasets/kth-tmh/google-britain-ireland/blob/main/dataset/dataset_info.json)
- [LibriTTS British Accents (GitHub)](https://github.com/OscarVanL/LibriTTS-British-Accents)
- [Speech Accent Archive (Weinberger & Kunath)](https://sites.ualberta.ca/~aacl2009/PDFs/WeinbergerKunath2009AACL.pdf)
- [cvaccents notebook (Kathy Reid)](https://github.com/KathyReid/cvaccents/blob/master/cvaccents-v9.ipynb)
- [Effect AI Scripted Speech 1.0 - English (Mozilla Data Collective)](https://datacollective.mozillafoundation.org/datasets/cmkfm9fbl00nto0070sdcrak2)
- [Common Voice Spontaneous Speech 3.0 - English](https://datacollective.mozillafoundation.org/datasets/cmn1pv5hi00uto1072y1074y7)
- [Common Voice Spontaneous Speech 3.0 - Irish](https://datacollective.mozillafoundation.org/datasets/cmmy33q7l0018mf0721oocrh7)
- [IDEA: Accents and Dialects of Europe](https://www.dialectsarchive.com/europe)
- [Accents of English (Cambridge book)](https://www.cambridge.org/core/books/accents-of-english/1E9E89C38DFD0AB53B47EF96D8442594)

## Edinburgh / CSTR datasets

- [Centre for Speech Technology Research (CSTR) data](https://datashare.ed.ac.uk/handle/10283/302)
- [NST (Natural Speech Technology) data (Edinburgh)](https://datashare.ed.ac.uk/handle/10283/786)
- [Listening test materials for modern speech synthesis evaluation](https://datashare.ed.ac.uk/handle/10283/3289)
