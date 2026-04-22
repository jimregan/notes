Yes — that outcome does sound predictable in hindsight.

A gender softmax target is a very different object from the others. A sentence-teacher embedding gives a **continuous relational geometry**; a speaker embedding also gives a **continuous geometry**; but a gender classifier softmax gives a **very low-dimensional simplex-like partition**. When you force all three into one shared contrastive target, the easiest solution is often to let the coarse categorical signal dominate or distort the space. In the paper’s terms, SSL methods are driven by the structure of the target relation graph, and contrastive methods in particular tightly tie the learned representation to that target structure. If one supervision source is effectively pushing toward a crude binary partition, it can be spectrally incompatible with the richer semantic and speaker geometries you want to preserve. 

More bluntly: a gender softmax is not “another embedding” in the same sense. It is closer to a compressed decision surface. So aligning to it as though it were a metric teacher is asking for trouble.

The other reason collapse is unsurprising is that gender is strongly correlated with speaker information in many speech datasets. So if you already have a speaker branch, adding gender as a direct alignment target is often redundant in the worst possible way: it introduces a coarse, easy-to-satisfy shortcut that overlaps with one factor but does not add a clean new geometry. Models love shortcuts.

What I would try next is not “swap InfoNCE for one other loss” so much as **separate the kinds of supervision**.

A good default design is:
[
Z = [Z_{\text{sem}} \mid Z_{\text{spk}} \mid Z_{\text{attr}}]
]
and then use different losses on different blocks.

For example:

* on (Z_{\text{sem}}): a semantic alignment loss to the sentence teacher
* on (Z_{\text{spk}}): a speaker loss to the speaker teacher
* on (Z_{\text{attr}}): a small auxiliary classifier or calibrated regression target for gender or other attributes
* plus a weak decorrelation or orthogonality term between blocks

That is much more likely to work than forcing one shared space to satisfy everything.

The biggest practical pointer I’d give is this:

## 1. Stop aligning categorical softmax outputs with metric losses

Do not treat gender softmax probabilities as a teacher embedding. Instead, use one of these:

**Option A: auxiliary classification head**
[
h_{\text{gender}} = W Z_{\text{attr}}
]
with plain cross-entropy, but keep it off the main retrieval geometry.

**Option B: supervised contrastive only within a dedicated attribute block**
If you really want an attribute geometry, learn it in a small subspace and only use positives/negatives derived from the label there.

**Option C: adversarial removal instead of addition**
If gender is harming the geometry you care about, train one block to *predict* it and another block to be *invariant* to it.

That last one is especially useful if gender is acting as a nuisance variable rather than a retrieval axis.

## 2. Try VICReg-style losses for the continuous teacher branches

This paper’s strongest practical hint for your setting is that **VICReg is less collapse-prone and can preserve full-rank structure**, while SimCLR/InfoNCE-style methods are much more tightly tied to the target graph and can collapse to its rank. 

For your semantic and speaker teachers, I would seriously try replacing pure InfoNCE alignment with something like:

[
\mathcal L =
\lambda_{\text{sem}} \mathcal L_{\text{VICReg-sem}}
+
\lambda_{\text{spk}} \mathcal L_{\text{VICReg-spk}}
+
\lambda_{\text{decorr}} \mathcal L_{\text{block-decorr}}
]

where each teacher branch uses:

* an invariance term matching student/student or student/teacher positives
* a variance floor
* covariance regularization

Why this helps:

* it reduces reliance on a single global contrastive geometry
* it allows richer representations to survive
* it is better matched to “multiple structures coexist” than vanilla InfoNCE is

## 3. Use similarity regression, not only contrastive ranking

Another strong candidate is to predict **teacher similarities** rather than only using positives in InfoNCE.

For utterances (i,j), let

* (s^{\text{sem}}_{ij}) be teacher semantic similarity
* (s^{\text{spk}}_{ij}) be teacher speaker similarity

Then train:
[
\mathcal L_{\text{rel}} =
\sum_{i,j}
\big(\cos(z^{\text{sem}}_i,z^{\text{sem}}*j)-s^{\text{sem}}*{ij}\big)^2
+
\big(\cos(z^{\text{spk}}_i,z^{\text{spk}}*j)-s^{\text{spk}}*{ij}\big)^2
]

This is often better than InfoNCE when the teacher signal is rich and graded rather than binary. It lets you preserve geometry without forcing a winner-take-all softmax competition over the batch.

