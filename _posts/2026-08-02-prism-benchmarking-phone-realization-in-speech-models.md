---
toc: true
layout: post
hidden: true
description: ChatGPT paper summary
title: PRiSM - Benchmarking Phone Realization in Speech Models
categories: [summary, chatgpt]
---

```bibtex
@inproceedings{
anonymous2026prism,
title={{PR}i{SM}: Benchmarking Phone Realization in Speech Models},
author={Anonymous},
booktitle={Submitted to ACL Rolling Review - January 2026},
year={2026},
url={https://openreview.net/forum?id=e599H1NP7T},
note={under review}
}
```

```bibtex
@misc{prism2026,
      title={PRiSM: Benchmarking Phone Realization in Speech Models}, 
      author={Shikhar Bharadwaj and Chin-Jou Li and Yoonjae Kim and Kwanghee Choi and Eunjung Yeo and Ryan Soh-Eun Shim and Hanyu Zhou and Brendon Boldt and Karen Rosero Jacome and Kalvin Chang and Darsh Agrawal and Keer Xu and Chao-Han Huck Yang and Jian Zhu and Shinji Watanabe and David R. Mortensen},
      year={2026},
      eprint={2601.14046},
      archivePrefix={arXiv},
      primaryClass={cs.CL},
      url={https://arxiv.org/abs/2601.14046}, 
}
```

# *PRiSM: Benchmarking Phone Realization in Speech Models*

Shikhar Bharadwaj, Chin-Jou Li, Yoonjae Kim, Kwanghee Choi, Eunjung Yeo, et al., 2026. 

## Central idea

The paper introduces **PRiSM — Phone Realization in Speech Models**, a benchmark for evaluating **language-agnostic phone recognition (PR)** systems.

Its starting argument is that conventional phone-recognition evaluation is too narrow. A model is normally judged by comparing its predicted phone sequence with a reference transcription, but this does not answer two distinct questions:

1. **How accurately does the system represent the phone realizations actually present in the signal?**
2. **How useful is the phonetic information learned by the model for tasks that depend on pronunciation?**

The distinction matters because a speech model exposes phonetic information through two quite different channels:

[
\text{speech}
\rightarrow
\begin{cases}
\text{explicit phone transcription}\
\text{latent speech representation}
\end{cases}
]

A discrete IPA transcription is interpretable but inevitably discards information. Hidden representations retain far more acoustic detail, but may also contain speaker, semantic, prosodic, and other information unrelated to phonetics.

PRiSM therefore evaluates systems in two ways:

* **intrinsic evaluation:** how good the generated phonetic transcription is;
* **extrinsic evaluation:** how useful either the transcription or internal representation is for downstream speech tasks.

The paper is consequently as much an argument about **how phone recognizers should be evaluated** as it is a leaderboard comparison. 

---

# 1. What counts as phone recognition?

The authors use *phone recognition* relatively literally: converting speech into units intended to describe **physical phonetic realization**, rather than recovering an underlying phonemic sequence.

For example, regional realizations of *tell* may receive different narrow phone transcriptions even though both correspond to the same phonemic form. This is why they regard PR as useful for cross-lingual phonetics, pronunciation analysis, clinical speech, and other situations where normalization to lexical or phonemic categories would remove the phenomena of interest. 

They use “PR system” broadly enough to include any speech-to-IPA pipeline, ranging from dedicated CTC phone recognizers through encoder-decoder systems to general-purpose **Large Audio Language Models (LALMs)** prompted to produce IPA.

This breadth is intentional: one objective of PRiSM is to make very different system families comparable.

---

# 2. Benchmark structure

PRiSM consists of **six intrinsic PR tests** and **nine downstream tasks**.

## Intrinsic: transcription quality

The six datasets are divided conceptually into two groups.

### Variation within a seen language

These test whether a model can represent pronunciation variation rather than simply normalize the input toward familiar language-specific patterns:

