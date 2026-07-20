---
title: solo-learn codebase reference
layout: post
toc: true
description: Claude-generated codebase reference
categories: [solo-learn, claude]
---

# solo-learn Codebase Description

solo-learn is a PyTorch Lightning-based library providing implementations of self-supervised learning methods for visual representation learning. It was published in JMLR (2022) and provides 21 self-supervised methods with consistent training infrastructure, multiple backbone architectures, and evaluation utilities.

---

## Repository layout

```
solo-learn/
├── solo/                    # Core library
│   ├── methods/             # Method implementations (BaseMethod + 21 subclasses)
│   ├── losses/              # Loss functions (one file per method)
│   ├── backbones/           # Backbone architectures
│   ├── data/                # Data loading and augmentation
│   ├── args/                # Configuration validation (Hydra/OmegaConf)
│   └── utils/               # Shared utilities
├── tests/                   # pytest suite mirroring the package structure
├── scripts/                 # YAML training configs
│   ├── pretrain/            # Pretraining configs (CIFAR, ImageNet)
│   ├── linear/              # Linear evaluation configs
│   ├── finetune/            # Fine-tuning configs
│   ├── knn/                 # K-NN evaluation scripts
│   └── umap/                # UMAP visualization scripts
├── downstream/              # Downstream task examples (object detection via Detectron2)
├── docs/                    # Sphinx documentation
├── main_pretrain.py         # Pretraining entry point
├── main_linear.py           # Linear evaluation / fine-tuning entry point
├── main_knn.py              # K-NN evaluation entry point
└── main_umap.py             # UMAP visualization entry point
```

---

## Entry points

- **`main_pretrain.py`**: Hydra-based pretraining orchestrator. Handles distributed training setup, auto-resume from checkpoints, and optional UMAP visualization at end of training.
- **`main_linear.py`**: Linear evaluation and fine-tuning over a frozen backbone. Supports mixup, cutmix, and label smoothing.
- **`main_knn.py`**: Offline K-NN evaluation using a weighted KNN classifier over frozen features.
- **`main_umap.py`**: Extracts features and generates UMAP visualizations.

---

## Core library (`solo/`)

### `methods/`

`base.py` defines `BaseMethod` (a `LightningModule`) and `BaseMomentumMethod`. All method classes extend one of these.

**`BaseMethod` responsibilities:**
- Backbone construction and feature extraction
- Projector management and optimizer/scheduler setup (SGD, LARS, Adam, AdamW)
- Training step with multi-crop support via `multicrop_forward()`
- Online linear evaluation (a lightweight linear head trained in parallel with pretraining)
- K-NN and UMAP integration

**Batch format contract:** every training batch has the shape `[img_indexes, [X], Y]`, where `[X]` is a list of `num_large_crops + num_small_crops` tensors of shape `(B, C, H, W)`. Methods receive this via `training_step` and call `super().training_step()` first to get backbone features for all crops.

**`learnable_params` API:** each method exposes a `learnable_params` property returning a list of `{"name": ..., "params": ...}` dicts. The base class uses this to build optimizer param groups, which allows per-group settings (e.g., disabling the LR scheduler for the projection head in SimSiam).

Each method file adds only what is specific to that method: projector/predictor architecture, the `learnable_params` extension, and a `training_step` that calls the corresponding loss function.

### `losses/`

One file per method, exposing a single `*_loss_func()` function or loss class. These are pure functions — they take raw feature tensors and return a scalar. The single exception is `DINOLoss`, which is a `nn.Module` that maintains a running teacher center.

### `backbones/`

Six backbone families. Each backbone callable returns `(backbone_module, feature_dim)` so projection heads can be sized correctly without hard-coding dimensions.

| Family | Variants |
|---|---|
| ResNet | resnet18, resnet50 |
| ViT | vit_tiny, vit_small, vit_base, vit_large |
| Swin Transformer | swin_tiny, swin_small, swin_base, swin_large |
| ConvNeXt | convnext_tiny, convnext_small, convnext_base, convnext_large |
| PoolFormer | poolformer_s12, poolformer_s24, poolformer_s36, poolformer_m36, poolformer_m48 |
| WideResNet | wide_resnet28w2, wide_resnet28w8 |

### `data/`

