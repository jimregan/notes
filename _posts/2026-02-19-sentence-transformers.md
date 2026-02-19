---
title: Sentence Transformers Codebase Reference
toc: true
description: Claude-generated codebase reference
categories: [sentence-transformers, claude]
---

**Version:** 5.3.0.dev0
**Package root:** `sentence_transformers/`

## 1. Top-Level Directory Layout

```
sentence-transformers/
├── sentence_transformers/       # Main package
│   ├── SentenceTransformer.py  # Main model class
│   ├── trainer.py              # SentenceTransformerTrainer
│   ├── training_args.py        # SentenceTransformerTrainingArguments
│   ├── data_collator.py        # SentenceTransformerDataCollator
│   ├── similarity_functions.py # SimilarityFunction enum
│   ├── fit_mixin.py            # Legacy .fit() API
│   ├── sampler.py              # Batch samplers
│   ├── quantization.py         # quantize_embeddings()
│   ├── models/                 # Module subpackage
│   ├── losses/                 # Loss functions
│   ├── evaluation/             # Evaluators
│   └── util/                   # Utility functions
├── tests/
└── examples/
```

**Key optional extras (pyproject.toml):**
- `train`: requires `datasets`, `accelerate>=0.20.3` for `SentenceTransformerTrainer`
- `image`: `Pillow` for CLIP
- `dev`: adds `peft`, `pytest`, etc.

## 2. Architectural Pattern: Pipeline as `nn.Sequential`

`SentenceTransformer` **is** an `nn.Sequential`. Each module receives a `dict[str, Tensor]` features dict and returns the enriched version. The canonical flow is:

```
Transformer → Pooling → [optional modules...]
  sets              sets
  "token_embeddings"  "sentence_embedding"
```

Common keys flowing through the pipeline:
- `"input_ids"`, `"attention_mask"`, `"token_type_ids"` — from tokenization
- `"token_embeddings"` — per-token hidden states, set by `Transformer`
- `"sentence_embedding"` — pooled vector, set by `Pooling`; overwritten by later modules
- `"prompt_length"` — set when prompts are used
- `"all_layer_embeddings"` — set if `output_hidden_states=True`

## 3. `models/` Subpackage — All Modules

| Class | File | Description |
|-------|------|-------------|
| `Module` | `Module.py` | Abstract base class for all modules |
| `InputModule` | `InputModule.py` | Abstract base for tokenizing modules |
| `Transformer` | `Transformer.py` | HuggingFace AutoModel wrapper; backbone |
| `Pooling` | `Pooling.py` | Token-to-sentence pooling (mean/cls/max/weighted/lasttoken) |
| `Dense` | `Dense.py` | FF projection with activation |
| `Normalize` | `Normalize.py` | L2 normalization of `sentence_embedding` |
| `StaticEmbedding` | `StaticEmbedding.py` | EmbeddingBag-based fast static embeddings |
| `WeightedLayerPooling` | `WeightedLayerPooling.py` | Learned weighted combination across transformer layers |
| `CLIPModel` | `CLIPModel.py` | CLIP visual/text encoder |
| `Router` | `Router.py` | Asymmetric query/document routing (see §11) |
| `CNN`, `LSTM`, `BoW`, `WordEmbeddings`, `WordWeights`, `LayerNorm`, `Dropout` | — | Misc / legacy |

## 4. The `Module` Base Class

**File:** `sentence_transformers/models/Module.py`

```python
class Module(ABC, torch.nn.Module):
```

### Class Variables to Declare

```python
config_file_name: str = "config.json"
# JSON file written by save_config() / read by load_config()

config_keys: list[str] = []
# Instance attribute names serialized to config.json by get_config_dict()
# Must match __init__ parameter names exactly

save_in_root: bool = False
# True → saves in model root dir; False → saves in a numbered subdirectory
# Transformer overrides this to True (it writes the HF model files)

forward_kwargs: set[str] = set()
# Extra kwargs from encode() that this module's forward() accepts.
# SentenceTransformer.forward() routes kwargs here by name.
```

### Abstract Methods (must implement)

```python
def forward(self, features: dict[str, Tensor | Any], **kwargs) -> dict[str, Tensor | Any]:
    """Modify and return the features dict."""

def save(self, output_path: str, *args, safe_serialization: bool = True, **kwargs) -> None:
    """Save module to a directory. Typically calls save_config() + save_torch_weights()."""
```