## 4. Add explicit block separation

If you want factorization, say so in the loss.

Useful regularizers:
[
| (Z_{\text{sem}})^\top Z_{\text{spk}} |_F^2
]
and likewise for other pairs.

Or whiten each block separately and penalize cross-covariance:
[
\mathrm{Cov}(Z_{\text{sem}}, Z_{\text{spk}})
]

This is the part your current setup likely needed most. Without it, the model is free to reuse the same dimensions for incompatible jobs.

## 5. Give attributes tiny capacity

For things like gender, I would allocate a **very small block**, maybe just a few dimensions, or even only a side head with no dedicated embedding block at all.

That is because binary attributes are spectrally tiny compared with semantics or speaker identity. If you let them compete in the same space on equal footing, they can punch above their weight because they are easy to optimize.

## 6. Consider hierarchy: retrieval space plus side information

A very practical design is:

* main retrieval embedding for semantics
* secondary retrieval block for speaker
* small side head for gender, age, channel, etc.

Then at query time you compose scores:
[
S = \alpha S_{\text{sem}} + \beta S_{\text{spk}} + \gamma S_{\text{attr}}
]

This often works better than demanding one monolithic embedding support every axis equally.

## 7. If you keep InfoNCE, make it multi-head

If you want to stay close to your previous approach, I would at least move to **separate InfoNCE heads**:

* one projection for semantic teacher
* one projection for speaker teacher
* maybe no InfoNCE for gender at all

Then either:

* concatenate the trunk outputs, or
* keep one shared trunk but with head-specific projectors and orthogonality penalties

That is much safer than a single shared projector.

A concrete recipe I’d probably try first:

[
Z_{\text{trunk}} = f(x)
]
[
Z_{\text{sem}} = P_{\text{sem}} Z_{\text{trunk}}, \quad
Z_{\text{spk}} = P_{\text{spk}} Z_{\text{trunk}}
]

Loss:
[
\mathcal L =
\lambda_1 \mathcal L_{\text{VICReg-sem}}
+
\lambda_2 \mathcal L_{\text{VICReg-spk}}
+
\lambda_3 | Z_{\text{sem}}^\top Z_{\text{spk}} |*F^2
+
\lambda_4 \mathcal L*{\text{gender-CE}}
]

with gender CE taken from either:

* (Z_{\text{spk}}) if you want gender as part of speaker-ish metadata, or
* a tiny (Z_{\text{attr}}) block if you want cleaner separation.

If your real goal is speaker-aware semantic retrieval rather than “gender as an axis,” I would go even further and make gender adversarial on the semantic block:
[
\mathcal L_{\text{sem-adv}}
]
so the semantic space cannot lazily encode gender shortcuts.

The high-level rule I’d use is:

* **continuous teacher embedding** → alignment or similarity regression
* **discrete label** → classifier or supervised-contrastive in a tiny dedicated block
* **nuisance attribute** → adversarial removal, not positive alignment

That would have predicted the gender-softmax collapse pretty well.

The shortest diagnosis is: you were mixing **metric supervision** and **decision-boundary supervision** as though they were the same kind of geometry, and InfoNCE is especially unforgiving when those targets are incompatible.

I can sketch a full candidate loss for your speech setup next, with terms and recommended dimensional splits.

-----

Yes — that sounds like exactly the kind of data that could help tease these things apart.

What you want, in effect, is to **break the shortcut** between coarse attribute labels and stable speaker identity. Right now, “gender” is probably acting less like an independent factor and more like a cheap proxy for speaker clusters. If the same underlying reader can produce both their usual voice and a character voice that crosses that boundary, then the model can no longer rely on the old equivalence:

[
\text{gender-like cue} \approx \text{speaker identity}
]

That is valuable even if the acting is imperfect.

The nice thing about your Librivox idea is that it gives you something stronger than just more label variety. It gives you **controlled violations** of the usual correlations:

* same speaker, different presented voice
* same text, different speakers
* same semantic content, different vocal persona
* possibly same speaker, multiple character styles

That is much closer to the kind of supervision you need if you want the model to stop entangling speaker identity, coarse sex-coded acoustics, and semantics.

