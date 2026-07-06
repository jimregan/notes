---
toc: true
layout: post
hidden: true
description: ChatGPT paper summary
title: Inverse-Hessian Regularization for Continual Learning in ASR
categories: [summary, chatgpt]
---

I've read the paper. At a high level, this is a fairly elegant idea: take the simplicity of **weight averaging** for continual learning and replace its heuristic merge step with a **curvature-aware merge** based on an approximate inverse Hessian. The authors show that this substantially improves adaptation while keeping forgetting very low, without storing previous data. 

Here's the overview I'd want before diving into the code.

---

# The problem

The paper studies **continual learning (CL)** for **automatic speech recognition (ASR)**.

Training proceeds as

```
Task 1  ->  Task 2  ->  Task 3  -> ...
```

where each task might correspond to

* a new accent
* microphone
* recording condition
* speaker population

The challenge is **catastrophic forgetting**:

```
train on Task 1
↓

good on Task 1

train on Task 2
↓

good on Task 2
bad on Task 1
```

The important constraint is **memory-free continual learning**:

* no replay buffer
* no old datasets
* no expanding architecture

Only the previous model is available. 

---

# Existing solution: Fine-Tuning + Averaging (FTA)

The previous state-of-the-art memory-free method is surprisingly simple.

Suppose

```
θ_old
```

is the model before learning the new task.

Fine-tune normally:

```
θ_old
   |
   |  fine tune
   V
θ_ft
```

Instead of keeping the fine-tuned model, average the parameters:

```
θ_new =
(1-η) θ_old
+
η θ_ft
```

where

```
η = 1/t
```

after task *t*.

This reduces forgetting because it never fully commits to the new weights.

However, the authors identify two problems.

### 1. Adaptation shrinks over time

Since

```
η = 1/t
```

later tasks receive tiny updates.

Eventually

```
η ≈ 0
```

so learning almost stops.

---

### 2. Every parameter is treated equally

Suppose two directions in parameter space:

```
Direction A
very important for Task 1

Direction B
almost irrelevant
```

Weight averaging scales both equally.

But ideally we'd like

```
preserve A
allow movement along B
```

Weight averaging has no notion of this.

---

# Core idea of the paper

The authors ask:

> Instead of averaging blindly, can we determine which parameter directions are "safe" to move?

Their answer:

**Use the inverse Hessian of the previous task.**

This is the entire contribution.

---

# Geometric intuition

Imagine two loss basins.

Old task:

```
      _______
     /       \
    /         \
```

New task:

```
           _______
          /       \
         /         \
```

Fine-tuning moves directly toward the new basin:

```
old ● -------------> new
```

which exits the old basin.

Instead, they propose

```
old
 \
  \
   curved path
      \
       \
       new
```

where the update is warped by the inverse Hessian so it stays inside flatter directions of the previous task.

Figure 1 in the paper illustrates exactly this intuition. 

---

# The algorithm

Suppose fine-tuning produces

```
θ̃
```

The update is

```
Δθ = θ̃ − θ_old
```

Normally we'd do

```
θ_new = θ_old + Δθ
```

Instead they compute

```
θ_new =
θ_old
+
H^{-1} Δθ
```

where

```
H^{-1}
```

is the inverse Hessian of the previous task.

So rather than changing the endpoint,

they transform the **update vector**.

---

# Why does the inverse Hessian help?

Recall:

Large Hessian eigenvalue

→ steep direction

Small movement hurts performance.

Small Hessian eigenvalue

→ flat direction

Large movement is acceptable.

The inverse Hessian flips these:

```
steep direction
↓

small update

flat direction
↓

large update
```

So the update automatically avoids damaging directions.

---

# Practical challenge #1

A full Hessian is impossible.

For a 47M parameter model,

```
47,000,000²
```

entries would be required.

Impossible.

---

# Solution: Kronecker-factored approximation

Instead they use a **KFAC-style approximation**.

Rather than one enormous Hessian,

each linear layer has

```
A
×

B
```

Kronecker factors.

This allows efficient inverse-Hessian × vector products.

Importantly,

they never build the full Hessian.

---

# Practical challenge #2

You don't have old data

Ideally we'd compute

```
H(Task1 + Task2 + ...)
```

But after Task 3 starts,

Task 1 data is gone.

So they approximate

```
H(previous tasks)
≈
H(last task)
```

Only the most recent task's Hessian is retained.

This keeps storage constant regardless of the number of tasks.

---

# Layer-wise implementation

Only **linear layers** use Hessian correction.

For each weight matrix

```
W
```

they compute

```
ΔW = W_ft − W_old
```

then

```
W_new =
W_old
+
α H^{-1} ΔW
```

where α rescales the corrected update to have a comparable norm to the original update. The scalar τ controls the stability–plasticity tradeoff. 

---

# What about other parameters?

Things like

* convolution kernels
* normalization parameters
* biases

are simply averaged:

```
p_new
=
p_old
+
(1/t)
Δp
```

Exactly as in the earlier weight-averaging method.

Only the large linear layers receive Hessian-based correction.

---

# Computational cost

A nice aspect is that this is **not** a second-order optimizer.

Training is still ordinary Adam.

The workflow is:

```
Fine tune
↓

Done training

↓

Apply one inverse-Hessian correction

↓

Finished
```

So the expensive second-order computation happens **once per task**, not at every optimization step. 

---

# Experimental results

The paper evaluates on two continual-learning benchmarks for ASR:

1. Sequential English accents (Common Voice)
2. LibriSpeech → Libri-Adapt with accent + microphone shifts

Across both:

* IHR consistently outperforms previous **memory-free** methods.
* On the first benchmark it even outperforms experience replay (which stores past data), while maintaining essentially zero forgetting.
* On the harder second benchmark it remains the strongest memory-free method and comes closest to experience replay. 

---

# Why this paper is interesting

The contribution isn't a new optimizer or a new continual-learning framework. Instead, it's a smarter **merge operator**.

The pattern becomes:

```
Fine tune

↓

Obtain update Δθ

↓

Transform update using curvature

↓

Merge
```

This makes it easy to add to existing fine-tuning pipelines.

---

## From a code perspective

Since you've pointed me to the repository at:

```
/Users/joregan/Playing/inverse-hessian-regularization
```

I expect the implementation to break down into a few clear components:

1. Standard ASR fine-tuning (ESPnet).
2. Estimation and storage of KFAC inverse-Hessian factors for each linear layer.
3. A post-training merge routine that replaces the raw update with the Hessian-corrected update.
4. Evaluation across continual-learning tasks.

When you're ready, we can walk through the repository file by file, identify where each of these pieces lives, and map every major equation in the paper to the corresponding implementation.