### Provided Utility Methods

```python
# Serialization helpers (all provided by Module)
self.get_config_dict() -> dict          # {k: getattr(self, k) for k in config_keys}
self.save_config(output_path)           # writes config.json
self.save_torch_weights(output_path, safe_serialization=True)
                                        # writes model.safetensors or pytorch_model.bin

# Class methods
cls.load_config(model_name_or_path, subfolder="", ...) -> dict
cls.load_torch_weights(model_name_or_path, ..., model=None) -> Self | state_dict
cls.load(model_name_or_path, subfolder="", ...) -> Self
# Default load(): load_config() → cls(**config). Override if you need weights.
```

### `InputModule` Subclass

Adds a required `tokenize()` method. `Transformer`, `StaticEmbedding`, `Router` extend this.

```python
class InputModule(Module):
    save_in_root: bool = True   # always saves in model root
    tokenizer: PreTrainedTokenizerBase

    @abstractmethod
    def tokenize(self, texts: list[str], **kwargs) -> dict[str, Tensor]: ...

    def save_tokenizer(self, output_path: str, **kwargs) -> None: ...
```

## 5. Writing a Custom Module Subclass

```python
from __future__ import annotations
from typing import Any
import torch
from torch import Tensor
from sentence_transformers.models.Module import Module

class MyModule(Module):
    # 1. Declare which __init__ args map to config.json
    config_keys: list[str] = ["in_dim", "out_dim"]

    # 2. Declare which encode() kwargs to receive in forward()
    forward_kwargs: set[str] = set()   # e.g. {"task"} for Router-aware modules

    def __init__(self, in_dim: int, out_dim: int) -> None:
        super().__init__()
        self.in_dim = in_dim
        self.out_dim = out_dim
        self.proj = torch.nn.Linear(in_dim, out_dim)

    def forward(self, features: dict[str, Tensor], **kwargs) -> dict[str, Tensor]:
        features["sentence_embedding"] = self.proj(features["sentence_embedding"])
        return features

    def get_sentence_embedding_dimension(self) -> int:
        return self.out_dim

    def save(self, output_path: str, *args, safe_serialization: bool = True, **kwargs) -> None:
        self.save_config(output_path)
        self.save_torch_weights(output_path, safe_serialization=safe_serialization)

    @classmethod
    def load(cls, model_name_or_path: str, subfolder: str = "",
             token=None, cache_folder=None, revision=None,
             local_files_only=False, **kwargs) -> "MyModule":
        hub_kwargs = dict(subfolder=subfolder, token=token,
                          cache_folder=cache_folder, revision=revision,
                          local_files_only=local_files_only)
        config = cls.load_config(model_name_or_path=model_name_or_path, **hub_kwargs)
        model = cls(**config)
        model = cls.load_torch_weights(model_name_or_path=model_name_or_path,
                                       model=model, **hub_kwargs)
        return model
```

**Wiring it into a model:**

```python
from sentence_transformers import SentenceTransformer
from sentence_transformers.models import Transformer, Pooling

transformer = Transformer("openai/whisper-large-v3")
pooling = Pooling(transformer.get_word_embedding_dimension(), "mean")
projection = MyModule(1280, 256)

model = SentenceTransformer(modules=[transformer, pooling, projection])
model.save("./my-model")

# Reloads automatically via modules.json:
model2 = SentenceTransformer("./my-model")
```

## 6. Save / Load Protocol

### What `SentenceTransformer.save(path)` writes

1. `modules.json` — ordered list of modules with their class paths and subdirectory paths.
2. `config_sentence_transformers.json` — prompts, similarity function name, version.
3. Per-module, calls `module.save(module_path)`:
   - If `save_in_root=True` (e.g. `Transformer`): saves to model root.
   - Otherwise: saves to `{idx}_{ClassName}/` subdirectory.
4. `README.md` (model card).

### `modules.json` format

```json
[
  {"idx": 0, "name": "0", "path": "",            "type": "sentence_transformers.models.Transformer"},
  {"idx": 1, "name": "1", "path": "1_Pooling",   "type": "sentence_transformers.models.Pooling"},
  {"idx": 2, "name": "2", "path": "2_MyModule",  "type": "my_package.MyModule"}
]
```

