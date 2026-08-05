---
toc: true
layout: post
hidden: true
description: ChatGPT paper summary
title: Self-supervised Speech Models Discover Phonological Vector Arithmetic
categories: [summary, chatgpt]
---

[\[b\]=\[d\]-\[t\]+\[p\]: Self-supervised Speech Models Discover Phonological Vector Arithmetic](https://aclanthology.org/2026.findings-acl.537/),
[arXiv](https://arxiv.org/abs/2602.18899),
[code](https://github.com/juice500ml/phonetic-arithmetic)

```bibtex
@inproceedings{choi-etal-2026-b,
    title = "[b] = [d] - [t] + [p]: Self-supervised Speech Models Discover Phonological Vector Arithmetic",
    author = "Choi, Kwanghee  and
      Yeo, Eunjung  and
      Cho, Cheol Jun  and
      Harwath, David  and
      Mortensen, David R.",
    editor = "Liakata, Maria  and
      Moreira, Viviane P.  and
      Zhang, Jiajun  and
      Jurgens, David",
    booktitle = "Findings of the {A}ssociation for {C}omputational {L}inguistics: {ACL} 2026",
    month = jul,
    year = "2026",
    address = "San Diego, California, United States",
    publisher = "Association for Computational Linguistics",
    url = "https://aclanthology.org/2026.findings-acl.537/",
    doi = "10.18653/v1/2026.findings-acl.537",
    pages = "11048--11069",
    ISBN = "979-8-89176-395-1",
}
```


The paper’s central claim is stronger than merely “S3M embeddings contain phonetic information.” It argues that phonological contrasts correspond to approximately **linear directions** in representation space, that these directions are **compositional**, and that moving different distances along them produces graded, acoustically interpretable changes. The headline example is:

[
r_{[b]} \simeq r_{[p]} + (r_{[d]}-r_{[t]})
]

so (r_{[d]}-r_{[t]}) behaves as a voicing direction which can be applied to a bilabial stop. The second experiment turns this descriptive claim into an intervention: add (\lambda v) to selected WavLM frames, invert the modified representation with a vocoder, and see whether acoustic properties vary systematically with (\lambda). 

## 1. Data and representations

They use **TIMIT** for English and **VoxAngeles** for cross-linguistic evaluation. VoxAngeles contains 95 non-English languages from 21 families, so the paper describes the overall study as covering 96 languages. TIMIT diphthongs are excluded, and its separately labelled stop closures/releases are merged to make segments closer to IPA phone units. VoxAngeles is already manually phonetically segmented. 

For the main representation experiments they compare three English-trained LARGE S3Ms: **wav2vec 2.0, HuBERT, and WavLM**. Each is treated as 7 convolutional feature-encoder layers followed by 24 Transformer blocks, roughly 300M parameters. They extract 25 representations: layer 0 is the CNN output and layers 1–24 are the Transformer outputs. The effective S3M stride is 320 samples at 16 kHz, i.e. about 20 ms/frame. Spectral baselines are librosa-default MFCCs and log-mel spectrograms. 

The **main phone representation is feature-sliced, not audio-sliced**. They first run the complete utterance through the model,

[
R=f(x),
]

convert a phone interval ((t_s,t_e)) to representation indices

[
t'_s=\lfloor t_s/s\rfloor,\qquad t'_e=\lceil t_e/s\rceil,
]

then mean-pool

[
r=\operatorname{avgpool}(R[t'_s:t'_e]).
]

That distinction matters: the vector for a phone is therefore computed from hidden states whose Transformer receptive field includes the surrounding utterance. An appendix compares this with cropping the waveform first and finds that feature slicing works much better for S3Ms. The authors explicitly interpret this as evidence that contextual information contributes to the phonological geometry. 

## 2. Experiment 1: testing vector arithmetic

Each phone is represented phonologically with **PanPhon’s 21 ternary features**, originally ({-1,0,+1}). For construction of the analogies, each ternary feature is expanded to two binary dimensions:

[
+\rightarrow[1,0],\quad 0\rightarrow[0,0],\quad -\rightarrow[0,1],
]

giving a 42-dimensional vector (h_p).

They then exhaustively search the available phone inventory for quadruplets

[
(p_1,p_2,p_3,p_4)
]

satisfying

[
h_{p_1}-h_{p_2}=h_{p_3}-h_{p_4}.
]

Thus the *phonological difference* between (p_1,p_2) must exactly equal that between (p_3,p_4). Importantly, these do **not** have to be minimal pairs: a relation may involve several feature changes simultaneously. The representation-space prediction is

[
r_{p_1}\simeq r_{p_2}+r_{p_3}-r_{p_4}.
]

Phones without PanPhon mappings or with fewer than **50 occurrences** are discarded. This reduces TIMIT from 47 to 43 usable phones and VoxAngeles from 567 to only 57. They obtain 236 TIMIT quadruplets and 468 VoxAngeles quadruplets. “Consonantal” and “constricted glottis” yield no usable quadruplets in either corpus, leaving **19 PanPhon features** represented in the analogy tests. 

### The actual success criterion

This is important when comparing with code: they do **not** principally evaluate whether arithmetic produces the nearest embedding of the target phone.

For a quadruplet they estimate

[
\cos(p)=E[\cos(r_{p_1},r_{p_2}+r_{p_3}-r_{p_4})].
]

Phone tokens are repeatedly sampled rather than replacing each phone with one global centroid. They compare this to:

[
\cos^+(p)=E[\cos(r_{p_1},r'_{p_1})]
]

for two instances of the same phone, and

[
\cos^-(p)=E[\cos(r_{p_1},r_{\text{other phone}})].
]

The desired ordering is

[
\cos^- < \cos_{\text{analogy}} < \cos^+.
]

They bootstrap by sampling **1000 phone instances with replacement**, calculate an averaged cosine, and use **10 bootstrap replicates to obtain 99% confidence intervals**. Operationally, they require separation of the CIs, not merely the point-estimate ordering: the upper CI of the lower quantity must lie below the lower CI of the higher one. “Success rate” is the proportion of quadruplets satisfying that criterion. 

So if the implementation simply computes phone centroids, performs (b-a+c), and asks whether the correct phone is nearest, it is implementing a materially different experiment.

## 3. Experiment 1 results

On **TIMIT**, peak success rates are approximately:

| Representation | Best success rate |
| -------------- | ----------------: |
| HuBERT         |  94%, final layer |
| WavLM          |  92%, final layer |
| wav2vec 2.0    | 61%, middle layer |
| MFCC           |               19% |
| log-mel        |                0% |

On **VoxAngeles**, WavLM is much stronger than the other S3Ms: WavLM 93%, HuBERT 45%, wav2vec 2.0 39%, MFCC 19%, log-mel 0%. Of the 468 VoxAngeles analogies, **316 (68%) contain at least one phone absent from TIMIT**, despite all three principal S3Ms having been trained on English. 

WavLM shows three broad regions of success across its depth. Vowels tend to give an earlier intermediate peak; consonants peak later; both become very strong at the final layer. The authors interpret this in terms of temporal context: many vowel cues are relatively local whereas consonantal properties can be distributed through release, neighbouring formant transitions, aspiration, devoicing, etc. Audio slicing, which removes most of that context, substantially weakens the S3M effect. 

There is an important robustness qualification in the appendix. Their secondary **offset-based** analysis uses Fournier et al.’s *pairing consistency score* rather than the item arithmetic above. Phone pairs are grouped by identical PanPhon differences; genuine relation offsets are contrasted against offsets produced by shuffling the second phone, and ROC AUC is reported. This broadly confirms that S3Ms outperform spectral features, but its layerwise behaviour differs: intermediate layers often look best rather than WavLM’s enormous final-layer peak. They make the item test primary partly because the offset test leaves only 36 TIMIT and 112 VoxAngeles quadruplets. 

There are several further controls worth remembering. Audio-sliced MFCCs surprisingly reach roughly 67% on TIMIT and 50% on VoxAngeles, but their cosine space is extremely anisotropic, with similarities collapsing near 1; WavLM avoids this collapse. Fine-tuning XLSR-53 for phone recognition strengthens the analogy structure. Neither individual PanPhon feature nor the number of feature differences between phones explains the main layerwise pattern. 

## 4. Experiment 2: constructing explicit phonological steering vectors

The second experiment uses **final-layer WavLM**, not arbitrary analogy offsets.

For each feature (i), they estimate one global vector:

[
v_i =
E_{h_i=+1}[r]-
E_{h_i=-1}[r].
]

This is a crucial distinction from the paper title’s ([d]-[t]): the actual synthesis experiments normally use **difference-of-class-means vectors over many phone tokens**, rather than a single minimal pair.

They calculate vectors separately for vowels and consonants: vowel vectors come from vowel representations and consonantal vectors from consonants. Their later sample-efficiency experiment suggests a few hundred samples per side are sufficient: by (N=256), a subsampled vector is generally very close to the full-data vector. Conversely, extracting a vector from a single phone pair tends to have only about 0.5 cosine similarity to the full vector, despite potentially hundreds of tokens of each phone, because that pair also carries other correlated phonetic differences. 

They modify only frames belonging to the selected phone:

[
\tilde R_t =
\begin{cases}
R_t+\lambda v_i,&t'_s\leq t<t'_e\
R_t,&\text{otherwise}.
\end{cases}
]

The surrounding hidden states are left untouched.

For TIMIT, the feature vector is estimated from the **training split** and evaluation uses the test split. For VoxAngeles, which has no standard split, they use a **fixed randomly selected subset of languages to estimate the vector** and evaluate on the remaining languages. The paper does not identify those languages in the prose, so that is one thing that will have to come from the implementation. 

For each of the eight tested vectors they resynthesize **3000 examples**, randomly selecting a target segment with replacement and sampling

[
\lambda\sim U(-5,5).
]

Thus the experiment intentionally tests substantial extrapolation as well as the ([-1,1]) region one might regard as interpolation.

## 5. WavLM inversion

They train a **Vocos-based vocoder** to approximate (f^{-1}), i.e. waveform reconstruction directly from the WavLM representation.

There are two versions: an English vocoder trained on **LibriTTS, 585 h**, and a multilingual vocoder trained on **FLEURS-R, about 1.3k h across 102 languages**. They alter Vocos’s architecture dimensions to accept WavLM (and, in an ablation, MFCC) inputs, and state that they multiply both the original Vocos **batch size and learning rate by eight** for faster convergence. The paper does **not** state the resulting absolute LR, batch size, precise architecture dimensions, training duration, optimizer configuration, etc.; those will need to be recovered from the implementation rather than treated as specified by the paper. 

They also run an identity reconstruction control,

[
\tilde x=f^{-1}(f(x)),
]

with (\lambda=0), and show that the resulting changes in the acoustic measures are tightly centred around zero. This is meant to argue that the correlations below are not simply vocoder reconstruction artefacts.

## 6. Acoustic tests of vector scale

Eight features have acoustic proxies:

| PanPhon direction | Measurement                | Claimed expected (\lambda)-correlation |
| ----------------- | -------------------------- | -------------------------------------: |
| high              | F1                         |                                      − |
| low               | F1                         |                                      + |
| back              | F2                         |                                      − |
| round             | F2                         |                                      − |
| nasal             | F1 bandwidth               |                                      − |
| sonorant          | HNR                        |                                      + |
| strident          | spectral centre of gravity |                                      + |
| voice             | spectral centre of gravity |                                      − |

Measurements are implemented through **Parselmouth/Praat**. F1 represents height; F2 backness and rounding; F1 bandwidth nasality; HNR sonority; and spectral centre of gravity voicing and stridency. The analysis correlates (\lambda) with the change in the relevant acoustic measurement using **Spearman’s (\rho)**. 

There is one paper-internal detail I would specifically keep in mind when we inspect the code later. Appendix A.3 says nasalization produces **broader F1 bandwidth**, which naturally sounds like a positive relation with increasing +nasal vector, but Table 1 explicitly predicts a **negative** correlation and Figure 4 indeed reports negative correlations. The prose, table and vector definition are therefore not transparently consistent on the sign of the nasality measurement. I would check the implementation of both the F1BW measure and the definition of (\Delta) before interpreting it.

On TIMIT the reported Spearman correlations are strong and have the expected signs according to their Table 1. They report the effect separately for phones already possessing vs lacking the feature; representative pairs of (\rho) are high −.801/−.826, low +.908/+.836, back −.759/−.733, round −.833/−.853, nasal −.441/−.472, sonorant +.649/+.659, strident +.819/+.788, and voice −.720/−.794. 

The relationship need not itself be linear: the claim is that a *linear change in representation space* produces a **monotonic** change in the acoustic variable.

## 7. What the interventions actually sound/look like

The qualitative examples on pp. 7–8 are useful because they make clear that the vectors are not claimed merely to change a static spectrum.

Adding the rounding vector to English [i] lowers its formants, including F2/F3, creating cues toward a front rounded vowel even though English lacks that category. Increasing the voicing vector on [b] moves voicing onset progressively earlier, eventually extending voicing into the closure and producing negative VOT. Increasing stridency on [b] introduces high-frequency frication and simultaneously removes the stop burst. Increasing nasality weakens/removes the burst and adds a low-frequency nasal murmur. These are temporally organised alterations rather than just spectral offsets. 

The effects remain interpretable even for (|\lambda|>1), although some directions saturate. The paper mentions already-sonorant segments, voiced consonants, and non-stridents as cases where extrapolation eventually ceases to give much additional change.

The multilingual experiment repeats the procedure with held-out VoxAngeles languages and the FLEURS-R vocoder and gets very similar monotonic trends. A rounding case study also finds that the steering vector mirrors **dataset-specific** acoustic manifestations: in TIMIT rounding differs most conspicuously in F2/F3, whereas in VoxAngeles F1/F2 carry more of the contrast, and the intervention reproduces that pattern. 

## 8. What I would regard as the implementation contract

When we compare the repository with the paper, the high-value things to check are: PanPhon ternary-to-42D conversion and exact quadruplet enumeration; the ≥50-token filter and phone normalisation; full-utterance feature slicing with floor/ceil boundary conversion; token-level random sampling rather than only phone centroids in Experiment 1; 1000 samples × 10 replicates and the 99% CI separation rule; whether “236/468 quadruplets” means the same permutation/deduplication logic as in the code; all 25 model layers; the alternative PCS implementation; final-layer WavLM for synthesis; +feature mean minus −feature mean with vowel/consonant separation; the precise TIMIT and VoxAngeles vector/evaluation splits; 3000 samples per vector with (\lambda\sim U(-5,5)); modification of target frames only; Vocos input/training changes; and, especially, the exact acoustic-measurement and delta/sign conventions.

The main conceptual caveat is also useful for reading the code: **Experiment 1 and Experiment 2 do not construct “the phonological vector” in exactly the same way**. Experiment 1 establishes arithmetic using arbitrary matched phone quadruplets; Experiment 2 deliberately switches to a much more stable difference-of-class-means vector. The appendix shows that a single phone-pair vector is in fact a fairly poor estimate of that global vector.

Finally, the authors themselves limit the conclusion: they test only a few S3Ms, only PanPhon’s feature system, and only one vocoder family. They explicitly say the experiments cannot distinguish “the model has discovered a phonological natural-class feature” from “the model has captured a sufficiently consistent acoustic/phonetic difference.” The resynthesis results are also jointly properties of WavLM **and** the trained inverse model. 

---

[Comparison]({% post_url 2026-08-02-phonetic-arithmetic-codebase %}) with the [codebase](https://github.com/juice500ml/phonetic-arithmetic):

This is a good implementation-oriented summary, and it lines up closely enough with the paper that it should be useful as the second side of the comparison. A few details are worth correcting or sharpening before treating it as authoritative.

The clearest terminology issue is `pcs.py`: **PCS is “pairing consistency score,” not “Phonological Consistency Score.”** The paper takes this from Fournier et al. and defines it as separability between offsets from the same relation and mismatched offsets, evaluated by ROC AUC; random performance is 0.5.  The union-find detail is implementation-specific and perfectly useful in a code summary, but it is not part of the method description in the paper.

The `analyze_synth.py` description is also slightly broader than the published experiment. The paper’s eight principal acoustic tests use only **F1, F2, F1 bandwidth, HNR, and spectral centre of gravity**: height→F1, back/round→F2, nasal→F1BW, sonorant→HNR, voice/strident→COG.  If the script also computes zero-crossing rate and RMS, those are extra implementation facilities rather than measurements supporting the main claim. I would phrase that distinction explicitly. MFCC synthesis, however, genuinely is part of the paper: Appendix B.13 repeats the intervention experiment with feature- and audio-sliced MFCCs and finds that their vectors are mostly ineffective. 

The workflow diagram slightly obscures an important representation distinction. `extract_features.py` may produce “phone-level representations,” but the synthesis experiment requires the **unpooled frame sequence** (R), because the intervention is applied only to frames within the phone interval before decoding. By contrast, the analogy experiment consumes pooled phone vectors (r). So conceptually I would represent that fork as something like:

```text
extract_features.py
   |
   +--> pooled phone vectors --------> estimate_similarity.py / pcs.py
   |
   `--> framewise representations ---> analyze_synth.py
```

That distinction matters when checking whether the implementation really corresponds to equations (10) versus (16) in the paper.

There is also a potentially important point hidden by “uses PanPhon feature vectors to discover valid analogies.” The main analogy code ought to reproduce the paper’s rather specific construction: PanPhon’s 21 ternary features are expanded to **42 binary dimensions**, and quadruplets are accepted when

[
h_a-h_b=h_c-h_d.
]

That exact encoding is what makes `0` distinct from both `+` and `−`.  If the code instead compares ordinary 21-dimensional (-1,0,+1) difference vectors, that would not be strictly equivalent, so this is one of the first things I would inspect in `estimate_similarity.py`.

Likewise, “repeated Monte Carlo sampling and 99% confidence intervals” is correct but underspecified relative to the paper. The published procedure draws **1000 phone representations with replacement per estimate**, uses **10 replicates**, and tests the analogy by CI ordering:

[
\cos^- < \cos_{\text{analogy}} < \cos^+.
]

That is a sufficiently peculiar procedure that the implementation should be checked line-for-line against it rather than merely described as bootstrapping.

A few other codebase points correspond especially closely to appendix experiments rather than the main body. Both feature-vs-audio slicing and MFCC synthesis are explicit appendix studies; feature slicing is the primary S3M setup, whereas audio slicing removes neighbouring context and is mainly a control. The paper actually finds audio slicing *helps* MFCC substantially while hurting S3Ms.  Similarly, `pcs.py` corresponds to Appendix B.1 rather than the principal success-rate metric.

One thing your summary already makes much clearer than the paper is **where implementation assumptions live**. The paper says VoxAngeles has 95 languages and that a random subset of languages is used for synthesis-vector estimation versus evaluation, but it does not expose the exact language-selection machinery.  If the repository literally assumes exactly 95 languages, or reconstructs the split by integer indices/random seed, that is an implementation fact we will want to distinguish from the scientific method.

So I would retain this summary, with three edits:

* rename **Phonological Consistency Score → pairing consistency score**;
* distinguish the paper's five reported acoustic measurement types from extra diagnostics such as ZCR/RMS;
* distinguish **pooled phone embeddings** used by the analogy tests from **framewise representations** needed for steering/resynthesis.

The interesting next comparison is now quite concrete. I would read `estimate_similarity.py` first, because that is where there is the greatest scope for the prose description “implements the paper” to conceal consequential details: PanPhon encoding, quadruplet generation/deduplication, sampling, random-phone baseline, CI calculation, and success criterion. After that, `analyze_synth.py` is the other high-value file, particularly for the train/test language split, definition of (\Delta), and the suspicious nasality/F1BW sign issue from the paper.
