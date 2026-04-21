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