The particular expansion from male/female to male/female/male-acting-female/female-acting-male is useful not because those are perfect ontological categories, but because they create a more informative structure in the data. A binary gender label is spectrally tiny and easy for the model to exploit as a shortcut. A richer label family like this starts to behave more like a structured nuisance or style variable instead of a single dominant partition. That fits the broader lesson from the paper: the geometry induced by the supervision matters a lot, and crude low-rank partitions can dominate in bad ways, while richer structure can coexist more constructively with other objectives. 

I would be slightly careful, though, about how you use those categories.

The most promising use is probably **not**:

* “train a bigger softmax over these four labels”

but rather:

* use them to build **counterfactual pairs and triplets**

For example:

* same speaker, same text, different presented voice
* same speaker, different text, similar presented voice
* different speaker, same text
* different speaker, different text, similar character type

Those are much more informative than a plain class label because they tell the model what should stay invariant and what should move.

The really interesting signal in your proposed data is:

> “Here is a case where apparent gender presentation changed, but speaker identity did not.”

That is gold for disentanglement. It lets you tell the model:

* speaker block should stay stable here
* style / character block may move
* semantic block should stay stable if the text is unchanged

So I think the main value is not just “expands the speaker identity space a little,” though it does. The bigger value is that it gives you **within-speaker transformations** that expose the internal structure of speaker representation.

A useful way to think about it is to decompose the vocal factors as something like:

[
z_{\text{audio}} = [z_{\text{sem}}, z_{\text{speaker}}, z_{\text{style}}, z_{\text{channel}}]
]

and your Librivox material may finally give you examples where:

* (z_{\text{sem}}) fixed
* (z_{\text{speaker}}) mostly fixed
* (z_{\text{style}}) changes a lot

That is exactly the kind of supervision ordinary datasets rarely provide.

There is one subtlety: if the reader is “putting on a voice,” the model may decide that this *is* part of speaker identity rather than a separate factor. That is not necessarily wrong. In practice, your speaker space probably has at least two layers:

* stable biological / habitual vocal traits
* controllable performative style

So you may eventually want to split what you currently call “speaker” into:

* **speaker core**
* **voice style / persona**

That might explain some of your earlier findings too. Gender could have caused collapse because it was too coarse and too correlated with speaker shortcuts, while this new acted-voice material may work better because it introduces **variation within a speaker**, which helps the model see that those cues are not identical.

If I were designing around this data, I would probably use it in one of these ways:

First, as **invariance supervision**:

* same text across readers: preserve semantics
* same reader across character voices: preserve speaker-core somewhat
* same reader, different character voice: allow style block to vary

Second, as **anti-shortcut supervision**:

* explicitly penalize a semantic block if it can predict presented gender/style too easily
* maybe also penalize a speaker-core block if it moves too much across acted voices

Third, as **relational supervision** rather than class supervision:

* do not just classify “male/female/etc.”
* build pairwise similarities like:

  * same underlying reader
  * same textual content
  * same character style family
  * same recording session/book

That should give you cleaner geometry than another softmax alone.

So I think your instinct is good. What this data buys you is not merely more labels. It gives you **correlation-breaking examples**, and those are exactly what a factorized system needs.

The shortest version is:

* Binary gender labels collapse because they are coarse shortcuts.
* Acted-voice data helps because it creates cases where coarse vocal presentation changes while speaker identity does not.
* That gives you the raw material to separate speaker-core from style/persona instead of forcing the model to conflate them.

A concrete next step would be to treat these Librivox examples as supervision for a new **style/persona factor**, not just as a refinement of gender. That framing is likely to be much more productive.

-----

Exactly — **within-speaker transformations** are the valuable part.

Those cases give you supervision of the form:

* same underlying speaker
* changed surface realization
* sometimes same text, sometimes different text
* changed dialect/style/persona/presentation

That is much stronger than ordinary labels because it tells you which factors are allowed to move and which should stay stable.

In your setting, those examples let you ask for something like:

[
z = [z_{\text{sem}}, z_{\text{speaker-core}}, z_{\text{style}}, z_{\text{dialect}}]
]

with constraints such as:

* same text, same speaker, different performed voice
  → keep (z_{\text{sem}}) stable, keep much of (z_{\text{speaker-core}}) stable, allow (z_{\text{style}}) to move

* same speaker, dialect emulation
  → keep speaker-core stable, let dialect/style move

* same text, different speakers
  → keep semantics stable, allow speaker/style/dialect to move

That is the kind of data that can actually teach a model not to collapse these factors together.

