---
toc: false
layout: post
hidden: true
description: Book chapter summary from ChatGPT
title: Optimizing the Extraction of Vowel Formants
categories: [chatgpt, formants]
---

# Chapter Summary — *Optimizing the Extraction of Vowel Formants*

*[Skarnitzl, Vaňková & Bořil (2015)](https://www.researchgate.net/publication/281177316_Optimizing_the_Extraction_of_Vowel_Formants)* 

```bibtex
@inbook{skarnitzl2015optimizing,
  author = {Skarnitzl, Radek and Vaňková, Jitka and Boril, Tomas},
  year = {2015},
  month = {06},
  pages = {165-182},
  title = {Optimizing the Extraction of Vowel Formants},
  isbn = {978-80-7308-558-2}
}
```

## Overview

This chapter investigates **how to improve automatic vowel formant extraction**, focusing on whether the **default settings in Praat and Snack/WaveSurfer are actually optimal**. Although formants are widely used and easy to obtain with software defaults, the authors argue that **accurate extraction is much more complex than it appears**, especially when benchmarked against carefully established manual measurements. 

The chapter has **two main goals**:

1. **Test multiple LPC/formant settings** in Praat and Snack
2. **Compare Praat vs. Snack performance** against manually labelled “ground truth” vowel formants 

---

## 1) Building a “Ground Truth” Dataset

To evaluate software settings, the authors first created a **manual reference dataset**.

### Dataset

* **250 Czech vowel tokens**
* 5 short monophthongs: `/ɪ ɛ a o u/`
* Produced by **10 native Czech speakers**

  * 5 female
  * 5 male
* **F1–F3 measured at vowel midpoint**
* Two independent labellers measured every token 

### Labelling protocol

The authors used **strict visual measurement guidelines**:

* Maximized Praat editor window
* Frequency display:

  * 0–3 kHz for males
  * 0–3.5 kHz for females
* **10 ms spectrogram window**
* Primary decision based on **spectrogram darkness**
* Optional support:

  * Praat formant tracks
  * FFT spectrum view 

### Agreement results

Initial disagreement between labellers:

* F1 MAD: **50.8 Hz**
* F2 MAD: **49.3 Hz**
* F3 MAD: **83.6 Hz** 

After collaborative correction of large disagreements:

* F1: **29.0 Hz**
* F2: **29.1 Hz**
* F3: **32.9 Hz** 

This corrected average became the **ground truth reference**.

---

## 2) Why “Ground Truth” Is Still Uncertain

A major contribution of the chapter is showing that **manual measurements themselves are noisy**.

The authors identify **four uncertainty sources**:

### A. Screen + mouse resolution

Because spectrogram display is pixel-limited, cursor values occur in **discrete steps of ~24 Hz**, even if the software shows 1 Hz precision. 

### B. Spectrogram resolution

With a **10 ms window**, spectral resolution is inherently limited by the time-frequency tradeoff.

Estimated uncertainty contribution:

* **~30 Hz** 

### C. Estimating formant peaks from harmonics

Even when the vocal tract resonance is unchanged, **small F0 changes can visually shift the apparent formant peak**.

Observed effect:

* Up to **80 Hz shift**
* Especially important for F1/F2 estimation 

### D. Between-labeller variability

Even after consensus corrections:

* residual uncertainty ≈ **30 Hz** 

### Combined uncertainty

The authors combine these into a **95% confidence uncertainty of ±54 Hz** around any manually determined formant value. 

This is one of the most important methodological insights in the chapter.

---

## 3) Praat Performance

The authors systematically tested **Praat LPC settings**.

### Tested parameters

They varied:

* **LPC order: 8–12**
* Maximum formant frequency:

  * **5 kHz**
  * **5.5 kHz** 

### Main result

The **default Praat setting already performs very well**.

Slightly better alternatives were found:

* **Females:** LPC9, 5 kHz
* **Males:** LPC11, 5.5 kHz 

However, the improvement over defaults was:

* tiny for F1/F2
* only somewhat larger for F3
* still **smaller than the ±54 Hz uncertainty band**

So the authors conclude:

> **The practical improvement over Praat defaults is negligible.**

---

## 4) Praat vs Snack

A major motivation was the widespread belief that **Snack/WaveSurfer is better than Praat**.

### Result

The study found the opposite:

* **Praat consistently outperformed Snack**
* Especially strong advantage for **F2**
* Snack showed **much larger RMSD errors** across F1–F3 

This was a surprising result because informal phonetics practice often assumes Snack is superior.

### Best Snack settings

Best Snack configurations differed by gender:

* **Females:** autocorrelation
* **Males:** covariance
* 5 kHz range generally better than 5.5 kHz 

Still, even the best Snack settings remained worse than Praat.

---

## 5) Praat Tracker vs Extractor

The authors also tested **Praat’s formant tracker**, which uses temporal continuity constraints (tracking trajectories rather than framewise extraction).

### Result

* Generally **similar to Praat extraction**
* No consistent improvement
* Worse for **male F3** 

So **tracking does not clearly outperform extraction**.

---

## 6) Final Recommendations

### Practical takeaway

For **high-quality studio vowel recordings**, the authors recommend:

* **Female speakers:**

  * LPC order **9**
  * max frequency **5 kHz**

* **Male speakers:**

  * LPC order **11**
  * max frequency **5.5 kHz** 

### But the bigger conclusion

Because manual uncertainty is already ±54 Hz:

> **Praat’s default settings are usually good enough in practice.**

The gains from “optimized” settings are often **not statistically meaningful**.

---

## Key Takeaways (Short Version)

* Formant extraction is **far less trivial than software defaults suggest**
* Manual “ground truth” itself carries **±54 Hz uncertainty**
* **Praat defaults are robust**
* Slight LPC tuning can help:

  * females → LPC9 / 5 kHz
  * males → LPC11 / 5.5 kHz
* **Snack is worse than Praat** on clean studio data
* Praat tracker offers **little benefit over extractor**
* F3 remains the **most difficult formant to estimate reliably**