- `"type"` is the fully qualified Python import path. Custom local modules use `"filename.ClassName"`.
- `"path"` is relative to the model root. Empty string = root (for `save_in_root=True` modules).

### Loading

`SentenceTransformer(model_name_or_path)` reads `modules.json`, imports each class by dotted path, and calls `ModuleClass.load(module_path, ...)`. If no `modules.json` exists (plain HF model), creates `[Transformer(...), Pooling(dim, "mean")]` automatically.

## 7. `encode()` — Full Signature and Behavior

```python
@torch.inference_mode()
def encode(
    self,
    sentences: str | list[str] | np.ndarray,
    prompt_name: str | None = None,         # key into self.prompts dict
    prompt: str | None = None,              # literal prompt string
    batch_size: int = 32,
    show_progress_bar: bool | None = None,
    output_value: "sentence_embedding" | "token_embeddings" | None = "sentence_embedding",
    precision: "float32" | "int8" | "uint8" | "binary" | "ubinary" = "float32",
    convert_to_numpy: bool = True,
    convert_to_tensor: bool = False,        # overrides convert_to_numpy if True
    device: str | None = None,
    normalize_embeddings: bool = False,
    truncate_dim: int | None = None,        # Matryoshka truncation
    **kwargs,                               # forwarded to modules that declare them in forward_kwargs
) -> np.ndarray | Tensor | list[Tensor] | list[dict[str, Tensor]]
```

### Return types by `output_value`

| `output_value` | `convert_to_numpy` | `convert_to_tensor` | Return type |
|---|---|---|---|
| `"sentence_embedding"` | `True` | `False` | `np.ndarray [N, D]` |
| `"sentence_embedding"` | `False` | `True` | `Tensor [N, D]` |
| `"token_embeddings"` | — | — | `list[Tensor]` (variable len per sentence) |
| `None` | — | — | `list[dict[str, Tensor]]` (all module outputs per sentence) |

**Note:** `output_value=None` is what `MultiAxisSentenceTransformer.encode_axis()` uses to retrieve named axis embeddings (`embedding_{axis_name}` keys) from the features dict.

### `forward_kwargs` routing

`encode()` accepts `**kwargs` and validates them against `get_model_kwargs()`. Each kwarg is passed only to modules that declare it in `forward_kwargs`. Unknown kwargs raise `ValueError` (except `"task"`, which is always allowed).

```python
class MyModule(Module):
    forward_kwargs = {"task"}   # this module will receive 'task' from encode()
```

### Variants

```python
model.encode_query(sentences, ...)    # sets task="query", uses "query" prompt
model.encode_document(sentences, ...) # sets task="document", uses "document"/"passage" prompt
```

## 8. `similarity()` and `similarity_pairwise()`

```python
model.similarity(a, b)           # [N, D] × [M, D] → [N, M] Tensor (cross-product)
model.similarity_pairwise(a, b)  # [N, D] × [N, D] → [N] Tensor (diagonal only)
model.similarity_fn_name         # "cosine" | "dot" | "euclidean" | "manhattan"
```

`SimilarityFunction` enum maps to utility functions in `sentence_transformers.util`:
- `"cosine"` → `cos_sim` / `pairwise_cos_sim`
- `"dot"` → `dot_score` / `pairwise_dot_score`
- `"euclidean"` → `euclidean_sim` / `pairwise_euclidean_sim`
- `"manhattan"` → `manhattan_sim` / `pairwise_manhattan_sim`

## 9. Evaluator Interface

**File:** `sentence_transformers/evaluation/SentenceEvaluator.py`

```python
class SentenceEvaluator:
    greater_is_better: bool = True     # for checkpoint selection
    primary_metric: str | None = None  # required if __call__ returns a dict

    def __call__(
        self,
        model: SentenceTransformer,
        output_path: str | None = None,
        epoch: int = -1,    # -1 = test set evaluation
        steps: int = -1,    # -1 = end of epoch
    ) -> float | dict[str, float]: ...

    # Helpers
    def prefix_name_to_metrics(self, metrics: dict, name: str) -> dict:
        # Prefixes all keys with "{name}_"; also updates self.primary_metric

    def store_metrics_in_model_card_data(self, model, metrics, epoch=0, step=0): ...
    def embed_inputs(self, model, sentences, **kwargs): ...  # delegates to model.encode
```