* **PR-tmt:** TIMIT — English;
* **PR-arc:** L2-ARCTIC Perceived — non-native English;
* **PR-saa:** Speech Accent Archive — accented/regional English.

### Unseen languages

These test cross-lingual phonetic generalization:

* **PR-drc:** DoReCo — 45 languages;
* **PR-vox:** VoxAngeles — 95 languages;
* **PR-tsm:** Tusom2021 — Tusom.

For closed LALMs, the authors correctly qualify “unseen”: their complete training data is unknown, so genuine absence from training cannot be verified. 

---

# 3. Phonetic Feature Error Rate rather than PER

The principal intrinsic metric is **Phonetic Feature Error Rate (PFER)** rather than ordinary Phone Error Rate.

PER treats phones categorically:

[
[p]\neq[b]\neq[m],
]

so every substitution has essentially the same unit cost.

PFER instead maps IPA segments to articulatory/phonological features and computes edit distance in that feature representation. Informally, confusing phones that differ by one feature is therefore less serious than predicting something articulatorily quite different.

The corpus-level metric is

[
\mathrm{PFER}
=============

\frac{
\sum_i
D(\operatorname{feat}(u_i^*),
\operatorname{feat}(u_i))
}{
\sum_i |u_i^*|
}.
]

Here (u_i^*) is the reference sequence, (u_i) the predicted sequence, and (D) is feature-level edit distance.

The rationale is particularly appropriate for a benchmark of **phone realization**: a model that predicts an almost-correct segment should not necessarily be treated identically to one that predicts a completely unrelated articulation. 

Lower PFER is better.

---

# 4. Extrinsic evaluation: transcription versus representation

The downstream portion is the most distinctive part of PRiSM.

For most downstream tasks they evaluate each model in two separate ways.

### Transcript Probe (TP)

The PR model first generates a phone transcription. That phone sequence is fed to a lightweight **bidirectional GRU** trained for the downstream task:

[
x
\rightarrow
\text{PR}
\rightarrow
\text{IPA sequence}
\rightarrow
\text{BiGRU}
\rightarrow
y.
]

This asks:

> How useful is the *explicit phonetic transcription* produced by this recognizer?

### Representation Probe (RP)

Instead of decoding phones, the probe consumes the PR model's hidden representations. They use the **final hidden layer**, temporal attention pooling, and an MLP:

[
x
\rightarrow
\text{PR encoder}
\rightarrow
H
\rightarrow
\text{attention pooling}
\rightarrow
\text{MLP}
\rightarrow
y.
]

This asks:

> How useful is the information retained internally by the speech model?

They explicitly caution against interpreting TP and RP scores as interchangeable. The inputs contain different amounts and kinds of information, so meaningful comparisons are primarily **TP-to-TP and RP-to-RP**. They additionally test learned combinations of layers and report that the general RP trends remain. 

---

# 5. Downstream tasks

The nine tasks fall into three groups.

## Pathological speech

* **DYS-ez:** dysarthria intelligibility prediction, EasyCall, Italian;
* **DYS-ua:** dysarthria intelligibility prediction, UASpeech, English;
* **CSD-us:** child speech-disorder detection, UltraSuite.

Metrics are rank correlation for intelligibility and F1 for disorder classification.

## L2 speech

* **L1-eda:** infer a speaker's L1 from English speech, EdAcc;
* **L1-arc:** L1/accent classification from ARCTIC/L2-ARCTIC;
* **L2-so:** pronunciation assessment, Speechocean762.

These test whether the recognizer captures pronunciation differences made by non-native speakers.

## Multilingual/dialectal speech

* **LID-fl:** language identification, FLEURS-24;
* **GEO-v:** geolocation of Hindi dialect speech, Vaani;
* **PI-drc:** infer the phone inventory of an unseen language, DoReCo.

These are deliberately heterogeneous. The benchmark is testing not merely whether one particular classifier can exploit phones, but whether the phone recognizer provides useful information across substantially different forms of phonetic variation. 

