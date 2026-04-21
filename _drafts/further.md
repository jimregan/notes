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

