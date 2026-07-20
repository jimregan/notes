---
toc: false
layout: post
hidden: true
description: LeWorldModel codebase notes
title: Codebase summary from Claude
categories: [lewm, claude]
---


# LeWorldModel (LeWM) — Codebase Overview

LeWorldModel is a **Joint Embedding Predictive Architecture (JEPA)** that learns compact world models directly from raw pixels. It learns latent space representations from observations and actions, then predicts future state embeddings autoregressively to enable model-predictive control (MPC) planning. Training is kept simple: only two loss terms (prediction loss + Gaussian regularizer), ~15M parameters, single GPU.

## File Map

| File | Purpose |
|------|---------|
| `jepa.py` | Core `JEPA` model: `encode`, `predict`, `rollout`, `get_cost` |
| `module.py` | Neural network components: transformer blocks, `ARPredictor`, `SIGReg`, `Embedder` |
| `train.py` | Hydra-configured training script using PyTorch Lightning |
| `eval.py` | Evaluation and MPC planning against `stable_worldmodel` environments |
| `utils.py` | Image preprocessing, column normalizers, model checkpoint callback |
| `config/train/` | Training configs (model hyperparams, optimizer, dataset keys) |
| `config/eval/` | Per-task evaluation configs and MPC solver configs (CEM / Adam) |

## Architecture

```
Pixels (B, T, 3, H, W) + Actions (B, T, A)
        │                        │
  [ViT-Tiny encoder]      [Action Encoder]
        │                        │
  [Projector MLP]          Action embeddings
        │                        │
        └────────┬───────────────┘
                 ▼
     [ARPredictor — Transformer with ConditionalBlocks]
                 │
         [Pred Projector MLP]
                 │
        Predicted embeddings
                 │
    Losses:  MSE(pred, target) + λ · SIGReg
```

**Key components in `module.py`:**

- `ARPredictor` — autoregressive transformer that predicts the next embedding conditioned on action embeddings via AdaLN-zero (`ConditionalBlock`)
- `SIGReg` — "Sketch Isotropic Gaussian Regularizer" — enforces that latent embeddings follow a Gaussian distribution using the Epps-Pulley statistic
- `Embedder` — converts action sequences to embeddings via 1D convolution + MLP
- `ConditionalBlock` — transformer block where LayerNorm scale/shift is modulated by action embeddings (AdaLN-zero)

## Training

`train.py` orchestrates:

1. Load HDF5 datasets via `stable_worldmodel`; normalize non-image columns with `get_column_normalizer`
2. Build JEPA with a ViT-Tiny encoder, transformer predictor, MLP projectors
3. `lejepa_forward()`: encode observations → predict future embeddings → compute `pred_loss + λ·sigreg_loss`
4. PyTorch Lightning trainer with bf16 precision, AdamW optimizer (lr 5e-5), WandB logging
5. `ModelObjectCallBack` serializes the full model object after each epoch alongside weight-only checkpoints

Key config: `config/train/lewm.yaml` — SIGReg weight `λ = 0.09`, 100 epochs, dataset-specific frameskip and data keys under `config/train/data/`.

## Evaluation / Planning

`eval.py` loads a trained checkpoint, wraps it as an `AutoCostModel` (from `stable_worldmodel`), and runs MPC planning:

- Supported tasks: `pusht`, `cube`, `reacher`, `two-room`
- Solvers: CEM or Adam (configured under `config/eval/solver/`)
- `JEPA.rollout()` autoregressively generates future embeddings for a candidate action sequence; `get_cost()` scores them against a goal embedding
- `World.evaluate_from_dataset()` samples starting states and goals from the dataset and measures success rate / generates videos

## Dependencies

- **PyTorch + PyTorch Lightning** — training loop and distributed support
- **Hydra** — hierarchical config management
- **stable_pretraining** — ViT backbone, data transforms
- **stable_worldmodel** — HDF5 dataset loading, environment API, policy/planning classes
- **einops** — tensor reshaping in transformer code
- **WandB** — experiment tracking
- **scikit-learn** — column normalizers