### Minimal custom evaluator

```python
from sentence_transformers.evaluation import SentenceEvaluator

class MyAxisEvaluator(SentenceEvaluator):
    def __init__(self, queries, corpus, relevant_docs, name=""):
        super().__init__()
        self.queries = queries
        self.corpus = corpus
        self.relevant_docs = relevant_docs
        self.name = name
        self.primary_metric = "recall@10"
        self.greater_is_better = True

    def __call__(self, model, output_path=None, epoch=-1, steps=-1):
        # encode, compute metrics ...
        metrics = {"recall@10": 0.75, "map@10": 0.62}
        metrics = self.prefix_name_to_metrics(metrics, self.name)
        self.store_metrics_in_model_card_data(model, metrics, epoch, steps)
        return metrics
```

### `InformationRetrievalEvaluator`

The main built-in IR evaluator. Takes dicts of `{id: text}` for queries/corpus and `{qid: set[cid]}` for relevance judgments.

```python
from sentence_transformers.evaluation import InformationRetrievalEvaluator

evaluator = InformationRetrievalEvaluator(
    queries={"q1": "text..."},
    corpus={"d1": "text...", "d2": "text..."},
    relevant_docs={"q1": {"d1"}},
    ndcg_at_k=[1, 5, 10],
    recall_at_k=[5, 10],          # Note: called precision_recall_at_k in constructor
    map_at_k=[100],
    name="my-eval",
    write_csv=True,
)
# Returns dict like {"my-eval_cosine_ndcg@10": 0.82, ...}
# primary_metric = "my-eval_{best_fn}_ndcg@{max(ndcg_at_k)}"
```

**Important for multi-correct-answer scenarios:** `InformationRetrievalEvaluator` already supports multiple relevant docs per query (the `relevant_docs` arg is `dict[str, set[str]]`). MSEB adaptation is mainly needed for custom metric weighting or axis-specific score aggregation.

### All Evaluator Classes

| Class | Purpose |
|-------|---------|
| `SentenceEvaluator` | Abstract base |
| `InformationRetrievalEvaluator` | MRR, NDCG, Accuracy, Precision, Recall, MAP |
| `EmbeddingSimilarityEvaluator` | Pearson/Spearman correlation vs. gold similarity scores |
| `BinaryClassificationEvaluator` | Accuracy, F1, AP for binary classification |
| `TripletEvaluator` | Triplet accuracy (anchor closer to positive than negative) |
| `ParaphraseMiningEvaluator` | Finds paraphrase pairs by similarity |
| `RerankingEvaluator` | MAP for reranking |
| `TranslationEvaluator` | Cross-lingual alignment quality |
| `MSEEvaluator` | MSE between embeddings and targets |
| `NanoBEIREvaluator` | Evaluates on nano-BEIR benchmark |
| `SequentialEvaluator` | Runs a list of evaluators; combines metrics |

## 10. Loss Interface

All losses share this structure:

```python
class SomeLoss(nn.Module):
    def __init__(self, model: SentenceTransformer, ...):
        self.model = model   # losses hold a reference to the model

    def forward(
        self,
        sentence_features: Iterable[dict[str, Tensor]],  # list of per-sentence feature dicts
        labels: Tensor,                                   # may be None for some losses
    ) -> Tensor:
        # Typical pattern:
        embeddings = [self.model(f)["sentence_embedding"] for f in sentence_features]
        ...
```

### Key Losses for This Project

| Loss | When to use |
|------|-------------|
| `MultipleNegativesRankingLoss` | (anchor, positive) pairs; in-batch InfoNCE; good for content/speaker axes |
| `CachedMultipleNegativesRankingLoss` | Same with gradient caching for large effective batch size |
| `CoSENTLoss` | (a, b, score) pairs; default trainer loss |
| `TripletLoss` | Explicit (anchor, positive, negative) triplets |
| `ContrastiveLoss` | (a, b, label) pairs with explicit 0/1 labels |

## 11. `Router` Module (Asymmetric Query/Document)

```python
from sentence_transformers.models import Router

router = Router.for_query_document(
    query_modules=[Transformer("model-a"), Pooling(dim)],
    document_modules=[Transformer("model-b"), Pooling(dim)],
)
```

