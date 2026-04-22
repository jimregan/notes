---
toc: false
layout: post
hidden: true
description: ChatGPT paper summary
title: Exploring Practical Gaps in Using Cross Entropy to Implement Maximum Mutual Information Criterion for Rationalization
categories: [chatgpt, summary, paper]
---

## [Exploring Practical Gaps in Using Cross Entropy to Implement Maximum Mutual Information Criterion for Rationalization](https://direct.mit.edu/tacl/article/doi/10.1162/tacl_a_00758/131564/Exploring-Practical-Gaps-in-Using-Cross-Entropy-to)


```bibtex
@article{10.1162/tacl_a_00758,
    author = {Liu, Wei and Deng, Zhiying and Niu, Zhongyu and Wang, Jun and Wang, Haozhao and Li, Ruixuan},
    title = {Exploring Practical Gaps in Using Cross Entropy to Implement Maximum Mutual Information Criterion for Rationalization},
    journal = {Transactions of the Association for Computational Linguistics},
    volume = {13},
    pages = {577-594},
    year = {2025},
    month = {06},
    issn = {2307-387X},
    doi = {10.1162/tacl_a_00758},
    url = {https://doi.org/10.1162/tacl_a_00758},
    eprint = {https://direct.mit.edu/tacl/article-pdf/doi/10.1162/tacl_a_00758/2534936/tacl_a_00758.pdf},
}
```
---

## One-sentence takeaway

The paper shows that **standard rationale extraction models optimize the wrong practical signal**: instead of truly selecting the most informative text spans, they often overfit to a narrow region of candidate rationales because the predictor only learns from what the selector already samples. To fix this, the authors propose **Vicinal Evaluation Rationalization (VER)**, which perturbs selected rationales during training so the predictor learns to evaluate a *neighborhood* of plausible rationales instead of a single point. 

---

## What problem the paper studies

The setting is **NLP rationalization**:

* a **selector** picks a subset of tokens as a rationale
* a **predictor** makes the label prediction from only those tokens
* the rationale should be **faithful and human-interpretable**

The standard objective minimizes:

* prediction **cross-entropy on the selected rationale**

The paper argues that this is only an approximation to the ideal **maximum mutual information (MMI)** objective.

The key theoretical decomposition is:

* ideal: minimize **entropy** of label given rationale → pick most informative rationale
* practical: minimize **cross-entropy**
* cross-entropy = **true informativeness + predictor fitting error**

So the selector is rewarded not only for choosing informative rationales, but also for choosing rationales the predictor already happens to model well. 

---

## Main insight: the “practical gap”

The central finding is a **feedback loop failure**:

1. early in training, the selector finds some *reasonably good* rationale
2. it rapidly increases probability of selecting similar ones
3. the predictor mostly trains on this tiny local region
4. it becomes **biased toward that region**
5. potentially better rationales elsewhere are undervalued

So the predictor’s cross-entropy score stops being a good proxy for real informativeness.

The authors give strong evidence that:

* the selector’s sampled rationales quickly become almost identical across iterations
* gold human rationales can score **worse** than model-selected ones under the trained predictor
* predictor smoothness worsens, indicating overfitting to trivial patterns 

A particularly striking result:

> sometimes the trained predictor gives **higher accuracy to its own selected rationale than to the human gold rationale**, showing the predictor has become biased to its local training region. 

---

## Their proposed solution: VER

Their fix is surprisingly simple.

Instead of feeding the predictor only the selector’s exact rationale mask, they:

* randomly **flip some selected tokens off**
* replace them with the same number of previously unselected tokens
* preserve overall sparsity
* do this **only during training**

This creates a **vicinal neighborhood** around the selected rationale.

### Intuition

If the selector already finds a decent rationale, the true optimum is likely nearby in token-space.

So the predictor should learn to evaluate:

* not just one rationale
* but **a small local family of related rationales**

This improves the predictor’s approximation of the true conditional label distribution. 

---

## Results

The method is tested on:

* BeerAdvocate rationale benchmarks
* HotelReviews benchmarks
* MultiRC
* FEVER
* also BERT-based settings

### Main empirical gains

Compared with strong baselines:

* **up to +6.6 F1** rationale quality improvement
* consistently better overlap with human rationales
* better predictor evaluation of gold rationales
* improvements transfer to reading comprehension and fact verification tasks 

The gains are strongest on rationale quality rather than classification accuracy, which is appropriate because explanation quality is the main target.

---

## Why this paper matters

This is a strong paper because it contributes at **three levels**:

### 1) Theory

It clearly separates:

* **rationale informativeness**
* **predictor approximation bias**

That decomposition explains why cross-entropy optimization can fail.

### 2) Diagnosis

The empirical evidence is unusually convincing:

* selector collapse
* local overfitting
* poor valuation of gold rationales
* smoothness analysis

### 3) Practical method

VER is:

* simple
* architecture-agnostic
* easy to add to existing rationalization pipelines
* compatible with future methods

So it is both **conceptually insightful and practically useful**. 

---

## My quick evaluation

The strongest idea here is that **the failure is not in mutual information theory, but in the *cross-entropy surrogate under cooperative training dynamics*.**

That’s a subtle but important distinction.

The proposed perturbation method is elegant because it directly targets the mismatch without adding heavy auxiliary modules.

A limitation the authors mention:

* the framework still captures **correlation, not causation**
* causal rationale extraction remains future work 

---

> **Using cross-entropy loss is often an implicit way of optimizing a maximum mutual information (MMI) objective.**

The paper’s real contribution is not the application, but a careful analysis of **when this surrogate works and when it breaks**. 

---

# The core mathematical idea

Suppose you want a representation (Z) (features, selected tokens, latent variable, etc.) that preserves as much information as possible about a target (Y).

The ideal MMI objective is:

I(Y;Z)=H(Y)-H(Y\mid Z)

Since (H(Y)) is fixed for a dataset, maximizing mutual information is equivalent to minimizing:

H(Y\mid Z)

So the true target is:

> make (Y) as predictable as possible from (Z)

---

# Why people replace it with cross-entropy

The problem is that the true conditional distribution (P(Y\mid Z)) is unknown.

So instead we train a model (q_\theta(Y\mid Z)) and minimize:

\mathbb{E}[-\log q_\theta(Y\mid Z)]

This is just the **cross-entropy loss**.

The key identity is:

H_c(Y,\hat Y\mid Z)=H(Y\mid Z)+D_{KL}(P(Y\mid Z)|q_\theta(Y\mid Z))

This is the whole story.

So minimizing cross-entropy means minimizing:

1. **the true conditional entropy** → the MMI part you actually want
2. **the approximation error of your predictor**

This is why CE is such a common surrogate for MMI. 

---

# The deep insight: CE is only a *variational upper bound*

A very useful way to think about this:

> cross-entropy is a **tractable upper bound** on conditional entropy

because KL divergence is always nonnegative.

So:

H_c(Y,\hat Y\mid Z)\ge H(Y\mid Z)

Therefore minimizing CE indirectly pushes down the true conditional entropy.

This idea appears everywhere:

* **InfoMax / Deep InfoMax**
* **contrastive learning**
* **variational information bottleneck**
* **CPC / InfoNCE**
* **representation learning**
* **feature selection**
* **rationale extraction**
* **self-supervised predictive coding**

So yes—the paper’s setup is just one instance of a much broader information-theoretic trick.

---

# When this surrogate is good

The surrogate is excellent when your predictor family is expressive enough that:

[
q_\theta(Y\mid Z)\approx P(Y\mid Z)
]

Then the KL term becomes small, so CE closely tracks the true conditional entropy.

This is why in standard supervised learning we often casually say:

> “minimizing CE maximizes information about the label”

That statement is approximately true **if the decoder is strong enough**.

---

# When it fails (the important lesson from this paper)

The subtle point this paper highlights is:

> minimizing CE only maximizes MI **through the lens of the predictor you trained**

If the predictor is biased, underfit, overfit, or only sees part of the space, the KL term dominates.

Then CE can strongly disagree with true informativeness.

This is a very general warning.

It means:

* a **bad decoder makes CE a bad MI estimator**
* local training dynamics can distort MI optimization
* optimization may favor regions where the decoder is easy to fit, rather than truly informative regions 

That idea is broadly useful in latent-variable models and representation learning.

---

# Big-picture interpretation

The most reusable takeaway is:

> **Cross-entropy is not mutual information itself.**
> It is **conditional entropy + decoder approximation bias**.

So whenever you see CE used as an “information maximization” objective, always ask:

> *How much of the loss is actual information, and how much is decoder error?*

That’s the conceptual gem in this paper.

---

# Why this matters outside their topic

This insight generalizes immediately to:

### Representation learning

A representation may look “informative” only because the decoder is weak.

### Latent variable models

Posterior collapse can be reinterpreted as CE dominating the MI term.

### Contrastive learning

InfoNCE is another surrogate bound with similar decoder/critic dependence.

### Feature selection

Selected features may be chosen because the downstream classifier likes them, not because they maximize true information.

So this paper’s lesson is a **general caution about variational surrogates for MI**.

---

Personally, I think the most elegant takeaway is this sentence:

> **Cross-entropy is a model-dependent estimator of conditional entropy.**

That framing is useful in almost every ML subfield.

If you'd like, I can connect this idea directly to **InfoNCE and contrastive learning**, where the same “MI-via-cross-entropy” trick is even more common.