---

# 6. Systems compared

The model comparison is structured so that architecture, pretraining and multilingual coverage vary.

## Wav2Vec2-based phone recognizers

Three models are based on wav2vec-style SSL encoders and CTC:

* **W2V2P-LV60**
* **W2V2P-XLSR53**
* **MultiIPA**

The important contrast is language exposure. MultiIPA uses multilingual XLSR pretraining but is phone-recognition-fine-tuned on only seven languages; the other systems have considerably broader PR training.

## ZIPA

* **ZIPA-CTC**
* **ZIPA-CTC-NS**

These are Zipformer encoder systems trained from scratch with consistency-regularized CTC on IPAPack++. The basic training set covers **88 languages**.

ZIPA-CTC-NS receives a further large pseudo-labelled stage covering around **4,000 languages**.

## POWSM

* **POWSM**
* **POWSM-CTC**

POWSM uses an E-Branchformer encoder plus Transformer decoder and hybrid CTC/attention training. POWSM-CTC is an encoder/CTC variant constructed by the authors.

This provides a relatively controlled test of **autoregressive decoder dependencies versus CTC-style output**.

## Large Audio Language Models

* **Gemini 2.5 Flash**
* **Qwen3-Omni-Instruct**

These are evaluated principally through prompting because suitable aligned internal representations are either unavailable or difficult to extract.

## Representation baselines

They also evaluate representations from:

* **WavLM-base**
* **Whisper-small**

even though these are not being used as PR transcription systems in that comparison. 

---

# 7. Intrinsic phone-recognition results

There is no single system that dominates every dataset, but several broad patterns emerge.

For pronunciation variation within English, the best averages are around **10–11 PFER**:

| Model            | Seen-language variation avg. PFER |
| ---------------- | --------------------------------: |
| ZIPA-CTC         |                              10.6 |
| ZIPA-CTC-NS      |                              10.6 |
| W2V2P-XLSR53     |                              10.8 |
| POWSM-CTC        |                              11.1 |
| W2V2P-LV60       |                              11.2 |
| Gemini 2.5 Flash |                              13.7 |
| MultiIPA         |                              15.2 |
| POWSM            |                              17.5 |

The authors interpret the MultiIPA result as particularly informative. Its encoder received multilingual pretraining that included English, but English was not part of its phone-recognition fine-tuning. It performs noticeably worse than systems explicitly exposed to English PR data.

So **multilingual SSL pretraining alone does not guarantee good phonetic transcription of a language**.

POWSM also fails badly on Speech Accent Archive, with 27.6 PFER; the authors attribute this largely to decoder search problems on long speech sequences. Intriguingly, they note that a text-only G2P model reaches 10.2 PFER there—better than Gemini—even though a G2P system can only supply canonical pronunciation rather than actually perceive the speaker's realization. 

---

## Unseen-language results

The rankings change:

| Model        | Unseen-language avg. PFER |
| ------------ | ------------------------: |
| POWSM        |                  **18.7** |
| ZIPA-CTC-NS  |                      19.0 |
| W2V2P-LV60   |                      19.5 |
| ZIPA-CTC     |                      19.6 |
| W2V2P-XLSR53 |                      21.0 |
| MultiIPA     |                      21.3 |
| POWSM-CTC    |                      21.9 |
| Gemini       |                      53.8 |
| Qwen3-Omni   |                     105.4 |

POWSM's advantage here is interesting because the encoder-decoder model was relatively poor on within-English variation. The authors argue that a degree of learned phone-sequence/phonological modelling can be **helpful when generalizing to unfamiliar languages**, even though the same reliance on likely sequences can hurt faithful realization transcription.

The headline conclusion is therefore not simply “CTC is better”:

* when speech belongs to a known language, **acoustic faithfulness and appropriate supervised language exposure** matter strongly;
* for a new language, **broad multilingual exposure and learned cross-linguistic phonological structure** can help.