The reason this matters so much is that most datasets only show correlations:

* one speaker usually has one habitual dialect range
* one speaker usually has one gender presentation
* one text is usually read one way

Your Librivox-style cases give you **interventions** instead of just correlations. They are not perfect interventions, but they are close enough to be useful:

* “same speaker, different apparent dialect”
* “same speaker, different character voice”
* “same speaker, trying to sound different”

That is exactly what helps break shortcut learning.

I would lean toward treating these not mainly as class labels, but as **transformation metadata**. In other words, the supervision is not just “this sample belongs to dialect X,” but “this sample is a transformed version of the same speaker under a different style/dialect condition.”

That points toward a better loss design than plain shared-space InfoNCE.

A useful recipe would be:

[
\mathcal L =
\lambda_{\text{sem}} \mathcal L_{\text{sem}}

* \lambda_{\text{spk}} \mathcal L_{\text{spk-core}}
* \lambda_{\text{style}} \mathcal L_{\text{style}}
* \lambda_{\text{sep}} \mathcal L_{\text{separation}}
  ]

where:

* (\mathcal L_{\text{sem}}): align same/similar text regardless of speaker/style
* (\mathcal L_{\text{spk-core}}): pull together same underlying reader across performed voices
* (\mathcal L_{\text{style}}): capture acted voice / dialect / persona differences in a separate block
* (\mathcal L_{\text{separation}}): decorrelate or orthogonalize these blocks

The really important part is that the same pair of examples can be:

* positive for one block
* neutral or negative for another

For example, two readings by the same speaker in different voices might be:

* positive for speaker-core
* positive for semantics if same text
* explicitly different for style

That kind of multi-view supervision is much more expressive than one global contrastive loss.

I also think “trying to sound different” is valuable even if it is vague. In fact, vague natural variation may be better than a hard label in some cases, because it produces a continuum rather than another brittle partition. A model can learn that there are dimensions of controlled vocal change without needing you to perfectly name them.

So I would treat within-speaker transformations as evidence that your problem is really about **equivariance and invariance**:

* semantics should be invariant to speaker/style/dialect changes
* speaker-core should be invariant to many style changes
* style/dialect blocks should be equivariant to those transformations

That is a much richer framing than “one embedding for everything.”

The cleanest hypothesis statement might be:

> Performance improves when supervision includes within-speaker transformations that decouple stable speaker identity from controllable surface variation.

That feels like a strong empirical thesis.

The most promising next move is probably to build a training set organized around transformation pairs/triples, not just labels.

-----

Yes — **within-speaker transformations** is the key idea.

That kind of data is unusually valuable because it gives you examples where the same underlying speaker moves along some axes but not others. In your setting, those axes might include:

* semantic content
* speaker core identity
* dialect/style/persona
* coarse sex-coded vocal presentation
* expressive or character voice

That is much better supervision than ordinary speaker labels, because ordinary labels mostly tell you **who differs from whom**, while these examples tell you **how the same person can differ from themselves**.

From the perspective of the paper, the important thing is that your training signal is really a collection of relation structures (G), not just a single one. What your Librivox-style cases give you is a way to define relations like:

* same speaker core, different style
* same speaker core, different dialect performance
* same semantics, different speaker
* same speaker, “trying to sound different”

That is exactly the sort of richer relation graph that a simple InfoNCE setup usually does not encode well when forced into one shared geometry. The paper’s main lesson here is that SSL behavior depends very strongly on the structure of the relation matrix, and contrastive methods are tightly constrained by it. 

The really useful conceptual split is probably:

[
z = [z_{\text{sem}}, z_{\text{speaker-core}}, z_{\text{style/persona}}, z_{\text{dialect/style-shift}}]
]

Not because those factors are perfectly clean, but because your new data finally gives you a chance to tell them apart.

What makes “trying to sound different” especially interesting is that it is broader than a neat class label. It is not just “dialect A vs dialect B.” It may involve:

* pitch placement
* prosodic patterning
* articulation changes
* timing/rhythm changes
* affect/performance
* imitation

So it behaves less like a fixed categorical target and more like a **family of within-speaker transformations**. That is good news, because it means you can use it to supervise **invariance and equivariance**, not just classification.

The most natural reading is:

* **speaker-core** should remain relatively stable
* **style/persona/dialect-performance** should be allowed to move
* **semantics** should depend mostly on the text, not on the voice change

