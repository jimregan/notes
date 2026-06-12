# LightlySSL Codebase Overview

LightlySSL is a modular PyTorch framework for self-supervised visual representation learning. It provides low-level building blocks — loss functions, model heads, data transforms — that you compose yourself. It also ships an optional REST client for the commercial Lightly platform.

---

## Top-level layout

```
lightly/          # main Python package
benchmarks/       # ImageNet benchmark scripts
examples/         # standalone usage examples (PyTorch + PyTorch Lightning)
tests/            # pytest suite mirroring the package structure
docs/             # Sphinx documentation source
requirements/     # pinned requirement files
```

---

## Package internals (`lightly/`)

### `core.py`

High-level one-liner API (`train_model_and_embed_images`, `train_embedding_model`, `embed_images`). Intended for quick experimentation; not the primary interface for serious use.

### `loss/`

One file per loss function, ~25 implementations. All inherit from `torch.nn.Module` and expose a `forward()` that takes raw feature tensors (not logits or class scores).

**Common constructor parameters:**

| Parameter | Purpose |
|---|---|
| `temperature` | Softmax sharpening (contrastive methods) |
| `gather_distributed` | All-gather features across GPUs before computing loss |
| `memory_bank_size` | Tuple `(num_features, dim)` for queue-based negatives |

**Representative implementations:**

- **`NTXentLoss`** — SimCLR/MoCo contrastive loss. Computes cosine similarity matrix over a batch, masks the diagonal (self-pairs), and optionally draws negatives from a `MemoryBankModule`. Distributed gathering dequeues from all ranks before masking.

- **`BarlowTwinsLoss`** — Computes the cross-correlation matrix of the two batch embeddings after batch normalisation. Penalises off-diagonal entries (redundancy reduction) with weight `lambda_param`.

- **`DINOLoss`** — Cross-entropy between teacher softmax and student log-softmax across the multi-crop views. Maintains a running `center` (moving average of teacher outputs) to prevent collapse. The teacher temperature is linearly warmed up over `warmup_teacher_temp_epochs` epochs. `update_center()` must be called after each backward pass.

- **`IBOTPatchLoss` / `IBOTPlusPlusPatchLoss`** — Patch-level counterpart to DINO loss; operates on per-token output rather than the CLS token.

- **`LeJEPALoss` + `SIGReg`** — The newest addition (2026). `lejepa_invariance_loss()` pulls local-view projections toward the global-view mean (MSE). `SIGReg` is a regulariser based on the Epps-Pulley test that encourages the embedding distribution to match an isotropic Gaussian via characteristic function integration over a frequency grid. Unusual compared to the variance terms in VICReg.

- **`VICRegLoss`** — Three-term loss: invariance (MSE between views), variance (hinge on per-dimension std), covariance (off-diagonal of covariance matrix). No negatives required.

- **`SwaVLoss`** — Computes Sinkhorn-normalised soft cluster assignments and applies a swapped prediction objective between views.

- **`MSNLoss` / `PMSNLoss`** — Masked Siamese Networks loss. `PMSNLoss` adds a prior-matching term (student prototype distribution should match a target prior).

- **`KoLeoLoss`** — Pairwise log-repulsion loss encouraging uniform coverage of the embedding sphere.

- **`MemoryBankModule`** (`loss/memory_bank.py`) — FIFO queue with a learnable pointer. Shared by `NTXentLoss`, `NNMemoryBankModule`, and others. `forward(output, update)` returns the current bank contents and optionally enqueues the batch.

### `models/`

Legacy high-level wrappers (`SimCLR`, `BYOL`, `MoCo`, `SimSiam`, `NNCLR`, `BarlowTwins`) that bundle a backbone with projection/prediction heads. These pre-date the low-level approach and are being phased out; new work should use `models/modules/` directly.

**`ResNetGenerator`** — Custom ResNet that swaps the 7×7 stem convolution for a 3×3 one. This makes it faster for small-image pretraining (CIFAR-scale), while remaining compatible with ImageNet.