The LALMs perform much worse on the unseen-language tests, although the very high averages partly arise from occasional catastrophic generations—long repetitions or insertions—which PFER penalizes heavily. 

---

# 8. Extrinsic results: the best transcript is not necessarily the best representation

This is arguably the paper's most important empirical result.

**Intrinsic PFER does not produce a stable ranking that predicts downstream usefulness.**

The transcript probes and representation probes also rank systems quite differently.

For transcript probing, ZIPA systems and W2V2P-XLSR53 are generally strong. No system dominates all tasks. ZIPA-CTC-NS, for example, scores extremely strongly on child speech-disorder detection and multilingual language identification, while W2V2P-XLSR53 does well on several L2 and inventory tasks.

For representation probing, **Whisper-small is the strongest system overall**, with an aggregate score of 68.5, despite not being a specialized phonetic transcription model. Among the PR systems, ZIPA-CTC and ZIPA-CTC-NS are next at roughly 63. 

This provides strong evidence for the benchmark's motivation:

> The quality of a model's decoded IPA output and the richness of the phonetic information inside its encoder are genuinely different properties.

---

# 9. Different tasks prefer different information bottlenecks

The paper finds a systematic difference by application type.

### Pathological speech tends to favour representations

RP tends to perform very well here. The authors suggest that clinical speech tasks may depend on properties such as:

* timbre,
* prosody,
* fine acoustic realization,

which are discarded when continuous speech is reduced to an IPA sequence.

### Multilingual/dialect tasks often favour transcription

Here, TP becomes relatively competitive or superior because language identity and dialect can be strongly encoded in:

* phone inventories,
* phone frequencies,
* phonotactics,
* phone-sequence distributions.

A discrete phone sequence may therefore function as a productive **structured bottleneck**, suppressing nuisance acoustic variation while preserving the linguistically useful differences.

### L2 tasks occupy an intermediate position

Both explicit realization and richer acoustic information can matter.

This task-dependent TP/RP behaviour is one of the main reasons the authors argue against reducing phonetic model evaluation to a single transcription score. 

---

# 10. Analysis 1: is a phone recognizer listening to the acoustics or completing likely phonotactics?

The paper then directly investigates a fundamental problem with PR.

A phone recognizer can output plausible phone sequences for two quite different reasons:

[
\text{actual acoustic evidence}
]

or

[
\text{learned probability of phone sequences}.
]

For genuine phonetic analysis, the former is normally what is wanted. A recognizer that “corrects” an unusual realization to the expected pronunciation may score well as ASR-like technology but fail as a measurement instrument.

## Phone-masking experiment

Using TIMIT's aligned phone intervals, they replace an increasing percentage of phones in the waveform with **silence**.

They remove those same phones from the reference transcription and ask the recognizer to transcribe what remains.

If predictions depended solely on actual audible phones, increasing the masking rate should make little difference: the missing phones are no longer in either signal or reference.

Instead, several systems increasingly hallucinate phones as more context disappears.

Figure 2 on page 6 shows a striking architectural split. **Wav2Vec2Ph and POWSM-CTC degrade relatively slowly**, whereas **POWSM and ZIPA degrade sharply** at high masking levels. 

---

## Why this is not simply “CTC versus decoder”

POWSM's behaviour is intuitive: its autoregressive decoder conditions each prediction on previous predictions, so it has a direct mechanism for using phonotactics and for propagating errors.

POWSM-CTC lacks that dependency and remains substantially more acoustically grounded.

But ZIPA is also encoder-only and nevertheless deteriorates strongly.

The authors trace this to its **consistency-regularized CTC (CR-CTC)** training. CR-CTC explicitly encourages similar representations under noisy input. That is useful for robust recognition, but for fine phonetic measurement it can encourage the system to reconstruct expected phones despite missing acoustic evidence.

Insertion rates show the same trend: POWSM and ZIPA can output phones where the corresponding audio has literally been removed. 