- **`pretrain_dataloader.py`**: Multi-crop augmentation pipelines (`NCropAugmentation`, `FullTransformPipeline`, `build_transform_pipeline`) and dataset wrappers for CIFAR, STL-10, ImageNet, H5, and custom image folders. The `dataset_with_index` factory wraps any dataset to also return the sample index, which methods use for hard-negative mining.
- **`classification_dataloader.py`**: Standard supervised evaluation data loading.
- **`dali_dataloader.py`**: Optional NVIDIA DALI integration providing ~50% data loading speedup on GPU runners.
- **`h5_dataset.py`**: HDF5 dataset wrapper (optional dependency).

### `args/`

Hydra/OmegaConf configuration parsing and validation. One file per entry point (`pretrain.py`, `linear.py`, `knn.py`, `umap.py`) plus `dataset.py` for dataset-specific parameters. Each file's `add_and_assert_specific_cfg()` pattern is also used by individual method classes to validate their own `method_kwargs`.

### `utils/`

| File | Purpose |
|---|---|
| `lars.py` | LARS optimizer (layer-wise adaptive rate scaling) |
| `lr_scheduler.py` | `LinearWarmupCosineAnnealingLR` |
| `momentum.py` | `MomentumUpdater` (EMA) and `initialize_momentum_params` for BYOL/MoCo-style methods |
| `knn.py` | `WeightedKNNClassifier` for online and offline evaluation |
| `auto_resumer.py` | Automatic checkpoint resumption on crash |
| `checkpointer.py` | Custom checkpoint saving with directory organisation |
| `auto_umap.py` | Feature extraction and UMAP plotting |
| `metrics.py` | `accuracy_at_k`, `weighted_mean` |
| `kmeans.py` | K-means clustering (used by DeepCluster V2) |
| `sinkhorn_knopp.py` | Sinkhorn-Knopp algorithm (used by SwAV) |
| `whitening.py` | Feature whitening (used by W-MSE) |
| `misc.py` | `omegaconf_select`, `remove_bias_and_norm_from_weight_decay`, `make_contiguous` |
| `positional_encodings.py` | Positional encodings for ViT backbones |

---

## How the pieces wire together

### Contrastive method (SimCLR)

```python
# SimCLR.training_step — the full pattern every contrastive method follows
def training_step(self, batch, batch_idx):
    indexes = batch[0]                        # sample indices, used for hard negatives
    out = super().training_step(batch, batch_idx)  # runs backbone on all crops, online linear eval
    class_loss = out["loss"]                  # cross-entropy from the online linear head
    z = torch.cat(out["z"])                   # projected features from all crops

    n_augs = self.num_large_crops + self.num_small_crops
    indexes = indexes.repeat(n_augs)

    nce_loss = simclr_loss_func(z, indexes=indexes, temperature=self.temperature)
    return nce_loss + class_loss
```

### Momentum / teacher-student (BYOL)

```python
# BYOL extends BaseMomentumMethod, which manages the EMA copy automatically.
# The predictor is applied to the online branch; the momentum branch is the target.

class BYOL(BaseMomentumMethod):
    def __init__(self, cfg):
        super().__init__(cfg)
        self.projector = nn.Sequential(...)           # online projector
        self.momentum_projector = nn.Sequential(...)  # EMA copy
        initialize_momentum_params(self.projector, self.momentum_projector)
        self.predictor = nn.Sequential(...)

    def training_step(self, batch, batch_idx):
        out = super().training_step(batch, batch_idx)  # also runs momentum_forward()
        p = torch.cat(out["p"])   # predictor outputs (online)
        z = torch.cat(out["momentum_z"])  # momentum projector outputs (target, no grad)
        loss = byol_loss_func(p, z)
        return loss + out["loss"]
```

`BaseMomentumMethod.on_train_batch_end()` calls `MomentumUpdater.update()` to EMA-update the momentum backbone and projector after each step.

### Configuration system

Training is configured via Hydra with YAML files in `scripts/`. A representative config:

```yaml
method: barlow_twins
backbone:
  name: resnet18
method_kwargs:
  proj_hidden_dim: 2048
  proj_output_dim: 2048
  scale_loss: 0.1
data:
  dataset: imagenet100
  train_path: ./datasets/imagenet-100/train
  num_workers: 4
  num_large_crops: 2
  num_small_crops: 0
optimizer:
  name: lars
  batch_size: 128
  lr: 0.3
  weight_decay: 1.0e-4
scheduler:
  name: warmup_cosine
max_epochs: 400
devices: [0, 1]
accelerator: gpu
strategy: ddp
```

---

## Supported methods

