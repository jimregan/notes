---
toc: true
layout: post
hidden: true
description: ChatGPT paper summary
title: Why Language Models Hallucinate
categories: [summary, chatgpt]
---

```bibtex
@misc{kalai2025languagemodelshallucinate,
      title={Why Language Models Hallucinate}, 
      author={Adam Tauman Kalai and Ofir Nachum and Santosh S. Vempala and Edwin Zhang},
      year={2025},
      eprint={2509.04664},
      archivePrefix={arXiv},
      primaryClass={cs.CL},
      url={https://arxiv.org/abs/2509.04664}, 
}
```

The paper argues that language model hallucinations are not mysterious or purely accidental. They arise from two main sources: **statistical pressures during pretraining** and **misaligned incentives during evaluation and post-training**.

The authors’ central claim is that language models often hallucinate because they are trained and evaluated in ways that reward **guessing** more than **admitting uncertainty**. Like students taking an exam, models often maximize their score by giving a plausible answer, even when they are unsure.

During **pretraining**, the paper connects hallucinations to ordinary errors in binary classification. The authors introduce an “Is-It-Valid” classification problem: given a possible model output, decide whether it is valid or erroneous. Their key theoretical result is that if a model cannot reliably distinguish valid outputs from plausible false ones, then it will naturally generate false outputs. In simplified terms, generative hallucination is at least as hard as classifying whether an output is valid.

A major example is **arbitrary facts**, such as obscure birthdays or dissertation titles. If a fact appears only once in the training data, or not at all, there may be no learnable pattern that lets the model infer it. The paper uses the idea of “singleton” facts—facts that appear only once in training—to argue that models should be expected to hallucinate on many such long-tail facts.

The paper also discusses other causes of pretraining errors, including poor model representations, computational hardness, distribution shift, and “garbage in, garbage out,” where models reproduce errors from their training data.

The second major part of the paper explains why hallucinations persist after **post-training**. The authors argue that most benchmarks use binary scoring: a response is either correct or incorrect, and “I don’t know” usually gets no credit. Under that scoring system, guessing is often the optimal strategy. A model that honestly abstains when uncertain can perform worse than a model that always guesses.

The authors call this an “epidemic” of evaluations that penalize uncertainty. They argue that adding more hallucination-specific benchmarks is not enough, because the dominant mainstream benchmarks still reward overconfident guessing.

Their proposed fix is to modify existing evaluations so they explicitly reward appropriate uncertainty. For example, benchmarks could tell models: answer only if you are more than a specified confidence threshold, otherwise say “I don’t know.” Incorrect answers would receive a penalty, correct answers would receive credit, and abstentions would receive zero. This would make honesty about uncertainty compatible with leaderboard performance.

The paper’s main contribution is therefore both technical and social: technically, it shows how hallucinations emerge from standard statistical learning pressures; socially, it argues that the AI community must change benchmark incentives if it wants models to become more trustworthy.

In one sentence: **hallucinations happen because models are statistically pushed to generate plausible completions, and they persist because our evaluations often reward confident guessing more than calibrated uncertainty.**