This gives an important qualification to the paper's broader praise of encoder-CTC systems:

> architecture alone does not guarantee acoustic fidelity; the training objective matters as well.

---

# 11. The robustness–fidelity trade-off

This masking experiment leads to a broader interpretation of the benchmark results.

Some of the models that use learned phonological regularities most heavily do well on **unseen languages**, because a model can infer plausible segment structure from incomplete or unfamiliar acoustic evidence.

But that same tendency can hurt tasks where the objective is to preserve **atypical realization**, such as accented or pathological speech.

So “robustness” and “phonetic faithfulness” can actually conflict:

[
\text{normalize / infer likely pronunciation}
\quad\leftrightarrow\quad
\text{transcribe what was physically produced}.
]

That is an important conceptual point in PRiSM: the model that performs best as a general recognizer need not be the model one would trust most as a **phonetic instrument**.

---

# 12. Analysis 2: zero-shot phone-inventory induction

The DoReCo inventory task asks a particularly concrete linguistic question:

> Given recordings from a previously unseen language, can a PR system recover the language's set of phones?

Each recognizer transcribes the DoReCo speech. The system's inventory is formed by taking the union of predicted phones and is compared with the reference inventory.

Most systems have the same basic pattern:

* **high recall**, often above 70%;
* **poor precision**, generally below 50%.

In other words, they recover many genuinely present phones but hallucinate many additional ones.

**POWSM-CTC has the best precision/recall balance**. ZIPA-CTC-NS is more precise than ZIPA-CTC, suggesting that the additional large multilingual pseudo-labelled training improves generalization to new inventories. 

The authors draw an especially interesting data conclusion.

The Wav2Vec2 phone recognizers were trained on roughly **160,000 hours**, compared with only about **17,000 hours** for IPAPack++, but ZIPA's supervised data covers substantially more languages—88 rather than roughly 40.

ZIPA has better inventory recall.

They therefore argue that for universal PR,

[
\boxed{\text{language diversity can matter as much as raw hours}}
]

and that multilingual coverage needs to occur not merely during SSL pretraining but also during **supervised phone-recognition training**. 

---

# 13. Analysis 3: phone transcripts can encode surprisingly fine dialect geography

For Hindi dialect geolocation, transcript probes outperform representation probes substantially.

The paper reports approximately:

* **146 km mean error from transcription probes**;
* **253 km from representation probes**.

This is initially surprising because the transcription discards prosody and other continuous speech properties commonly associated with regional accent.

The authors argue that the phone sequence nevertheless preserves strong regional information through:

* realization differences;
* morphology;
* phone frequencies;
* sequence distributions.

There is also an architectural caveat: the TP is an RNN and therefore explicitly models sequential order, whereas the RP collapses time with attention pooling before an MLP. Some of TP's advantage may therefore result from the downstream probe itself rather than from transcription being intrinsically superior.

They illustrate the effect with Bangru/Haryanvi **consonant doubling**. In an example utterance, W2V2P-LV60 transcribes doubled [ll] and [kk], and integrated-gradient attribution shows that the geolocation classifier makes use of those phones. 

This provides a concrete example of what PRiSM means by *downstream utility*: a phone recognizer may expose regional structure even when its transcription is imperfect globally.

---

# 14. Analysis 4: LALMs are poor fine-grained phonetic listeners

Gemini 2.5 Flash and Qwen3-Omni perform considerably worse than specialist systems overall.

The authors look closely at two zero-shot sociophonetic tasks.

## Hindi dialect geolocation

Qwen predicts **New Delhi for almost everything**.

Gemini reaches only 6.5% hit@1, with around 65% of its outputs concentrated in only a few coordinate clusters near New Delhi.

The paper describes this as **geographic mode collapse**: the models favour a high-resource geographic prior rather than reliably discriminate the input speech.

## L1/accent classification

The LALMs similarly overpredict a **Romance-language accent cluster**. Significant numbers of Slavic/Balkan and South Asian speakers are classified as Romance.

