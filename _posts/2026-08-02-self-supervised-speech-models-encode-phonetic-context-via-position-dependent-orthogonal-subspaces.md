---
toc: true
layout: post
hidden: true
description: ChatGPT paper summary
title: Self-Supervised Speech Models Encode Phonetic Context via Position-dependent Orthogonal Subspaces
categories: [summary, chatgpt]
---

# *Self-Supervised Speech Models Encode Phonetic Context via Position-dependent Orthogonal Subspaces*

Kwanghee Choi, Eunjung Yeo, Cheol Jun Cho, David R. Mortensen, and David Harwath, 2026. 

## Central idea

The paper asks what it actually means for Transformer-based self-supervised speech models (S3Ms) to produce **contextualized frame representations**.

Its proposed answer is quite specific. A representation at one time step does not merely encode the phone acoustically aligned with that frame. It contains phonological information about a **sequence of phones around that frame**, but keeps information about different relative positions separate.

Schematically, a frame within phone (p^0) is proposed to contain something like

[
r_t
\approx
v^{-1}*{p^{-1}}
+
v^0*{p^0}
+
v^{+1}_{p^{+1}}
+\cdots
]

where the superscript indicates relative phone position. Crucially,

[
v_{\text{voice}}^{-1}
]

and

[
v_{\text{voice}}^{0}
]

are not simply the same voicing vector added twice. The authors argue that phonological information for different relative positions occupies approximately **orthogonal subspaces**. Thus the representation can distinguish “the previous phone is voiced” from “the current phone is voiced.”

The second major claim is that those relative positions are defined with respect to **phonetic segments**, rather than fixed amounts of elapsed time. As the signal crosses a phone boundary, the same underlying phone changes from “current” to “previous,” etc., and the corresponding representation shifts between positional subspaces. The resulting changes line up with manually annotated phone boundaries. 

So the intended representational picture is:

[
\text{one frame}
================

\text{phonology of current phone}
+
\text{phonology of neighbouring phones},
]

with each phone-position combination represented in its own approximately orthogonal coordinate system.

---

## Models, data, and baseline representations

They analyse the LARGE versions of three English-trained S3Ms:

* wav2vec 2.0 (`facebook/wav2vec2-large-lv60`)
* HuBERT (`facebook/hubert-large-ll60k`)
* WavLM (`microsoft/wavlm-large`)

All have a convolutional feature encoder followed by a Transformer context network. MFCC and log-mel representations serve as non-contextual spectral baselines.

The datasets are **TIMIT**, manually segmented English speech, and **VoxAngeles**, manually segmented speech from 95 non-English languages. The latter is particularly useful because the tested S3Ms were trained on English, so it tests whether the proposed structure extends to phonetic inventories outside the models' training language. 

Their principal diagnostic is **phonological vector arithmetic**, with analogies automatically generated from PanPhon features. For example, if the relevant representation geometry is linear, a relationship such as

[
[b]-[d]+[t]\approx[p]
]

should hold.

An analogy counts as successful when the cosine similarity between the target and arithmetic approximation falls between a different-phone lower baseline and a same-phone upper baseline. They estimate similarities using 1,000 samples with replacement and construct 99% confidence intervals from 10 independent repetitions.

Phones occurring fewer than 50 times are excluded for these analogy experiments, leaving 43 TIMIT phones and 57 VoxAngeles phones, producing respectively **236 and 468 valid phonological quadruplets**. 

---

# 1. Is phonological structure present in a single frame?

The first experiment establishes that the earlier phonological-vector results are not an artefact of averaging representations across an entire phone.

They compare:

* **mean pooling**: average all S3M frames corresponding to the phone;
* **center pooling**: take only the single frame at the temporal centre of the phone.

Surprisingly, center-frame representations perform at least as well as mean-pooled representations and frequently perform better. The effect appears for both TIMIT and VoxAngeles and across the S3Ms, although the layerwise behaviour varies considerably by model.

This supports the claim that phonological compositionality genuinely exists at the **individual Transformer frame level**: it is not necessary to average several frames to reveal something resembling a stable phone representation.

Spectral MFCC/log-mel representations do not show the same strong behaviour. 

---

# 2. Does that single frame encode neighbouring phones?

The key experiment then changes what the analogy is *about*.

Suppose the local phone sequence is

[
[p^{-2},p^{-1},p^0,p^{+1},p^{+2}]
]

and the representation examined is a single center frame belonging to (p^0).

Instead of asking only whether that frame supports an analogy concerning (p^0), they ask whether its representation supports analogies concerning each of the five relative positions.

In other words, can a frame sitting inside one phone encode distinctions such as:

* “the **previous** phone is voiced”;
* “the **current** phone is voiced”;
* “the **next** phone is voiced”?

It can, particularly in later S3M layers.

The strongest analogy success occurs for (p^0), as expected, but useful phonological information also appears for (p^{-1}) and (p^{+1}). Positions (p^{-2}) and (p^{+2}) generally show little success by this metric.

This is therefore not just a conventional receptive-field result showing that the Transformer has access to neighbouring audio. The claim is that the information about neighbouring segments occurs in a representation sufficiently regular to support **the same kind of phonological vector arithmetic** used for the current segment. 

### Effective context

They examine this more finely by randomly selecting individual frames at normalized positions through each phone from (p^{-2}) to (p^{+2}).

**WavLM gives the clearest result:** a broad trapezoidal context profile. Information about the target phone is strong inside that phone, weaker in the immediately adjacent phones, and approaches zero farther away. HuBERT behaves similarly on TIMIT but less clearly on VoxAngeles; wav2vec 2.0 shows substantially weaker contextual effects.

MFCC and mel features behave as expected for acoustic-local representations: their useful information is essentially restricted to the target phone.

Thus contextualization is strongest in WavLM, then less consistently apparent in HuBERT and wav2vec 2.0. 

---

# 3. Position-dependent phonological subspaces

The central problem is now obvious.

Suppose a frame encodes:

* current phone = voiced;
* previous phone = voiced.

If both are represented by simply adding the same vector (v_{\text{voice}}), the representation cannot say *which phone* is voiced.

The authors therefore hypothesize separate positional versions:

[
v^{-1}*{\text{voice}},\qquad
v^0*{\text{voice}},\qquad
v^{+1}_{\text{voice}}.
]

They construct such vectors through differences of class means. For example,

[
v^0_{\text{voice}}
==================

## E[r\mid p^0\text{ voiced}]

E[r\mid p^0\text{ unvoiced}]
]

where (r) is still the center-frame representation of (p^0).

For the previous-phone version,

[
v^{-1}_{\text{voice}}
=====================

## E[r\mid p^{-1}\text{ voiced}]

E[r\mid p^{-1}\text{ unvoiced}].
]

Notice something important: **both vectors are extracted from representations at the same temporal location**. The grouping criterion changes according to which surrounding phone possesses the feature.

They do this for eight features:

* vowel: high, low, back, round;
* consonant: nasal, sonorant, strident, voice.

The main analysis uses final-layer WavLM. 

## Within each positional space

The expected phonological geometry is preserved. For instance:

* high and low vectors are strongly negatively correlated;
* nasal, sonorant and voice are positively related;
* strident shows negative relationships with several sonorant-type features;
* vowel and consonant vectors are approximately orthogonal.

This structure is similar in TIMIT and VoxAngeles.

More importantly, a broadly similar pattern appears independently for (p^{-2}, p^{-1}, p^0, p^{+1}, p^{+2}).

## Between positional spaces

Vectors belonging to different relative positions have much smaller cosine similarities.

Thus

[
\cos(v^0_{\text{voice}},v^{-1}_{\text{voice}})
]

is much lower than similarities among phonological vectors derived for the same relative position.

The paper calls this **positional orthogonality**: roughly the same phonological system appears to be replicated in largely separate representational directions for each neighbouring phone position. 

The effect also appears across layers and across all three models when comparing average absolute cosine similarity for same-position versus different-position vector pairs.

One qualification is important: the paper does **not** estimate complete linear subspaces and measure their principal angles. “Orthogonal subspaces” is inferred from the relatively low cosine similarities between sets of difference-of-means phonological vectors. The empirical result is therefore more directly “position-indexed phonological directions are approximately orthogonal” than a proof that the full representational spaces are mathematically orthogonal.

---

## Information appears to decay with distance

There is an interesting discrepancy between the two diagnostics.

The direct analogy test finds little evidence at ±2 phones. Yet the difference-of-means method still recovers recognizable position-dependent phonological structure at ±2.

The authors argue that the analogy success metric is therefore relatively insensitive: contextual information from several sources is superposed within a frame and individual-vector arithmetic becomes noisy.

Supporting this interpretation, the **L2 norms** of position-dependent phonological vectors decline approximately as

[
0 > |\pm1| > |\pm2|.
]

So representations apparently contain weaker traces of progressively more distant phones rather than abruptly cutting off after the immediate neighbours.

---

# 4. The positional representation follows phone boundaries

The paper's next claim is stronger than “the Transformer has an effective temporal window.”

If (p^{-1},p^0,p^{+1}) really refer to *phones*, then the model must in some sense track where phones begin and end. Otherwise the positional encoding could merely correspond to something like ±100 or ±200 ms.