### `models/modules/`

The primary building-block layer.

#### Projection and prediction heads (`heads.py`)

`ProjectionHead` is the base class. Its constructor takes a list of 4- or 5-tuples:

```python
(in_features, out_features, batch_norm, non_linearity[, use_bias])
```

It builds a sequential MLP from that spec. Method-specific subclasses fix the spec:

| Head | Layers | Notes |
|---|---|---|
| `SimCLRProjectionHead` | 2 (BN+ReLU hidden) | Standard SimCLR MLP |
| `BarlowTwinsProjectionHead` | 3 (8192 hidden) | Wide MLP |
| `BYOLProjectionHead` | 2 | No BN on output |
| `BYOLPredictionHead` | 2 | Narrower |
| `MoCoProjectionHead` | Configurable `num_layers` | Optional BN |
| `NNCLRProjectionHead` | 3 | |
| `NNCLRPredictionHead` | 2 | |
| `DINOProjectionHead` | Configurable | Has `freeze_last_layer()` / `cancel_last_layer_gradients()` for the teacher weight normalisation trick |
| `DINOv2ProjectionHead` | Configurable | Gated last layer |
| `LeJEPAProjectionHead` | Configurable | For the local→global mapping |
| `SwaVProjectionHead` + `SwaVPrototypes` | Separate MLP + prototype matrix | |
| `SMoGProjectionHead` + `SMoGPredictionHead` + `SMoGPrototypes` | | |

`AIMPredictionHead` lives in `heads_timm.py` and requires timm.

#### Masked Vision Transformers

`MaskedVisionTransformer` (abstract, `masked_vision_transformer.py`) defines the interface used by MAE, I-JEPA, and LeJEPA:

- `preprocess(images, idx_mask, idx_keep)` — patchify, add positional embeddings, apply mask or keep subset
- `encode(images, idx_mask, idx_keep)` — run the transformer on the (masked) tokens
- `forward_intermediates(images, ...)` — return layer-by-layer activations

Three concrete implementations:
- `MaskedVisionTransformerTorchvision` — wraps torchvision ViT (requires torchvision ≥ 0.12)
- `MaskedVisionTransformerTIMM` — wraps timm ViT (requires timm ≥ 0.9.9)
- `MaskedCausalVisionTransformer` — causal attention variant for AIM

Masking can be specified three ways: `idx_mask` (indices to zero out), boolean `mask`, or `idx_keep` (indices to retain). The `preprocess()` method handles all three.

#### I-JEPA predictor (`ijepa.py`, `ijepa_timm.py`)

`IJEPAPredictor` takes already-encoded context tokens and predicts the embeddings of masked target tokens. Distinct from MAE's pixel-space decoder: it predicts in embedding space.

- `predictor_embed` maps context tokens to `predictor_embed_dim`
- `mask_token` is a learnable parameter (gradient flows through it)
- Positional embeddings are 2D sinusoidal (from `utils.get_2d_sincos_pos_embed`)
- `IJEPAPredictor.from_vit_encoder()` class method initialises from a torchvision ViT encoder

#### Memory and nearest-neighbour modules

- `NNMemoryBankModule` (`nn_memory_bank.py`) — extends `MemoryBankModule`; returns the nearest neighbour from the bank for each query, used by NNCLR.
- `CenterModule` (`center.py`) — maintains a running mean for teacher centering (used internally by `DINOLoss`).

### `transforms/`

Each SSL method has a dedicated transform class that subclasses `MultiViewTransform`.

`MultiViewTransform` is a simple container:

```python
def __call__(self, image):
    return [t(image) for t in self.transforms]
```

Returning a list of tensors from a single image is the universal contract. The dataloader's batch will then be a list of `(B, C, H, W)` tensors, one per view.

**`DINOTransform`** is the most complex example:
- 2 global crops: `crop_size=224`, `scale=(0.4, 1.0)`, Gaussian blur prob = 1.0
- 6 local crops: `crop_size=96`, `scale=(0.05, 0.4)`, Gaussian blur prob = 0.5
- Shared augmentations: colour jitter, grayscale, solarisation, horizontal flip
- Gaussian blur uses a (kernel_size, sigma_min, sigma_max) triple