That gives you much sharper training relations than “this clip is male” or “this clip is dialect X.”

I think this also clarifies why the earlier gender softmax caused collapse while dialect softmax could help. A binary gender label is a crude partition that the model can exploit as a shortcut. But within-speaker dialect emulation or character voicing creates **counterexamples to the shortcut**. It teaches the model that apparent surface voice properties are not identical to speaker identity. That is exactly the kind of structure you need if you want factorization instead of entanglement.

A good way to use this data would be to make pairs or triplets with explicit meanings:

* same speaker, same text, different performed voice
  → preserve semantics, mostly preserve speaker-core, allow style shift

* same speaker, different text, different performed voice
  → preserve speaker-core more weakly, separate semantics, allow style shift

* different speakers, same text
  → preserve semantic similarity, separate speaker-core

* same speaker, dialect emulation vs native style
  → preserve speaker-core, move dialect/style block

So the signal is not just “what class is this?”, but “what should stay fixed and what should change?”

That suggests a very promising modeling direction: treat these examples as supervision for a **transform block** rather than just another classifier target. In other words, instead of only asking the model to assign labels, ask it to encode:

* stable identity
* controllable deviation from identity

That is closer to what your data actually contains.

The shortest summary is:

> Within-speaker transformations are valuable because they replace static labels with structured counterfactuals.

And for your problem, counterfactuals are probably the missing ingredient.

If you want, I can next sketch a concrete loss setup built around within-speaker transformation pairs, with separate terms for speaker-core, semantics, and style shift.

-----

Good — then you already know where the bodies are buried here 🙂

What I said about pitch being only a partial proxy for prosody was the polite, ML-friendly understatement. From a phonetics perspective, the real issue is more structural:

> **F0 is one control signal among several, and often not the one that carries the linguistically relevant contrast.**

So if you lean too hard on pitch as “the prosody axis,” you risk teaching the model a very particular, somewhat artificial decomposition of the signal.

---

## 🧠 What your background lets you exploit (that most ML setups miss)

Most ML treatments flatten prosody into:

* pitch (maybe log-F0)
* sometimes energy

But you know prosody lives in:

* **contour shape**, not just level (intonational phonology)
* **timing** (durational patterns, rhythm class, segment lengthening)
* **relative scaling** (speaker-normalized ranges, register shifts)
* **alignment** (tone–segment anchoring)
* **discourse structure** (focus, phrasing, boundary strength)

So the interesting opportunity in your setup is not “add pitch,” but:

> Use pitch *as a controllable intervention*, while letting the model discover a broader **prosodic subspace**.

---

## 🔬 Why pitch still works well in your case

Even with all that, pitch is still extremely useful here for one reason:

> It gives you **clean counterfactuals with minimal lexical disruption**

A small pitch shift:

* preserves segmental content
* mostly preserves speaker identity (up to limits)
* perturbs a salient but *non-discrete* dimension

That makes it ideal for **probing invariances**, not defining the space.

---

## ⚠️ Where pitch-as-target can go wrong (phonetically speaking)

You’ll already anticipate these, but they matter for modeling:

### 1. Register vs contour

A global pitch shift changes register, not contour shape.

So:

* the model may learn “prosody = mean F0”
* and completely ignore contour-level distinctions (e.g. H* vs L* patterns)

### 2. Speaker normalization leakage

If your speaker embedding encodes pitch range (it usually does), then:

* pitch shifts can leak into speaker-core
* unless you explicitly constrain it

### 3. Nonlinear perceptual effects

Equal Hz shifts ≠ equal perceptual shifts:

* semitone scaling is better, but still not perfect across speakers

### 4. Interaction with voice quality

Especially in acted speech:

* falsetto, creak, breathiness, etc.
* these often co-vary with F0 but are not reducible to it

---

## 💡 A more “phonetician-native” way to use pitch here

Instead of treating pitch as a **target**, treat it as a **known transformation operator**.

You can think in terms of:

> “What representation is invariant under this transformation, and what representation is equivariant?”

---

### Suggested decomposition (phonetically grounded)

[
z = [z_{\text{ling}}, z_{\text{speaker-core}}, z_{\text{prosody}}, z_{\text{voice-quality}}]
]

Where:

* **(z_{\text{ling}})** → segmental + lexical + semantic content
* **(z_{\text{speaker-core}})** → anatomical / habitual traits
* **(z_{\text{prosody}})** → contour, phrasing, prominence
* **(z_{\text{voice-quality}})** → phonation, register, etc.

Pitch shifts should ideally:

* leave (z_{\text{ling}}) invariant
* mostly leave (z_{\text{speaker-core}}) invariant (small shifts)
* move (z_{\text{prosody}}) in a structured way
* possibly interact with (z_{\text{voice-quality}})

---

## 🧪 Better than raw pitch: relative / structured signals

Given your background, you might get more mileage from:

### 1. **Speaker-normalized F0**

* z-score or semitone relative to speaker baseline
* reduces leakage into speaker-core

### 2. **Contour features**

* slope, curvature, turning points
* or even learned via a small contour encoder

### 3. **Pairwise prosodic similarity**

Instead of absolute pitch targets:

* “these two utterances have similar intonation”
* “these differ mainly in register”

### 4. **Time-aligned representations**

* DTW-aligned F0 contours for same text
* especially powerful with your Librivox parallel readings

---

## 🔄 Connecting back to your earlier findings

Your earlier results now line up even more cleanly:

* **Gender softmax collapsed**
  → low-dimensional, shortcut-prone, highly correlated with speaker

* **Dialect softmax worked**
  → richer structure, partly orthogonal to speaker/semantics

* **Acted voices help**
  → within-speaker transformations break correlations

* **Pitch axis promising**
  → continuous, controllable, non-collapsing

From a phonetics lens, the pattern is:

> The model behaves well when supervision reflects **continuous or structured variation**, and collapses when given **coarse categorical partitions that align with existing correlations**.

---

## 🧭 If I were to push one idea further

Given your expertise, I’d seriously consider this:

> Use **same-text, multi-speaker Librivox data + F0 contour alignment** as a core supervision signal.

That gives you:

* identical lexical content
* variation in speaker, dialect, style
* measurable prosodic differences

You can then explicitly train:

* semantic invariance
* speaker separation
* prosodic variation tracking

This is much closer to how prosody is actually studied experimentally.

---

## 🧾 Bottom line

Pitch is valuable here not because it *is* prosody, but because it gives you:

> A clean, controllable perturbation that exposes whether your representation is properly factorized.

And with your background, you’re in a rare position to go beyond the usual ML simplifications and actually build something that respects the structure of the signal.

---

If you want, I can sketch a concrete loss that uses:

* pitch-shift augmentations
* Librivox parallel readings
* and block-structured embeddings

in a way that lines up with phonetic theory rather than just ML convenience.

-----

Here’s a concrete setup I’d try.

The main design choice is to stop asking one space to do everything, and instead make the decomposition explicit:

[
z(x) = \big[z_{\text{ling}}(x); ;; z_{\text{spk}}(x); ;; z_{\text{pros}}(x)\big]
]

You could add a fourth block later for channel / voice quality / persona, but I would start with three.

The motivation is the same as the paper’s broad lesson: contrastive objectives tend to force one geometry into the learned space, while richer structure needs either separate subspaces or losses that do not aggressively collapse rank. That is one reason a VICReg-like direction is attractive here. 

## Model sketch

Let the trunk be a speech encoder:

[
h = f_\theta(x)
]

Then three projection heads:

[
z_{\text{ling}} = P_{\text{ling}} h,\quad
z_{\text{spk}} = P_{\text{spk}} h,\quad
z_{\text{pros}} = P_{\text{pros}} h
]

I would make them modestly sized and initially similar in width, since your earlier findings suggest imbalance causes one factor to dominate.

A plausible first split:

* (d_{\text{ling}} = 256)
* (d_{\text{spk}} = 192)
* (d_{\text{pros}} = 128)

If you want to be conservative, just set all three to 192 at first.

## Data relations to exploit

For each anchor utterance (x), try to construct some subset of:

* (x^{\text{text}}): same or near-same text, different speaker
* (x^{\text{spk}}): same speaker, different text
* (x^{\text{pitch}+}), (x^{\text{pitch}-}): pitch-shifted versions
* (x^{\text{style}}): same speaker, acted voice / dialect imitation / “trying to sound different”
* (x^{\text{par}}): parallel reading of same text from Librivox

Then define which blocks should be invariant and which should move.

## Losses by block

### 1. Linguistic block

Goal: preserve lexical/semantic content, ignore speaker and moderate prosodic changes.

