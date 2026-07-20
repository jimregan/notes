---
toc: false
layout: post
hidden: true
description: ChatGPT paper summary
title: Retrieval Augmented Generation based context discovery for ASR
categories: [chatgpt, summary]
---

# [Retrieval Augmented Generation based context discovery for ASR](https://aclanthology.org/2025.findings-emnlp.768/)

```bibtex
@inproceedings{dimitrios-etal-2025-retrieval,
    title = "Retrieval Augmented Generation based context discovery for {ASR}",
    author = "Dimitrios, Siskos  and
      Papadopoulos, Stavros  and
      Parada, Pablo Peso  and
      Zhang, Jisi  and
      Saravanan, Karthikeyan  and
      Drosou, Anastasios",
    editor = "Christodoulopoulos, Christos  and
      Chakraborty, Tanmoy  and
      Rose, Carolyn  and
      Peng, Violet",
    booktitle = "Findings of the Association for Computational Linguistics: EMNLP 2025",
    month = nov,
    year = "2025",
    address = "Suzhou, China",
    publisher = "Association for Computational Linguistics",
    url = "https://aclanthology.org/2025.findings-emnlp.768/",
    doi = "10.18653/v1/2025.findings-emnlp.768",
    pages = "14247--14254",
    ISBN = "979-8-89176-335-7",
}
```

## **Summary of the Paper**

**“Retrieval Augmented Generation based context discovery for ASR”** 

### **Goal**

The paper tackles a key weakness in Automatic Speech Recognition (ASR): poor performance on **rare or out-of-vocabulary (OOV) words** (e.g., names, domain terms). It focuses on **automatically discovering useful context** to improve transcription accuracy—without modifying the ASR model.

---

## **Key Idea**

The authors propose a **retrieval-based method (CB-RAG)** that:

* Uses embeddings (MiniLM) to represent previous transcript segments
* Retrieves **relevant context words** from a large vocabulary using similarity search
* Feeds this context into a **context-aware ASR system**

This is compared with two LLM-based alternatives:

1. **LLM-generated context (CB-LLM)** via prompting
2. **Post-ASR correction (LLM_fix)** to refine transcripts

---

## **Method Overview**

From the pipeline (Figure 1, page 2):

* Audio is split into segments (via VAD)
* Previous transcript segments are used to:

  * Retrieve context (RAG) **or**
  * Generate context (LLM)
* Context is injected into ASR
* Optionally, an LLM corrects the output afterward

---

## **Main Contributions**

1. **Model-agnostic retrieval method (CB-RAG)** for context generation
2. **Comparison of plug-and-play approaches** (retrieval vs LLM methods)
3. **Evaluation on real datasets** using black-box ASR systems

---

## **Results (Key Findings)**

From Table 2 (page 4):

* **CB-RAG reduces Word Error Rate (WER) by up to ~17% relative**
* **Oracle context (perfect knowledge)** gives up to ~24% improvement
* CB-RAG performs **as well as or better than LLM approaches**, despite:

  * Lower “context overlap”
  * But **higher diversity of retrieved terms**

### **Efficiency**

* CB-RAG is **much faster**:

  * ~1.0–1.3× slower than no-context baseline
  * LLM methods: **3–6× slower**

### **Best configuration**

* Using more retrieved words (c=250) and fewer past segments (k=10) works best

---

## **Key Insights**

* **Retrieval-based context beats LLM-based methods in practice**
* High-quality context ≠ high overlap with ground truth
* **Recent context matters more than long history**
* Lightweight methods can outperform large models in real-time systems

---

## **Limitations**

* CB-RAG may miss **semantic (not lexical) matches**
* Requires a **predefined vocabulary**
* LLM methods depend on prompt quality and are slower

---

## **Conclusion**

The proposed **CB-RAG approach** is:

* **Accurate** (lowest WER among practical methods)
* **Efficient** (low latency)
* **Flexible** (works with black-box ASR systems)

➡️ Best suited for **real-time or resource-constrained applications**, where LLM-based solutions are too expensive.

---

## Addendum

### **Core Reality Check**

Despite the framing, this paper is **not introducing a new paradigm**.
It is best understood as:

> **A modern reimplementation of classic contextual biasing / cache LM ideas using embeddings.**

The “RAG” label is largely superficial:

* No document grounding
* No multi-step reasoning
* No generation conditioned on retrieved knowledge
  → just **retrieval → word list → biasing**

---

### **Historical Context

The method closely mirrors long-standing techniques:

* Cache-based language models (recent context boosting)
* IR-based LM adaptation (retrieve relevant terms/docs)
* WFST contextual biasing (inject vocab at decode time)

The underlying pattern:

> **retrieve context → bias decoding → improve rare words**
> has existed since at least the early 2000s.

---

### **What’s Actually New (Narrowly)**

* Uses **dense embeddings instead of symbolic retrieval**
* Works in a **fully unsupervised, no-catalog setup**
* Designed for **black-box ASR (plug-and-play)**

These are **engineering updates**, not conceptual advances.

---

### **Limitations**

* Retrieval is still **lexical-heavy** (weak semantic generalization)
* No principled integration with decoding (unlike proper LM fusion)
* Gains are **incremental (~1–2 WER points in many cases)**
* “Context overlap” is low → suggests noisy or indirect improvements
* LLM comparisons are somewhat weak baselines (latency-heavy strawman)

---

### **Bottom Line Judgment**

* **Research novelty:** low
* **Engineering practicality:** decent
* **Conceptual insight:** minimal

👉 This is:

> **“a clean, practical baseline using modern tools”**

not:

> **“a paper that changes how we think about ASR or RAG”**