Other notable transforms:
- `MAETransform` — generates a random token mask alongside the image
- `IBOTTransform` — similar to DINO but with patch masking
- `IJEPATransform` — produces images; masking is handled separately by `IJEPAMaskCollator`
- `MultiViewTransformV2` — torchvision v2-compatible variant
- Frequency-domain transforms (`RFFt2dTransform`, `IRFFt2dTransform`, `RandomFrequencyMaskTransform`, `AmplitudeRescaleTransform`, `PhaseShiftTransform`) — for frequency-space augmentation research

Shared augmentation primitives: `GaussianBlur`, `RandomSolarization`, `random_rotation_transform`, `ImageGridTransform`, `AddGridTransform`.

### `data/`

**`LightlyDataset`** — the primary dataset class. Wraps either a local image folder or an existing `torch.utils.data.Dataset`.

- `__getitem__` returns `(sample, target, filename)` — the filename is important for the platform integration
- `from_torch_dataset(dataset)` class method wraps CIFAR10 etc.
- Supports ImageNet-style subfolder layout and video files (requires `av`)
- `get_filenames()` and `dump()` for export

**Collate functions** — these are being deprecated in favour of applying transforms directly in the dataset. They exist for backwards compatibility and for mask-generating workflows:

- `BaseCollateFunction` — applies transform to each sample, returns `(list_of_view_batches, labels, filenames)`
- Method-specific subclasses: `SimCLRCollateFunction`, `DINOCollateFunction`, `MoCoCollateFunction`, `SwaVCollateFunction`, `MAECollateFunction`, `MSNCollateFunction`, `VICRegLCollateFunction`, `MultiCropCollateFunction`
- `IJEPAMaskCollator` — the modern pattern for mask-based methods; generates context and target masks per sample, decoupled from the image transform. Returns `(images, masks_enc, masks_pred)`.

`IMAGENET_NORMALIZE` dict (`{"mean": [0.485, 0.456, 0.406], "std": [0.229, 0.224, 0.225]}`) is defined here and imported throughout.

### `utils/`

#### Benchmarking (`utils/benchmarking/`)

PyTorch Lightning modules for standard SSL evaluation protocols:

| Class | Protocol |
|---|---|
| `KNNClassifier` | k-NN on frozen features, no gradient |
| `LinearClassifier` | Linear probe on frozen backbone |
| `FinetuneClassifier` | End-to-end fine-tuning |
| `OnlineLinearClassifier` | Trains a linear head concurrently with SSL pretraining |
| `BenchmarkModule` | Base Lightning module used by the benchmark scripts |
| `MetricCallback` | Lightning callback that logs top-1/top-5 accuracy |

#### Other utilities

- **`dependency.py`** — gates optional features: `torchvision_vit_available()` (≥ 0.12), `timm_vit_available()` (timm ≥ 0.9.9, checks for `LayerType`), `torchvision_transforms_v2_available()`.
- **`dist.py`** — distributed helpers: `gather()`, `eye_rank()` (diagonal mask per rank), `rank()`, `world_size()`.
- **`lars.py`** — LARS optimiser (Layer-wise Adaptive Rate Scaling), used in ImageNet benchmarks.
- **`scheduler.py`** — `CosineWarmupScheduler`: cosine decay with a linear warmup phase.
- **`io.py`** — read/write embeddings as CSV (`embedding_0`, `embedding_1`, ..., `label`).
- **`version_compare.py`** — semantic version comparison utility.

### `api/`

REST client for the Lightly web platform. Entry point is `ApiWorkflowClient`, which mixes in ~25 workflow modules covering:

- Dataset CRUD (`api_workflow_datasets.py`)
- Embedding upload/download (`api_workflow_upload_embeddings.py`)
- Datasource configuration (`api_workflow_datasources.py`)
- Active learning selection (`api_workflow_selection.py`)
- Tag management (`api_workflow_tags.py`)
- Compute worker management (`api_workflow_compute_worker.py`)
- Prediction upload (`api_workflow_predictions.py`)
- `bitmask.py` — efficient bitset representation of selected sample subsets
- `_version_checking.py` — background thread that checks for newer package versions (throttled to avoid duplicate calls)

The swagger client under `lightly/openapi_generated/` is auto-generated from the platform's OpenAPI spec.

### `cli/`

Hydra-based CLI with YAML config (`cli/config/config.yaml`). Registered entry points:

| Command | Handler | Purpose |
|---|---|---|
| `lightly-ssl-train` | `train_cli` | SSL pretraining |
| `lightly-embed` | `embed_cli` | Generate embeddings |
| `lightly-magic` | `lightly_cli` | Platform dataset curation |
| `lightly-crop` | `crop_cli` | Crop images via bounding boxes |
| `lightly-download` | `download_cli` | Download data from platform |
| `lightly-serve` | `serve_cli` | Inference server |
| `lightly-version` | `version_cli` | Show version |

### `embedding/`

`SelfSupervisedEmbedding` and `BaseEmbedding` — higher-level wrappers around model training for the embedding workflow. Tightly coupled to the CLI and platform API.

### `active_learning/`

Deprecated. Now redirects users to the Lightly Worker Solution. The config stubs remain for backwards compatibility.

---

## How the pieces wire together

### Minimal training loop

```python
# 1. Data
dataset = LightlyDataset("path/to/images")
transform = SimCLRTransform(input_size=224)
dataset.transform = transform
loader = DataLoader(dataset, batch_size=256, ...)

# 2. Model
backbone = torchvision.models.resnet50()
backbone.fc = nn.Identity()
head = SimCLRProjectionHead(2048, 2048, 128)

# 3. Loss
criterion = NTXentLoss(temperature=0.07)

# 4. Training
for (x0, x1), _, _ in loader:        # x0, x1: (B, C, H, W)
    z0 = head(backbone(x0).flatten(1))
    z1 = head(backbone(x1).flatten(1))
    loss = criterion(z0, z1)
    loss.backward()
    optimizer.step()
```

### Teacher-student (DINO)

```python
student = nn.Sequential(backbone, DINOProjectionHead(...))
teacher = copy.deepcopy(student)
deactivate_requires_grad(teacher)

criterion = DINOLoss(output_dim=65536, ...)

for views, _, _ in loader:            # views: list of 8 tensors
    teacher_out = [teacher(v) for v in views[:2]]   # global only
    student_out = [student(v) for v in views]        # all views
    loss = criterion(teacher_out, student_out, epoch)
    loss.backward()
    optimizer.step()
    update_momentum(student, teacher, m=momentum)
    criterion.update_center(teacher_out)
```

### Masked prediction (I-JEPA)

```python
# IJEPAMaskCollator generates masks; masking is separate from the image transform
collator = IJEPAMaskCollator(...)
loader = DataLoader(dataset, collate_fn=collator, ...)

for images, masks_enc, masks_pred in loader:
    with torch.no_grad():
        target = teacher.encode(images)          # all tokens
    context = student.forward_context(images, masks_enc)
    predicted = predictor(context, masks_enc, masks_pred)
    loss = F.mse_loss(predicted, target[masks_pred])
```

---

## Supported SSL methods