For (z_{\text{ling}}), use either teacher alignment from sentence transformers or text-linked positives. I would avoid pure shared-space InfoNCE and use a VICReg-style or similarity-regression objective.

A simple version:

[
\mathcal L_{\text{ling-inv}}
============================

|z_{\text{ling}}(x)-z_{\text{ling}}(x^{\text{text}})|*2^2
+
\lambda*{\text{pitch-ling}}
|z_{\text{ling}}(x)-z_{\text{ling}}(x^{\text{pitch}})|_2^2
]

If you have a semantic teacher similarity (s^{\text{sem}}_{ij}), better still:

[
\mathcal L_{\text{ling-rel}}
============================

\sum_{(i,j)\in \mathcal P}
\Big(\cos(z_{\text{ling},i},z_{\text{ling},j}) - s^{\text{sem}}_{ij}\Big)^2
]

Then add VICReg-style variance and covariance regularizers on the batch:

[
\mathcal L_{\text{ling-var}} + \mathcal L_{\text{ling-cov}}
]

That gives:

[
\mathcal L_{\text{ling}}
========================

\mathcal L_{\text{ling-inv or rel}}
+
\alpha_\ell \mathcal L_{\text{ling-var}}
+
\beta_\ell \mathcal L_{\text{ling-cov}}
]

### 2. Speaker-core block

Goal: stable across text changes and small prosodic manipulations; somewhat stable across performed-voice changes.

Use your speaker teacher if it works, but again I’d lean toward similarity regression or VICReg rather than one global InfoNCE.

[
\mathcal L_{\text{spk-rel}}
===========================

\sum_{(i,j)\in \mathcal P}
\Big(\cos(z_{\text{spk},i},z_{\text{spk},j}) - s^{\text{spk}}_{ij}\Big)^2
]

Then explicitly add invariance across pitch-shifted versions:

[
\mathcal L_{\text{spk-pitch}}
=============================

|z_{\text{spk}}(x)-z_{\text{spk}}(x^{\text{pitch}})|_2^2
]

And optionally soft invariance across acted voice:

[
\mathcal L_{\text{spk-style}}
=============================

w_{\text{style}}
|z_{\text{spk}}(x)-z_{\text{spk}}(x^{\text{style}})|_2^2
]

with (w_{\text{style}} < 1), because acted voice may legitimately perturb some speaker cues.

Then again:

[
\mathcal L_{\text{spk}}
=======================

\mathcal L_{\text{spk-rel}}
+
\lambda_{\text{pitch}} \mathcal L_{\text{spk-pitch}}
+
\lambda_{\text{style}} \mathcal L_{\text{spk-style}}
+
\alpha_s \mathcal L_{\text{spk-var}}
+
\beta_s \mathcal L_{\text{spk-cov}}
]

### 3. Prosody block

Goal: capture pitch/register/contour/style differences while not swallowing semantics or speaker identity.

Here I would not start with a classifier. I would use continuous targets or pairwise ordering.

If you apply a known pitch transform (\Delta) in semitones, you can ask the prosody block distance to reflect it:

[
\mathcal L_{\text{pros-pitch}}
==============================

\Big(|z_{\text{pros}}(x)-z_{\text{pros}}(x^{\text{pitch}_\Delta})|_2 - g(|\Delta|)\Big)^2
]

where (g) can be linear at first, say (g(|\Delta|)=c|\Delta|).

Or, if you want something weaker and safer, use ranking:

[
|\Delta_1| < |\Delta_2|
;\Rightarrow;
|z_{\text{pros}}(x)-z_{\text{pros}}(x^{\text{pitch}*{\Delta_1}})|*2
<
|z*{\text{pros}}(x)-z*{\text{pros}}(x^{\text{pitch}_{\Delta_2}})|_2
]

For acted voice / dialect imitation, use pairwise similarity targets if you have annotations, otherwise just let those examples contribute to variance and relational structure within the prosody block.

You can also add a light regression head for interpretable summaries such as speaker-normalized mean F0, range, or a contour embedding:

[
\mathcal L_{\text{pros-reg}} = |\hat p(x)-p(x)|_2^2
]

where (p(x)) is a prosodic descriptor, not raw framewise F0 unless you want to go there.

Then:

