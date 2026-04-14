Here’s a concise summary of the paper **“Exploring Practical Gaps in Using Cross Entropy to Implement Maximum Mutual Information Criterion for Rationalization”**. 

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

If you'd like, I can next give you a **“reviewer-style critique” (strengths, weaknesses, novelty, and likely acceptance reasons)**.