| Method | Year | Loss | Transform |
|---|---|---|---|
| AIM | 2024 | MSE (reconstruction) | `AIMTransform` |
| Barlow Twins | 2021 | `BarlowTwinsLoss` | `BYOLTransform` |
| BYOL | 2020 | `NegativeCosineSimilarity` | `BYOLTransform` |
| DCL / DCLW | 2021 | `DCLLoss` / `DCLWLoss` | `SimCLRTransform` |
| DenseCL | 2021 | `NTXentLoss` (dense) | `DenseCLTransform` |
| DetConB / DetConS | 2021 | `DetConBLoss` / `DetConSLoss` | `DetConTransform` |
| DINO | 2021 | `DINOLoss` | `DINOTransform` |
| DINOv2 | 2023 | `DINOLoss` + `IBOTPatchLoss` + `KoLeoLoss` | `DINOTransform` |
| iBOT | 2021 | `DINOLoss` + `IBOTPatchLoss` | `IBOTTransform` |
| I-JEPA | 2023 | MSE in embedding space | `IJEPATransform` + `IJEPAMaskCollator` |
| LeJEPA | 2024 | `LeJEPALoss` + `SIGReg` | `IJEPATransform` |
| MAE | 2021 | MSE (pixel reconstruction) | `MAETransform` |
| MoCo | 2019 | `NTXentLoss` + memory bank | `MoCoTransform` |
| MSN | 2022 | `MSNLoss` | `MSNTransform` |
| NNCLR | 2021 | `NTXentLoss` + NN bank | `SimCLRTransform` |
| PMSN | 2022 | `PMSNLoss` | `MSNTransform` |
| SimCLR | 2020 | `NTXentLoss` | `SimCLRTransform` |
| SimMIM | 2022 | MSE (pixel reconstruction) | `SimMIMTransform` |
| SimSiam | 2021 | `NegativeCosineSimilarity` | `SimSiamTransform` |
| SwaV | 2020 | `SwaVLoss` | `SwaVTransform` |
| TiCo | 2022 | `TiCoLoss` | `SimCLRTransform` |
| VICReg | 2021 | `VICRegLoss` | `VICRegTransform` |
| VICRegL | 2022 | `VICRegLLoss` | `VICRegLTransform` |
| WMSE | 2021 | `WMSELoss` | `WMSETransform` |

---

## Benchmarks (`benchmarks/imagenet/`)

Separate directories for `resnet50/` and `vitb16/`, each containing one script per method. Each script is a self-contained PyTorch Lightning `LightningModule` that:

1. Builds backbone + projection head + loss
2. Attaches an `OnlineLinearClassifier` for concurrent evaluation
3. Uses LARS optimiser with weight-decay exclusion for BN/bias parameters
4. Applies `CosineWarmupScheduler` with 10-epoch warmup
5. Applies the linear scaling rule: `lr = base_lr * global_batch_size / 256`

---

## Examples (`examples/`)

Three variants per method:

- `examples/pytorch/` — plain PyTorch, no Lightning (minimal, easiest to read)
- `examples/pytorch_lightning/` — single-GPU Lightning
- `examples/pytorch_lightning_distributed/` — multi-GPU Lightning

Each is a standalone script; no shared library. The PyTorch examples are the canonical reference for understanding how the building blocks assemble.

---

## Testing

Tests live in `tests/`, mirroring the package layout. The suite uses pytest.

**Key conventions:**
- `--runslow` flag gates slow integration tests (marked `@pytest.mark.slow`)
- `conftest.py` mocks `LIGHTLY_DID_VERSION_CHECK` and `LIGHTLY_SERVER_LOCATION` env vars to avoid network calls
- Numerical assertions use `pytest.approx()` for float comparisons
- Distributed training tests use `mocker` to patch `torch.distributed` functions
- Loss tests typically compute the loss manually and compare against the module output

---

## Dependencies

**Required:**
- `torch`, `torchvision`
- `pytorch-lightning >= 1.0.4`
- `hydra-core >= 1.0.0` (CLI)
- `pydantic >= 1.10.5`
- `numpy >= 1.18.1`, `tqdm`, `requests`

**Optional extras:**
- `[timm]` — timm ≥ 0.9.9; unlocks AIM, MAE-TIMM, I-JEPA-TIMM, `MaskedCausalVisionTransformer`
- `[video]` — `av >= 8.0.3`; unlocks video dataset support
- `[matplotlib]` — visualisation utilities
- `[dev]` — ruff, mypy, pytest with xdist/forked/mock for contributors

Optional features are gated at import time via `lightly/utils/dependency.py`; missing extras produce informative errors rather than hard import failures.