[
\mathcal L_{\text{pros}}
========================

\mathcal L_{\text{pros-pitch/rank}}
+
\lambda_{\text{reg}} \mathcal L_{\text{pros-reg}}
+
\alpha_p \mathcal L_{\text{pros-var}}
+
\beta_p \mathcal L_{\text{pros-cov}}
]

## Cross-block separation

This is the part I would consider essential.

Penalize cross-covariance between blocks:

[
\mathcal L_{\text{sep}}
=======================

|\mathrm{Cov}(Z_{\text{ling}}, Z_{\text{spk}})|*F^2
+
|\mathrm{Cov}(Z*{\text{ling}}, Z_{\text{pros}})|*F^2
+
|\mathrm{Cov}(Z*{\text{spk}}, Z_{\text{pros}})|_F^2
]

where (Z_{\text{ling}}) etc. are batch matrices.

That is more useful than just hoping the heads separate on their own.

If you want something stronger, add adversarial nuisance removal:

* a gradient-reversal classifier predicting speaker from (z_{\text{ling}})
* a classifier predicting text/semantics from (z_{\text{spk}})
* maybe predicting coarse pitch bin from (z_{\text{ling}})

But I would start with covariance penalties first.

## Full loss

A clean first full objective would be:

[
\mathcal L
==========

\lambda_\ell \mathcal L_{\text{ling}}
+
\lambda_s \mathcal L_{\text{spk}}
+
\lambda_p \mathcal L_{\text{pros}}
+
\lambda_{\text{sep}} \mathcal L_{\text{sep}}
]

with all four weights of the same rough order initially.

If you want a concrete starting point:

[
\lambda_\ell = 1.0,\quad
\lambda_s = 1.0,\quad
\lambda_p = 0.7,\quad
\lambda_{\text{sep}} = 0.1
]

Then tune based on leakage diagnostics.

## Why not just InfoNCE everywhere?

Because your own experiments already suggest the failure mode: one shared contrastive geometry tends to let the easiest or coarsest target dominate. The paper’s framing is consistent with that: these methods are tightly tied to the geometry of the target relation structure, and contrastive losses in particular can push toward a compressed representation of that structure. VICReg-like terms are less brittle when you need multiple structures to coexist. 

## How to use the Librivox cases

These are especially useful because one pair can supervise different blocks differently.

For same speaker, same text, different performed voice:

* (z_{\text{ling}}): positive
* (z_{\text{spk}}): moderately positive
* (z_{\text{pros}}): allowed to differ

For same text, different speaker:

* (z_{\text{ling}}): positive
* (z_{\text{spk}}): negative or unrelated
* (z_{\text{pros}}): maybe neutral

For same speaker, dialect imitation:

* (z_{\text{spk}}): positive
* (z_{\text{pros}}): likely different
* (z_{\text{ling}}): depends whether text is same or paraphrastic

That block-specific reuse of the same pair is the real advantage.

## Diagnostics I’d track

You’ll want more than retrieval metrics.

I’d explicitly measure:

1. How well text is recoverable from (z_{\text{ling}}), and how poorly from (z_{\text{spk}}).
2. How well speaker is recoverable from (z_{\text{spk}}), and how poorly from (z_{\text{ling}}).
3. Whether pitch-shift magnitude is monotonic with distance in (z_{\text{pros}}).
4. Whether same-speaker acted-voice pairs stay closer in (z_{\text{spk}}) than different-speaker pairs.
5. Cross-block covariance over training.

If one block starts solving everyone else’s job, you’ll see it quickly.

## A very simple first ablation

If you want the shortest path to something informative, I’d do this first:

* three heads
* semantic teacher similarity regression on (z_{\text{ling}})
* speaker teacher similarity regression on (z_{\text{spk}})
* pitch-shift ranking loss on (z_{\text{pros}})
* VICReg variance/covariance within each block
* cross-block covariance penalty

No gender classifier, no dialect classifier at first.

Then, once that is stable, add dialect as either:

* a tiny auxiliary classifier on (z_{\text{pros}}), or
* a fourth block if it clearly behaves as its own axis

That seems safer than mixing it in from the start.

## My strongest guess

The highest-payoff change is probably not any one loss term, but the combination of:

* block-specific objectives
* within-block anti-collapse regularization
* explicit cross-block decorrelation

That is the smallest design that matches what your experiments already seem to be telling you.

If you want, next I can turn this into a more implementation-shaped recipe, including a batch construction strategy for Librivox-style parallel readings.

