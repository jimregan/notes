---
toc: false
layout: post
hidden: true
description: Harnessing Whisper for Prosodic Stress Analysis
title: Generated paper summary
categories: [chatgpt, summary, whisper, prosody, stress]
---

Comparison of two related papers:

[Harnessing Whisper for Prosodic Stress Analysis](https://aclanthology.org/2025.findings-acl.1331/)

```bibtex
@inproceedings{sohn-etal-2025-harnessing,
    title = "Harnessing Whisper for Prosodic Stress Analysis",
    author = "Sohn, Samuel S.  and
      Knutsen, Sten  and
      Stromswold, Karin",
    editor = "Che, Wanxiang  and
      Nabende, Joyce  and
      Shutova, Ekaterina  and
      Pilehvar, Mohammad Taher",
    booktitle = "Findings of the Association for Computational Linguistics: ACL 2025",
    month = jul,
    year = "2025",
    address = "Vienna, Austria",
    publisher = "Association for Computational Linguistics",
    url = "https://aclanthology.org/2025.findings-acl.1331/",
    doi = "10.18653/v1/2025.findings-acl.1331",
    pages = "25931--25942",
    ISBN = "979-8-89176-256-5",
}
```
and [Fine-Tuning Whisper for Inclusive Prosodic Stress Analysis](https://arxiv.org/pdf/2503.02907)

## Joint summary

Both papers ask whether **Whisper large-v2 can be repurposed from ordinary transcription into an automatic annotator of prosodic stress**. Rather than adding a separate classifier to frozen speech representations, the authors fine-tune Whisper so that the transcription itself encodes the intended prosodic contrast—for example, `INsult` versus `inSULT`, or `BLACK cow` versus `black COW`. The work covers three kinds of English stress:

* **Phrasal stress:** compound versus adjective–noun constructions, such as *greenhouse* versus *green house*.
* **Lexical stress:** segmentally similar words distinguished by stress placement, such as noun–verb stress alternations.
* **Contrastive stress:** emphasis on one member of a phrase, such as *BLACK cow* versus *black COW*.

The central finding is that a large pretrained ASR model can learn these distinctions from a **small, speaker-annotated dataset**, generalize to unseen speakers, and outperform conventional classifiers built from manually selected acoustic features.  

### Data and training setup

The underlying recordings come from a controlled production experiment with native English-speaking university students from the mid-Atlantic United States. Participants produced 16 minimal-pair items for each stress type. Three trained human coders independently judged the stress patterns, providing a human-performance benchmark and, indirectly, evidence about ambiguous or incorrectly produced trials.

The workshop/arXiv paper describes the full sample of **66 speakers**:

* 18 neurotypical men
* 18 neurotypical women
* 12 autistic men
* 18 autistic women

Its stress-transfer experiments, however, are described as applying to the **neurotypical participants**, while the autism data are used primarily for the separate speaker-classification task. The later Findings paper concentrates on the **36 neurotypical speakers**, evenly divided between men and women, and abandons the neurotype-classification branch in favour of a substantially deeper analysis of stress recognition.  

Models were fine-tuned for five epochs and evaluated with five-fold cross-validation in which speakers, rather than individual recordings, were divided across folds. That is important: the reported results measure generalization to **unseen speakers**, not merely to unseen utterances from speakers already encountered during training.

### Transfer between stress types

The core experiment shared almost verbatim by both papers examines whether training on one type of stress helps Whisper recognize another.

A small **control model** is first trained on all three stress types from one participant. This teaches Whisper the unusual output conventions—especially capitalization indicating stress—without giving it enough data to learn robust stress patterns. Separate models are then trained on phrasal, lexical or contrastive stress, and each is tested on all three types. An additional model is trained jointly on all stress types.

The control model performs:

* **70.7%** on phrasal stress
* **39.5%** on lexical stress
* **49.7%** on contrastive stress

The relatively high phrasal result is partly an orthographic artefact: Whisper already distinguishes forms such as *greenhouse* and *green house* in ordinary text, whereas capitalization such as `INsult` and `inSULT` is an artificial annotation scheme.

Training and testing on the same stress type produces strong results:

* Phrasal → phrasal: **90.2%**
* Lexical → lexical: **86.6%**
* Contrastive → contrastive: **88.7%**

More interestingly, there is substantial **bidirectional transfer between lexical and contrastive stress**:

* Lexical training → contrastive testing: **77.5%**
* Contrastive training → lexical testing: **71.9%**

This suggests that the two distinctions share acoustic structure that Whisper can reuse—presumably some combination of relative pitch, amplitude and duration across the two constituents.

Phrasal stress behaves differently. Training on phrasal stress does little for lexical stress and actively hurts contrastive-stress performance; training on contrastive stress likewise hurts phrasal performance. The authors interpret this as evidence that phrasal and contrastive stress involve at least partially conflicting patterns when learned separately. Phrasal stress in this dataset depends particularly heavily on duration and inter-word pausing, whereas lexical and contrastive stress rely more strongly on redistributing prominence between constituents.

Joint training avoids much of this interference. The all-stress model reaches **90.2%, 86.6% and 88.7%**, respectively—close to the human coders’ **91.9%, 88.8% and 91.6%**, and above Random Forest baselines of **86.4%, 83.9% and 83.7%**.  

## What the arXiv/workshop paper adds

The four-page arXiv paper frames the work around **inclusivity and speech diversity**. Alongside the stress-transfer experiment, it asks whether Whisper can classify a speaker from a single phrasal-stress recording into:

* neurotypical man
* neurotypical woman
* autistic man
* autistic woman
* unknown or ambiguous

The recordings average only about **1.7 seconds**. The model is deliberately conservative: it assigns many cases to the unknown class, producing only **55.4% overall known-class recall**, but reportedly near-perfect precision when it does make a known-class prediction. Recall is particularly poor for autistic men, the smallest group in the dataset.

The paper treats this as evidence that short prosodic samples contain information associated with gender and diagnostic grouping, and argues that such adaptation might support more inclusive ASR. 

That claim needs some caution. The experiment establishes separability **within this small, demographically narrow dataset**, not a general or clinically meaningful ability to identify autism. Because all data come from one experimental population and one elicitation protocol, the classifier might exploit speaker, recording, task or cohort correlates rather than stable neurotype-specific prosody. The “near-perfect precision” formulation is also achieved partly by abstaining on a very large proportion of examples.

## What the Findings paper adds

The later Findings paper retains the same transfer experiment and essentially the same numerical results, but changes the research emphasis. It removes the autism/gender category classifier and develops the prosodic-analysis side in three major directions.

### 1. Amount and location of acoustic context

The authors test Whisper with progressively different portions of each recording:

* first syllable or word alone
* second syllable or word alone
* the complete stress-bearing region
* preceding context plus the region
* following context plus the region
* the entire sentence

The **second constituent is consistently more informative than the first**, especially for contrastive stress. For example, using only the second constituent gives roughly a ten-point improvement over the first for contrastive stress.

Full or extended context generally improves performance. With the entire sentence, Whisper reaches:

* **92.6%** for phrasal stress
* **92.8%** for contrastive stress

These are approximately human-level overall and, in some gender-specific conditions, slightly above the average coder benchmark. Lexical items were produced in isolation, so corresponding sentence-context experiments were unavailable.

The result means that stress is not represented solely by the locally “stressed” word or syllable. Whisper benefits from broader relative information—baseline pitch, amplitude, rhythm, phrase-final effects or the acoustic shape of the surrounding utterance.

### 2. Gender-conditioned performance

The Findings paper gives much more attention to differences between male and female speakers. It relates Whisper’s results to the earlier acoustic study from which the recordings were taken, where pitch, amplitude and duration had different relative importance by gender and stress type.

The simple Random Forest models generally classified men’s productions more accurately, apparently because the measured cues were less variable. Whisper narrows or reverses some of those differences, particularly when broader context is available. The paper therefore argues that Whisper learns richer, partly gender-specific patterns rather than merely reproducing a single fixed rule such as “higher pitch means stress.”

The evidence supports **different model behaviour across the two speaker groups**, although “gender-specific stress patterns” is somewhat stronger language than the experimental design strictly warrants: the study compares two relatively small groups labelled men and women, without establishing which physiological, social or stylistic factors cause the differences.

### 3. Black-box acoustic perturbation analysis

The most substantial new contribution is a method for probing Whisper’s decision boundary without accessing or interpreting its internal representations.

The authors take recordings from the “stress-first” class and systematically modify:

* mean pitch of each constituent
* amplitude of each constituent
* pause duration between them

Perturbation sizes are based on empirical differences between the stress-first and stress-final recordings. They then observe where Whisper’s classification changes.

The resulting response surfaces broadly agree with the conventional acoustic analysis:

* **Phrasal stress** is especially sensitive to pause duration.
* **Lexical stress** is strongly affected by changes in relative pitch and amplitude.
* **Contrastive stress** is also sensitive to pitch redistribution, particularly changes involving the second constituent.
* Men’s and women’s response surfaces differ, indicating that the model is not applying exactly the same acoustic boundary to both groups.

This is presented as a general black-box interpretability technique: instead of asking which hidden units encode stress, it asks which controlled transformations of an utterance cause the model to cross from one prosodic interpretation to another. 

## Combined interpretation

Taken together, the papers demonstrate three things.

First, **Whisper retains usable prosodic information despite being pretrained mainly to collapse acoustic variation into ordinary orthographic transcription**. Fine-tuning can make distinctions that were previously irrelevant to its output become explicit.

Second, prosodic stress is not a single transferable category. **Lexical and contrastive stress share substantial learnable structure, while phrasal stress is more distinct**, particularly because duration and boundary cues play a larger role.

Third, the model’s advantage over a handcrafted Random Forest is not simply greater classifier capacity. Whisper can exploit **longer acoustic context, interactions among cues and speaker-group-dependent distributions** that are difficult to express through three summary measures.

## Relationship between the two papers

Your impression is correct, but the relationship is slightly more like a **fork followed by expansion** than a straightforward long and short version:

* The **shared core**—dataset design, capitalization scheme, control condition, cross-stress transfer matrix, human benchmark and Random Forest comparison—is effectively the same study.
* The **arXiv/workshop paper** packages that core together with the gender/neurotype classification experiment and frames the contribution as inclusive ASR.
* The **Findings paper** discards that classification experiment, narrows the participant set to the 36 neurotypical speakers, and turns the shared stress experiment into a fuller paper through context ablations, gender-separated analysis, cleaned-data evaluation and acoustic perturbation experiments.

So the Findings paper is best understood as a much more developed version of the **prosodic-stress half** of the workshop paper, not as an expanded version of every claim made there.

---

# 1. Outline of the Findings paper

## Abstract

The paper presents four connected claims:

1. Whisper large-v2 can be fine-tuned on a small annotated dataset to distinguish phrasal, lexical and contrastive stress.
2. Its performance approaches or sometimes exceeds trained human annotation and surpasses Random Forest classifiers based on hand-engineered acoustic features.
3. Learned patterns transfer unevenly between stress types.
4. Acoustic-context ablation and controlled signal perturbation can reveal what information the model uses.

These become the paper’s three principal experimental strands: **acoustic context**, **cross-stress transfer**, and **decision-boundary characterization**. 

---

## 1. Introduction

### Motivation

* Prosody affects syntactic interpretation, sentence processing, production and pragmatic meaning.
* Manual prosodic annotation is slow and difficult to scale.
* An automated annotation method would permit larger studies of interactions between prosody and other linguistic structures.

### Model-level problem

* Whisper has encountered enormous acoustic variation during pretraining.
* Ordinary ASR training nevertheless encourages it to map prosodically different realizations to the same text.
* Fine-tuning can potentially recover those latent distinctions by assigning different textual outputs to different stress patterns.

### Contributions announced

* Fine-tune Whisper to recognize three stress types.
* compare performance with human coders and existing acoustic-feature classifiers;
* study whether information learned for one stress type transfers to another;
* determine how much local and sentential acoustic context the model uses;
* characterize its acoustic decision boundaries through controlled perturbations;
* examine results separately for men and women.

The introduction therefore establishes a much broader objective than the workshop paper: not merely showing that the classifier works, but using it as a tool for **prosodic analysis**.

---

## 2. Preliminaries

### 2.1 Pre-training

This subsection describes why Whisper is a plausible starting point:

* Transformer encoder–decoder architecture;
* large-scale weakly supervised pretraining;
* exposure to different speakers, accents, rates, environments and prosodic realizations;
* an existing many-to-one mapping from acoustic realizations to conventional text.

The central argument is that Whisper may already represent prosodic variation even though its standard transcription objective does not expose it.

### 2.2 Fine-tuning

#### Participants

* 36 native English-speaking college students;
* 18 men and 18 women;
* mid-Atlantic United States;
* speaker-balanced cross-validation.

#### Tasks

Three types of stress are elicited:

* **Phrasal:** compound versus adjective–noun pairs, such as *greenhouse* versus *green house*.
* **Lexical:** stress alternations such as `INsult` versus `inSULT`.
* **Contrastive:** stress on the first or second constituent, such as `BLACK cow` versus `black COW`.

#### Output encoding

* Lexical and contrastive stress are encoded through capitalization.
* Phrasal distinctions use conventional orthographic differences, such as spacing.
* The two categories are consistently ordered as **stress-first** and **stress-final**.

#### Training and evaluation

* Whisper large-v2;
* five epochs;
* default fine-tuning hyperparameters;
* five-fold cross-validation;
* participant-disjoint folds;
* gender-balanced folds;
* five model instances contributing to each reported average.

The speaker-disjoint design is justified as a test of generalization across talker-specific prosodic distributions. 

---

## 3. Related Work

Rather than presenting a broad survey of computational prosody, this section mainly establishes the **specific experimental baseline** supplied by Knutsen and Stromswold’s earlier analysis of the same recordings.

### 3.1 Stress Patterns

The authors summarize the earlier study’s conclusions about acoustic realization.

#### Phrasal stress

* Dominated by duration and inter-morpheme pausing.
* Smaller gender differences in the relative importance of pitch and amplitude.

#### Lexical stress

* Amplitude and duration are important for both groups.
* Pitch contributes more clearly for women in the earlier analyses.

#### Contrastive stress

* Pitch, amplitude and duration all contribute.
* The earlier regression analysis found a stronger pitch contribution for women.

This material establishes hypotheses against which Whisper’s behaviour can later be interpreted.

### 3.2 Benchmarks

Two baselines are defined.

#### Random Forest classifiers

* Built from differences in mean F0, amplitude and duration.
* Reported separately by stress type and gender.
* Generally classify men’s productions more accurately than women’s.

#### Human coders

* Three trained native-English-speaking annotators;
* blind to the intended target;
* manually mark constituent boundaries and perceived stress;
* treated as the paper’s “gold standard.”

The rest of the paper repeatedly compares Whisper against both baselines.

---

## 4. Extent of Acoustic Context

This is the first major experiment added in the Findings paper.

### Research question

Does the model recognize stress solely from the local stress-bearing region, or does it use information elsewhere in the utterance?

### Motivation

The Random Forest baseline only uses relative measurements within the two syllables or morphemes of the minimal pair. Whisper can instead accept variable-length audio and potentially use:

* absolute properties of each constituent;
* preceding speech;
* following speech;
* the shape of the entire utterance.

### Input conditions

The model is evaluated with:

1. first syllable or morpheme alone;
2. second syllable or morpheme alone;
3. complete region of interest, with no outer context;
4. region plus preceding context;
5. region plus following context;
6. full utterance.

Lexical-stress items were produced in isolation, so only the first three conditions are available for lexical stress.

### Analyses

Results are reported:

* across all speakers;
* for men;
* for women;
* for all three stress types where applicable;
* against both human and Random Forest benchmarks.

### Main findings

* Both constituents independently contain useful information.
* The second constituent is consistently more informative than the first.
* The difference is especially large for contrastive stress.
* Using the full two-part region is substantially better than either constituent alone.
* Additional sentential context usually improves phrasal and contrastive classification.
* Following context is generally more beneficial than preceding context.
* Men’s phrasal stress is the notable exception: context does not improve the result.
* Full-context Whisper reaches or exceeds average human performance for phrasal and contrastive stress.
* Whisper improves more strongly over the Random Forest baseline for women in several conditions.

### Interpretation

The authors infer that:

* absolute measurements contain information that is lost when only inter-constituent differences are retained;
* broader utterance prosody contributes to the interpretation of local stress;
* preceding and following contexts make asymmetric contributions;
* Whisper is learning interactions not captured by the three manually selected relative features.

---

## 5. Transfer Between Stress Types

This is the shared experiment inherited from the workshop paper.

### Research question

Does fine-tuning on one stress type improve or impair recognition of another?

### Control condition

* Fine-tune on all three stress types from one control participant.
* This teaches the special output vocabulary and capitalization conventions.
* It is intended not to provide enough data to learn general stress distinctions.

### Single-stress models

Train separate models on:

* phrasal stress;
* lexical stress;
* contrastive stress.

Test every model on all three stress types, producing a complete training-type × testing-type matrix.

### Joint model

Train one model on all three stress types and test it separately on each.

### Main results

* Same-type training works well for all three stress types.
* Lexical and contrastive stress show strong bidirectional transfer.
* Phrasal stress transfers weakly to lexical stress.
* Phrasal and contrastive training interfere with each other when trained separately.
* Joint training preserves strong within-type performance without the same degree of conflict.
* The joint model is near human accuracy and above the Random Forest classifiers.

### Added cleaned-data analysis

The Findings version introduces an additional robustness analysis:

* remove recordings for which a majority of human coders perceived the opposite stress category;
* retrain the single-stress and joint models;
* report results on this less noisy subset;
* include category-wise precision and recall;
* show that same-type performance improves substantially;
* show more modest improvements in lexical–contrastive transfer.

The removed items number:

* 56 of 575 phrasal recordings;
* 65 of 575 lexical recordings;
* 73 of 573 contrastive recordings.

This turns disagreement with human coding into an explicit data-quality analysis rather than leaving it absorbed into aggregate accuracy. 

---

## 6. Characterizing Decision Boundaries

This is the second major new experiment.

### Problem

Random Forests provide feature-importance scores, whereas Whisper is difficult to interpret internally.

### Proposed solution

Treat the model as a black box and manipulate the acoustic signal itself.

### Basic method

1. Select recordings from the stress-first category.
2. Estimate how the acoustic distributions differ between stress-first and stress-final productions.
3. Modify stress-first recordings incrementally toward the stress-final distribution.
4. classify every modified recording;
5. measure how stress-first accuracy changes across the perturbation space;
6. interpret falling accuracy as movement toward a decision boundary.

The nominal boundary is where the model becomes equally likely to choose the two classes.

### Perturbed features

For the first and second constituents:

* mean pitch;
* mean amplitude;
* pause duration between constituents.

### Empirical calibration

Perturbation values are derived from the observed differences between the two natural categories:

* pitch as semitone differences;
* amplitude as proportional changes;
* pause as differences in seconds.

The authors:

* remove outliers using the 1.5-IQR rule;
* select the 10th, 30th, 50th, 70th and 90th percentiles;
* cap problematic pitch manipulations at a ±4-semitone grid;
* exclude lexical pause manipulation because lexical pauses are almost always zero;
* consider only positive pause extensions for computational simplicity.

### Evaluation

* Create two-dimensional grids combining first- and second-constituent perturbations.
* Repeat for pitch and amplitude.
* inspect selected pause-duration settings;
* plot stress-first accuracy as heatmaps;
* separate results for men and women;
* exclude modified samples that Whisper no longer recognizes as either target category from the accuracy calculation;
* report recognition rates separately in the appendix.

### Main findings

* Phrasal stress is especially sensitive to pause manipulation.
* Lexical stress is sensitive to coordinated pitch and amplitude redistribution.
* Contrastive stress shows similar sensitivity, particularly involving the second constituent.
* Reducing prominence on the first constituent while increasing it on the second moves predictions toward stress-final.
* The inverse manipulation can exaggerate stress-first classification beyond performance on the unmodified recordings.
* Men’s and women’s response surfaces differ.
* The resulting surfaces reveal interactions and continua that simple feature rankings do not show.

---

## 7. Discussion

The discussion is structured around the three experiments.

### Acoustic Context

* Stress classification depends on more than relative local features.
* The second constituent is consistently especially informative.
* Full and following context improve recognition.
* Contextual asymmetry is interpreted as evidence relating to anticipatory and retrospective planning.
* Whisper particularly improves classification of women’s speech relative to the Random Forest baseline.
* The authors present the system as a scalable alternative to manual coding.

### Stress Transfer

* Lexical and contrastive stress appear to share substantial acoustic structure.
* Phrasal stress is more distinct because it depends much more heavily on duration.
* Joint training allows the model to learn several stress types without simply applying one universal stress representation.
* Whisper retains its transcription framework, unlike a dedicated Random Forest classifier.

### Decision Boundaries

* The perturbation method partially closes the interpretability gap between Whisper and conventional classifiers.
* It confirms broad findings from the earlier acoustic analysis.
* It also reveals interactions between first- and second-constituent cues.
* The paper emphasizes a continuum between stress-first and stress-final rather than treating them as acoustically isolated categories.

---

## 8. Conclusion

The authors conclude that Whisper can:

* recognize several kinds of prosodic stress;
* reach near-human or above-average-human performance under some conditions;
* use variable-length acoustic context;
* transfer patterns between related stress types;
* outperform conventional classifiers;
* support black-box analysis through controlled perturbations.

They propose the approach as a basis for larger-scale and potentially cross-linguistic prosody research. Model weights are released for both the full and cleaned all-stress datasets. 

---

## 9. Limitations

The paper identifies three principal limitations.

### Limited lexical coverage

* Only 24 minimal pairs are used.
* Speaker-disjoint evaluation does not establish generalization to unseen lexical items.
* Every fold contains all item types.

### Fixed control participant

* The control participant is not varied.
* Fully varying that choice would require approximately 900 fine-tuned model instances.
* Consequently, the transfer matrix may partly depend on the selected participant.

### Perturbation limitations

* The same perturbation distributions are applied to men and women.
* Some transformations move recordings outside the distribution of natural speech.
* Pitch, amplitude and pause manipulation do not capture every acoustic distinction between the categories.
* More nuanced, potentially group-conditioned signal transformations are needed. 

---

## Appendix

The appendix supplies supporting material rather than a separate argument. It includes:

* additional perturbation heatmaps;
* recognition rates showing when manipulated audio ceased to be transcribed as either target category;
* results for additional pause conditions;
* fuller results from the less noisy dataset;
* precision and recall for both stress-first and stress-final categories.

The appendix is important because the main-text perturbation accuracy excludes unrecognized outputs; the appendix shows where the apparent classification surface is accompanied by degradation of the underlying signal.

---

# 2. How the shared experiment was expanded

The workshop paper already contained the **cross-stress transfer matrix**. The Findings paper did not primarily expand it by collecting a larger stress dataset or inventing a new model. Instead, it placed that experiment inside a more comprehensive chain of analysis:

> **Establish performance → isolate the available evidence → test transfer → clean ambiguous observations → manipulate hypothesized cues → compare the results with prior linguistic analysis.**

That sequence can be turned into the following instructions.

## A. Retain a clearly defined core experiment

Start with one compact result that can stand on its own.

1. Define several related classification phenomena.
2. encode each distinction in a model-compatible output representation;
3. train one model per phenomenon;
4. test every model on every phenomenon;
5. include a minimal-control model that learns the output convention without receiving enough data to learn the task generally;
6. train a joint model over all phenomena;
7. compare against human judgements and an interpretable conventional baseline.

The original transfer matrix remains the central organizing result. The later paper does not replace it; it gives it explanatory support.

---

## B. Expand the methodological account before adding experiments

The workshop paper compresses the setup into a short dataset section. The Findings paper turns this into separate preliminaries and related-work sections.

Follow this pattern:

1. Explain why the pretrained model could contain relevant information despite not being trained for the target annotation.
2. explain exactly how the target distinction is represented in its output;
3. describe participants, elicitation tasks and labels separately;
4. state whether cross-validation separates speakers, items or recordings;
5. explain why that split corresponds to the intended generalization claim;
6. reconstruct the strongest prior baseline on the same dataset;
7. summarize what that baseline says about the underlying phenomenon, not just its accuracy.

This allows every later experiment to answer a specific limitation of the prior method.

---

## C. Add an input-evidence ablation

The first new question should be:

> **What information is sufficient for the model to make the original distinction?**

For a temporally structured speech task:

1. Identify the smallest theoretically relevant region.
2. divide it into meaningful subregions;
3. evaluate each subregion independently;
4. evaluate the complete local region;
5. add preceding context;
6. add following context;
7. evaluate the complete utterance;
8. keep the trained model and evaluation split otherwise comparable;
9. report results for each phenomenon and relevant speaker group;
10. compare every condition against human and conventional-model baselines.

This converts “the model classifies the phenomenon” into a stronger empirical account of **where the usable evidence resides**.

The Findings paper’s specific sequence was:

* constituent 1;
* constituent 2;
* both constituents;
* front context plus both;
* both plus back context;
* full utterance.

A corresponding expansion in another study need not use exactly these units. The units should follow the structure of the target phenomenon.

---

## D. Test absolute information as well as relational information

The earlier Random Forest experiment used differences between the two constituents. The Findings paper tests the constituents separately and discovers that each has independent predictive value.

General instruction:

1. Do not assume that a contrast is encoded only through a difference score.
2. evaluate each component independently;
3. compare component-only performance with relative-feature performance;
4. test whether one component is consistently more diagnostic;
5. determine whether a baseline discards useful absolute information through normalization or subtraction.

This is a particularly useful expansion when the original method reduces a structured observation to a few relative summary statistics.

---

## E. Treat surrounding context as part of the phenomenon

When the target occurs inside a larger sequence:

1. do not automatically crop everything outside the labelled region;
2. construct nested or directional context conditions;
3. distinguish preceding from following context;
4. avoid treating “more context” as a single undifferentiated condition;
5. interpret asymmetry only after showing that the context windows differ in both position and amount;
6. state when a task cannot support the same comparison because the original recordings lack context.

The Findings paper properly leaves the lexical-context cells unavailable rather than manufacturing comparable conditions.

---

## F. Preserve subgroup analysis throughout

The workshop paper introduced gender and neurotype as a separate classification target. The Findings paper instead uses gender as a **stratification variable in the target task itself**.

The more defensible procedure is:

1. identify a grouping variable motivated by earlier evidence;
2. balance it in train/test partitions;
3. report both pooled and subgroup results;
4. compare the size of improvement over each baseline within each group;
5. inspect whether ablation and perturbation patterns differ, not merely aggregate accuracy;
6. avoid assuming that different performance proves a single causal explanation.

In other words, ask:

> Does the proposed method work equally well across groups, and does it use the same evidence?

rather than:

> Can the speech recording be used to classify the speaker’s group?

This is one of the most important changes in emphasis between the papers.

---

## G. Add a label-quality or ambiguity analysis

The original experiment uses intended labels even where participants may have produced the opposite contrast. The Findings paper adds a cleaned subset based on human perception.

Follow this procedure:

1. distinguish **experimental target** from **perceived realization**;
2. identify cases where independent annotators agree that the realized category contradicts the intended one;
3. retain the complete dataset as the principal evaluation unless there is a reason not to;
4. repeat the analysis on a clearly defined lower-noise subset;
5. report exactly how many observations are removed from each class or condition;
6. compare whether cleaning primarily affects:

   * within-task accuracy,
   * cross-task transfer,
   * class balance,
   * precision,
   * recall;
7. interpret improved performance as sensitivity to label noise, not automatically as evidence that the cleaned result is the only valid result.

This is especially relevant to any corpus created from prompts, canonical forms or intended productions: an instruction label is not necessarily an acoustic ground truth.

---

## H. Go beyond aggregate accuracy

The workshop paper largely reports accuracy. The Findings expansion adds precision and recall for each side of the contrast in the cleaned-data analysis.

A fuller study should report:

1. accuracy with variability across folds;
2. per-category precision and recall;
3. confusion direction;
4. subgroup results;
5. human agreement or human performance;
6. conventional baseline performance;
7. significance relative to the appropriate control;
8. sample or recognition attrition caused by preprocessing or perturbation.

This guards against an apparently strong result being driven by one category, one group or model abstention.

---

## I. Build an interpretability experiment from prior domain knowledge

The paper does not begin with arbitrary perturbations. It uses the acoustic variables already identified by the earlier phonetic analysis.

The reusable procedure is:

1. identify features supported by prior domain analysis;
2. measure their natural distributions in each target class;
3. calculate class-to-class shifts;
4. remove extreme observations according to a declared rule;
5. choose representative shift magnitudes from the empirical distribution;
6. modify examples from one class incrementally toward the other;
7. apply changes separately to structurally meaningful components;
8. combine component-wise changes into a grid;
9. run the unchanged classifier on every modified example;
10. visualize the resulting response surface.

This makes the perturbation experiment a test of a concrete hypothesis:

> Does moving the signal along a naturally observed acoustic dimension move the model toward the opposing interpretation?

---

## J. Manipulate components jointly, not only one feature at a time

Stress depends on the relationship between two constituents. The paper therefore varies the first and second components independently along two axes.

For an analogous study:

1. identify components whose relationship defines the distinction;
2. perturb component A and component B independently;
3. evaluate their Cartesian product;
4. include the unmodified condition in the grid;
5. inspect interactions rather than just marginal feature effects;
6. test both movement toward the opposite category and exaggeration of the original category.

A one-dimensional feature sweep would not show, for example, that lowering the first constituent and raising the second jointly produces a much stronger change than either manipulation alone.

---

## K. Ground perturbation ranges in observed data

Do not choose transformation strengths merely because they produce a visually clear result.

Use the paper’s logic:

1. estimate the empirical shift between categories;
2. derive perturbation levels from distributional percentiles;
3. document any clipping imposed to prevent artefacts;
4. distinguish empirically derived values from manually substituted values;
5. justify omitted dimensions;
6. acknowledge when computational simplification makes the tested transformation asymmetric.

The paper departs from its empirical values where large pitch shifts create artefacts and explicitly substitutes a bounded grid. That exception belongs in the method, not hidden in implementation details.

---

## L. Measure whether the perturbation remains valid

The Findings paper does something important but imperfect: when Whisper no longer recognizes a modified signal as either target string, it excludes that example from classification accuracy and separately reports recognition percentages.

The better general instruction is:

1. define a validity criterion for every manipulated sample;
2. report both:

   * conditional classification among valid samples;
   * the proportion of samples remaining valid;
3. never present conditional classification alone;
4. inspect whether apparent decision-boundary effects coincide with signal degradation;
5. provide examples or diagnostics for out-of-distribution transformations;
6. treat lost validity as a limitation of the perturbation method.

In a stronger replication, one might report a three-way outcome:

* original category;
* opposing category;
* invalid or unrecognized.

That would make the boundary surface harder to overinterpret.

---

## M. Triangulate model behaviour with the earlier interpretable baseline

After obtaining ablations and perturbation surfaces:

1. compare them with the feature rankings from the conventional model;
2. identify agreements;
3. identify additional interactions visible only in the larger model;
4. distinguish confirmation from genuinely new evidence;
5. avoid claiming that similar model sensitivity establishes the causal basis of human production.

The Findings paper’s central triangulation is:

* the acoustic baseline says phrasal stress is dominated by duration;
* the perturbation experiment finds phrasal classification strongly sensitive to pausing;
* the baseline says lexical and contrastive stress use pitch and amplitude;
* the corresponding model boundaries respond to redistribution of those cues.

---

## N. Organize the resulting full paper as an explanatory progression

A direct template derived from the Findings paper would be:

1. **Introduction**

   * task significance;
   * limitation of manual analysis;
   * reason the pretrained model may help;
   * full contribution list.

2. **Model and data preliminaries**

   * pretraining relevance;
   * annotation encoding;
   * corpus and split design.

3. **Prior analysis and benchmarks**

   * established domain findings;
   * conventional model;
   * human benchmark.

4. **Evidence-location experiment**

   * component ablations;
   * local versus full context;
   * subgroup analysis.

5. **Cross-phenomenon transfer**

   * control;
   * single-task matrix;
   * joint training;
   * cleaned-label replication.

6. **Model-behaviour experiment**

   * empirically grounded perturbations;
   * multidimensional response surfaces;
   * validity or recognition diagnostics.

7. **Integrated discussion**

   * context;
   * transfer;
   * interpretability;
   * agreement with domain knowledge.

8. **Conclusion**

9. **Limitations**

   * item generalization;
   * control sensitivity;
   * perturbation validity.

10. **Appendix**

    * full class metrics;
    * secondary perturbation conditions;
    * attrition/recognition plots;
    * cleaned-data results.

---

## The expansion in one sentence

The Findings paper takes a result that originally said **“fine-tuning transfers between some stress types”** and surrounds it with experiments answering:

> **What part of the recording supports the decision, does it work similarly across speaker groups, how much does annotation noise matter, which natural acoustic changes move the model between categories, and where do those manipulations cease to produce valid speech inputs?**

That is the most reusable set of instructions from the relationship between the two papers.