| Method | Year | Loss | Base class |
|---|---|---|---|
| All4One | 2023 | `all4one_loss_func` | `BaseMomentumMethod` |
| Barlow Twins | 2021 | `barlow_loss_func` | `BaseMethod` |
| BYOL | 2020 | `byol_loss_func` | `BaseMomentumMethod` |
| DeepCluster V2 | 2020 | CE over cluster assignments | `BaseMethod` |
| DINO | 2021 | `DINOLoss` | `BaseMomentumMethod` |
| MAE | 2021 | MSE (pixel reconstruction) | `BaseMethod` |
| MoCo V2+ | 2020 | `simclr_loss_func` + queue | `BaseMomentumMethod` |
| MoCo V3 | 2021 | `mocov3_loss_func` | `BaseMomentumMethod` |
| NNBYOL | — | `byol_loss_func` + NN bank | `BaseMomentumMethod` |
| NNCLR | 2021 | `simclr_loss_func` + NN bank | `BaseMethod` |
| NNSiam | — | `simsiam_loss_func` + NN bank | `BaseMethod` |
| ReSSL | 2021 | `ressl_loss_func` | `BaseMomentumMethod` |
| SimCLR | 2020 | `simclr_loss_func` | `BaseMethod` |
| SimSiam | 2021 | `simsiam_loss_func` | `BaseMethod` |
| SupCon | 2020 | `simclr_loss_func` (supervised) | `BaseMethod` |
| SwAV | 2020 | `swav_loss_func` + Sinkhorn | `BaseMethod` |
| VIbCReg | 2022 | `vibcreg_loss_func` | `BaseMethod` |
| VICReg | 2021 | `vicreg_loss_func` | `BaseMethod` |
| W-MSE | 2021 | `wmse_loss_func` | `BaseMethod` |

NNBYOL and NNSiam are solo-learn-specific nearest-neighbour variants without a separate publication.

---

## Testing

58 test files organised to mirror `solo/`:

- `tests/methods/`: One file per method — validates config, learnable parameters, forward/backward pass, and momentum updates.
- `tests/losses/`: Loss function shape and value sanity checks.
- `tests/backbones/`: Output shape tests for each backbone family.
- `tests/args/`: Config parsing and validation tests.
- `tests/data/`: Data loading and augmentation tests.
- `tests/utils/`: Utility function tests.
- `tests/dali/`: DALI-specific tests (requires GPU runner; separate CI workflow).

**Key conventions:**
- `tests/methods/utils.py` provides `gen_base_cfg()`, `gen_batch()`, and `gen_trainer()` to reduce boilerplate across all method tests.
- `gen_base_cfg()` builds a minimal OmegaConf config using `resnet18` and a custom dataset, avoiding any real data dependency.
- Method tests verify that `learnable_params` returns the expected parameter groups and that a training step runs without error.

Run the main suite (no DALI or GPU required):
```bash
pytest --cov=solo tests/args tests/backbones tests/data tests/losses tests/methods tests/utils
```

---

## Installation

```bash
# Full install (DALI requires NVIDIA index)
pip install .[dali,umap,h5] --extra-index-url https://developer.download.nvidia.com/compute/redist

# Development
pip install -e .[umap,h5]
pre-commit install
```

**Core dependencies:** torch ≥ 1.10, torchvision, lightning 2.1.2, torchmetrics, einops, wandb, timm, hydra-core, scikit-learn, scipy

**Optional extras:**
- `[dali]` — nvidia-dali-cuda110; ~50% faster data loading on GPU runners
- `[umap]` — umap-learn, matplotlib, seaborn; enables UMAP visualisation
- `[h5]` — h5py; enables HDF5 dataset support

---

## CI/CD and tooling

- **GitHub Actions**: tests on Python 3.8–3.11 / Ubuntu + Windows; separate GPU workflow for DALI tests; Sphinx docs build and link check.
- **pre-commit**: black (line length 100), isort, mypy, nbstripout, yapf.
- **Experiment tracking**: Weights & Biases (wandb), configured per run via Hydra.
- **Documentation**: Sphinx on ReadTheDocs, with tutorials for adding new methods, offline evaluation, K-NN, and UMAP.

---

## Adding a new method

1. Add `solo/methods/my_method.py` extending `BaseMethod` or `BaseMomentumMethod`.
2. Add `solo/losses/my_method.py` with the loss function.
3. Register the method name in `solo/methods/__init__.py`.
4. Add a YAML config under `scripts/pretrain/`.
5. Add tests under `tests/methods/` and `tests/losses/`.
6. Reproduce results on CIFAR-10/100 (ImageNet optional).