They therefore examine **11 consecutive S3M frames around manually annotated TIMIT phone boundaries**: five before the boundary, the boundary frame, and five afterwards.

They select boundaries where a particular phonological feature changes. For instance,

[
[-\text{voice}] \rightarrow [+ \text{voice}].
]

Before the boundary, a vector meaning approximately **“the next phone is voiced”** should provide evidence for the upcoming voiced phone. After crossing the boundary, that same segment is now current, so **“the current phone is voiced”** should dominate.

That is approximately what happens.

Across the eight tested features, the cosine curves representing neighbouring and current positional vectors cross **around the manually annotated TIMIT boundary**. The reverse transition occurs at segment offsets: information formerly encoded as current becomes information about the preceding phone. 

The visualisation on page 7 makes the intended result especially clear. Across an entire TIMIT sentence, cosine similarities to the (-2,-1,0,+1,+2) feature vectors form a **staircase-like pattern**, with abrupt transitions repeatedly lining up with phone boundaries. 

The authors therefore argue that the relevant contextual representation is more like:

> previous segment / current segment / following segment

than:

> 100 ms ago / now / 100 ms later.

A necessary qualification is that this is not itself an unsupervised segmentation evaluation. Ground-truth TIMIT boundaries are used both to define the positions and to aggregate the analysis. What they show is that a representational signal changes in systematic alignment with those boundaries, which could potentially be exploited by a future unsupervised segmenter.

---

# 5. Connection to masked prediction

The paper also offers a possible reason why this structure emerges.

wav2vec-style S3Ms use context to predict masked input. Because speech is coarticulated, reconstructing a missing region benefits from knowing phonetic information on either side.

They test mask reconstruction by comparing representations produced from an intact signal with representations for the same region when it has been masked. The default mask length is **10 frames, approximately 205 ms**. Since Transformer spaces are anisotropic, they first perform ZCA whitening before computing cosine similarities.

For HuBERT and WavLM, similarity between the true and context-reconstructed representations steadily improves through the network. wav2vec 2.0 instead reaches its best reconstruction similarity in an intermediate layer and then deteriorates.

This qualitatively resembles the models' different layerwise phonological-context behaviour. The authors therefore suggest—not demonstrate causally—that masked-prediction training may encourage frames to store structured information about neighbouring phones because that information aids reconstruction. 

---

# Interpretation

The paper proposes a fairly concrete picture of Transformer contextualization in speech:

[
r_t \approx
\sum_{j=-k}^{k}
V_j,\phi(p^{j})
]

where (\phi(p^j)) is something like the phonological feature content of the phone at relative position (j), and (V_j) places that content into a **position-specific representational subspace**.

This accounts simultaneously for several observations:

1. A single S3M frame contains much more than its local acoustics.
2. It preserves phonological structure for the segment containing that frame.
3. It also contains weaker structured information about neighbouring segments.
4. The model can avoid confusing identical features belonging to different phones because relative positions are represented approximately orthogonally.
5. These positional assignments appear to change at phonetic boundaries rather than at fixed elapsed-time intervals.

The authors compare this informally with **context-dependent triphones** in traditional ASR: self-supervised models may effectively be rediscovering a richer continuous analogue of explicit left/current/right phonetic context. 

---

# Main implications and limits of the evidence

The result potentially gives a mechanistic explanation for several otherwise loosely connected properties of S3Ms: why learned discrete units resemble phonetic categories, why contextual S3M embeddings work well for phonetic tasks, why allophonic environment can be decoded, and why speech boundaries can emerge from otherwise unsupervised models.

The authors suggest applications to interpretable speech representations, unsupervised segmentation, structured discrete speech units, and architectures that explicitly disentangle context-independent from context-dependent information. They also speculate that phonetic position may be one example of a broader principle whereby S3Ms place different kinds of information—phonology, speaker identity, acoustics—into approximately separated linear subspaces. 

The evidence nevertheless supports a narrower claim than the title might initially suggest. The strongest analyses concentrate on **final-layer WavLM**, particularly the orthogonality and boundary experiments; contextual analogy results are considerably weaker for wav2vec 2.0 and partly dataset-dependent for HuBERT. The “subspaces” are diagnosed through a small set of eight PanPhon-derived difference vectors rather than by characterizing all dimensions of a true subspace. And the apparent segmentation is evaluated relative to existing manual phone segmentation rather than obtained independently.

Within those qualifications, the paper's main result is quite striking: **individual S3M frames appear to contain a structured representation of a short phonetic sequence, indexed by relative segment position, rather than merely a context-smoothed representation of the locally aligned phone.** 
