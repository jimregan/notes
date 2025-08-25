---
toc: true
layout: post
hidden: true
description: O'Reilly et al. (1999).
title: Outline - Stochastic pronunciation modelling from hand-labelled phonetic corpora
categories: [outline, paper, phonetics, asr]
---

[Stochastic pronunciation modelling from hand-labelled phonetic corpora](https://www.sciencedirect.com/science/article/pii/S0167639399000370)

```bibtex
@article{riley1999pronunciation,
title = {Stochastic pronunciation modelling from hand-labelled phonetic corpora},
journal = {Speech Communication},
volume = {29},
number = {2},
pages = {209-224},
year = {1999},
issn = {0167-6393},
doi = {https://doi.org/10.1016/S0167-6393(99)00037-0},
url = {https://www.sciencedirect.com/science/article/pii/S0167639399000370},
author = {Michael Riley and William Byrne and Michael Finke and Sanjeev Khudanpur and Andrej Ljolje and John McDonough and Harriet Nock and Murat Saraclar and Charles Wooters and George Zavaliagkos},
}
```

---

## 📑 Outline of Riley et al. (1999)

### 1. **Introduction**

* Motivation for modeling pronunciation variation
* Challenges of canonical dictionaries in ASR
* Advantages of learning from phonetically transcribed speech corpora

---

### 2. **Pronunciation Modeling Approach**

* Use of **decision trees** to learn mappings between:

  * Lexical (canonical) phoneme sequences
  * Observed surface phone sequences
* Model representation:

  * Input: phoneme with context (e.g., word position, neighboring phonemes)
  * Output: probabilistic distribution over phones
* Description of how variants are extracted from hand-labeled data

---

### 3. **Corpora Used**

* Description of three phonetic corpora:

  1. **TIMIT**: Read speech, clean recordings
  2. **ICSI Switchboard corpus**: Conversational telephone speech
  3. **CSLU Spontaneous Speech corpus**
* Details of:

  * Lexicon preparation
  * Forced alignment and phonetic transcription alignment methods

---

### 4. **Data Preparation**

* Canonical pronunciation lexicon derivation
* Aligning dictionary forms with hand-labeled surface realizations
* Mapping phones to phonemes (many-to-one and one-to-many mappings)

---

### 5. **Decision Tree Training**

* Learning pronunciation rules using CART-style decision trees
* Feature set for conditioning:

  * Left/right phonemic context
  * Word position
  * Stress markers
  * Part-of-speech tags (optional)
* Smoothing and pruning strategies

---

### 6. **Experimental Results**

* Evaluation metrics:

  * Word error rate (WER) improvement in ASR
  * Lexicon coverage increase
  * Comparison of baseline vs. expanded pronunciation lexicons
* Results on:

  * TIMIT (limited gain, due to low variation)
  * ICSI (more natural variation, larger gains)
  * CSLU (high variability, challenging data)

---

### 7. **Analysis and Discussion**

* Interpretation of decision tree outputs
* Nature of learned pronunciation rules:

  * Context-dependent deletions, insertions, substitutions
* Examples of learned patterns:

  * Flapping, vowel reduction, glottalization
* Observations on overfitting and rule generalization

---

### 8. **Comparison with Other Approaches**

* Rule-based vs. data-driven methods
* Relation to maximum entropy models
* Contrast with G2P models trained only on dictionaries

---

### 9. **Conclusion**

* Summary of findings:

  * Data-driven pronunciation modeling from hand-labeled corpora is effective
  * Learns interpretable and generalizable variation
* Limitations:

  * Dependency on high-quality phonetic corpora
* Future work:

  * Integration with G2P systems
  * Use of more diverse corpora
  * Better handling of spontaneous speech variation

---