For Gemini, enabling reasoning/thinking makes performance *worse*, dropping F1 from 32.7 to 24.9. The reasoning traces frequently mention cues such as “Spanish/Italian/Portuguese” and “syllable-timed rhythm,” suggesting that the model constructs plausible verbal explanations around coarse stereotypes without actually resolving the relevant fine acoustic contrasts. 

The authors therefore conclude that contemporary LALMs' general speech-language competence should not be mistaken for **reliable fine-grained phonetic perception**.

Few-shot examples improve some pathological-speech tasks but do not provide a consistent general fix. 

---

# 15. What the benchmark ultimately finds

The paper's empirical conclusions can be reduced to four main points.

### 1. Transcription accuracy and phonetic usefulness are not equivalent

Systems move substantially in ranking between intrinsic PFER, transcript probes, and representation probes.

A meaningful evaluation of a PR system therefore needs both intrinsic and downstream tests.

### 2. Multilingual diversity matters throughout training

Broad multilingual SSL helps, but it is insufficient by itself. Broad **supervised PR exposure** substantially improves cross-lingual generalization, and diversity of languages can be more valuable than sheer audio quantity.

### 3. Encoder-CTC systems tend to provide stable phone recognition

They generally resist some kinds of sequence-model normalization and perform reliably across conditions. But stability also depends on the loss: ZIPA's consistency regularization demonstrates that an encoder-only architecture can still infer or hallucinate acoustically unsupported phones.

### 4. General-purpose LALMs do not replace specialized phone recognizers

Gemini and Qwen can produce IPA, but their intrinsic performance and fine sociophonetic discrimination remain markedly weaker, particularly cross-linguistically.

Whisper presents an interesting contrast: although not used here as a specialist phone decoder, its **internal representations** are exceptionally strong for the downstream probes.

---

# 16. What PRiSM actually measures

The benchmark is useful partly because it refuses to equate several quantities that are often conflated:

[
\boxed{
\text{phone transcription accuracy}
\neq
\text{acoustic faithfulness}
\neq
\text{phonetic information in embeddings}
\neq
\text{downstream usefulness}
}
]

For example:

* a system can achieve a plausible transcription by exploiting phonotactics rather than the signal;
* a transcription can be imperfect while the encoder still contains excellent phonetic information;
* a broad phone transcription can work extremely well for one downstream problem despite having thrown away fine acoustic detail;
* a rich embedding can be worse for a task if the probe cannot exploit its structure;
* modelling “likely” phones can improve unseen-language recognition while simultaneously destroying precisely the atypical pronunciations that a phonetician might want to study.

That distinction is the conceptual core of the paper.

---

# Limitations

The authors emphasize several important restrictions.

First, **phonetic transcription itself is not objective ground truth**. It depends on the annotator, transcription conventions, inventory and desired level of detail. An IPA representation can also erase gradient or language-specific phenomena.

Second, the datasets necessarily provide incomplete coverage of languages, dialects, accents and speaking styles.

Third, both probe types introduce confounds. Transcript probes may exploit spurious sequence properties such as length, particularly when recognition quality is poor. Representation probing depends on choices such as layer selection and temporal pooling; the authors show that learned layer aggregation preserves the broad findings, but it remains a modelling choice.

Finally, they deliberately use mostly default decoding configurations and simple prompts rather than tuning each system for every benchmark task. The paper therefore claims a **standardized comparative evaluation**, not the maximum attainable score for every individual model. 

## Bottom line

PRiSM's central contribution is not a new phone recognizer but a framework for asking a more demanding question of one:

> **Does this system actually preserve and expose the phonetic realization in the speech signal, and is that information useful once we leave the transcription benchmark?**

Its experiments show that those questions cannot be answered from PER/PFER alone. Language coverage, architecture, loss, decoding, phonotactic modelling and the distinction between decoded phones and hidden representations all materially change what a “good phone recognizer” means.
