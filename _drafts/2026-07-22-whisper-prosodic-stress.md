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