`Router` declares `forward_kwargs = {"task"}`. It receives `task` from `encode()` (or `"query"` / `"document"` from `encode_query()` / `encode_document()`), selects the corresponding sub-module list, and runs input through it. Requires `router_mapping` to be set in `SentenceTransformerTrainingArguments` during training.

## 12. `SentenceTransformerTrainer`

```python
from sentence_transformers import SentenceTransformerTrainer, SentenceTransformerTrainingArguments

args = SentenceTransformerTrainingArguments(
    output_dir="./output",
    num_train_epochs=3,
    per_device_train_batch_size=16,
    batch_sampler=BatchSamplers.NO_DUPLICATES,  # recommended for in-batch negatives losses
)

trainer = SentenceTransformerTrainer(
    model=model,
    args=args,
    train_dataset=train_ds,          # HF Dataset with text columns + optional label column
    eval_dataset=eval_ds,
    loss=MultipleNegativesRankingLoss(model),
    evaluator=my_evaluator,          # called after eval_dataset loop each eval step
)
trainer.train()
```

**Data flow in training:**

```
HF Dataset columns → SentenceTransformerDataCollator.__call__()
  → prefixed tokenized dict (e.g. "anchor_input_ids", "positive_input_ids")
  → collect_features()
  → list of per-sentence feature dicts
  → loss.forward(features, labels)
```

Text columns are auto-detected by the collator. Column names become the sentence prefixes. Label columns are detected from `["label", "labels", "score", "scores"]`.

### `SentenceTransformerTrainingArguments` Extra Fields

```python
batch_sampler: BatchSamplers.BATCH_SAMPLER        # default
             | BatchSamplers.NO_DUPLICATES         # for in-batch negatives
             | BatchSamplers.GROUP_BY_LABEL        # for triplet losses

multi_dataset_batch_sampler: MultiDatasetBatchSamplers.PROPORTIONAL  # default
                            | MultiDatasetBatchSamplers.ROUND_ROBIN

prompts: dict[str, str] | dict[str, dict[str, str]] | None
router_mapping: dict[str, str] | None
```

## 13. `Transformer` Module — Key Details

```python
from sentence_transformers.models import Transformer

t = Transformer(
    model_name_or_path="openai/whisper-large-v3",
    max_seq_length=None,
    do_lower_case=False,
    backend="torch",           # "torch" | "onnx" | "openvino"
)
# t.auto_model  → the HuggingFace model
# t.tokenizer   → the HuggingFace tokenizer
# t.get_word_embedding_dimension() → hidden size

# forward() sets:
#   features["token_embeddings"] = last_hidden_state  # [B, T, H]
#   features["all_layer_embeddings"] = all hidden states (if output_hidden_states=True)

# tokenize() supports:
#   list[str], list[dict], list[tuple[str, str]]  (text pairs)
```

`config_file_name = "sentence_bert_config.json"` (not `config.json`).
`config_keys = ["max_seq_length", "do_lower_case"]`.
`save_in_root = True` — saves HF model files to model root.

## 14. `Pooling` Module — Key Details

```python
from sentence_transformers.models import Pooling

pooling = Pooling(
    word_embedding_dimension=1280,
    pooling_mode="mean",        # shortcut: "cls" | "lasttoken" | "max" | "mean" | "mean_sqrt_len_tokens" | "weightedmean"
    include_prompt=True,        # set False for INSTRUCTOR-style models
)
# pooling.get_sentence_embedding_dimension() → word_embedding_dimension × num_active_modes
```

`forward()` reads `features["token_embeddings"]` + `features["attention_mask"]`, optionally `features["prompt_length"]`, and writes `features["sentence_embedding"]`.

## 15. Key Utility Functions (`sentence_transformers.util`)

```python
from sentence_transformers import util

util.cos_sim(a, b)               # [N, D] × [M, D] → [N, M] cosine similarity
util.dot_score(a, b)             # dot product
util.semantic_search(query_embeddings, corpus_embeddings, top_k=5)
                                 # returns list of list of {"corpus_id": int, "score": float}
util.paraphrase_mining(model, sentences, top_k=10)
util.batch_to_device(batch, target_device)
util.load_file_path(model_name_or_path, filename, ...)
```

