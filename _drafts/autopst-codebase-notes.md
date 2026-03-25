---
toc: false
layout: post
hidden: true
description: AutoPST codebase notes
title: Codebase summary from Claude
categories: [autopst, claude]
---

# AutoPST Codebase Notes

**Paper:** "Global Rhythm Style Transfer Without Text Transcriptions"
Kaizhi Qian, Yang Zhang, Shiyu Chang, Jinjun Xiong, Chuang Gan, David Cox, Mark Hasegawa-Johnson
ICML 2021 (arXiv:2106.08519v1)

---

## What this paper does

Most voice/emotion style transfer systems convert timbre but leave rhythm untouched. The paper argues (§3.1) that rhythm — the number of frame-repetitions per phone — is the hard part to disentangle: removing it requires breaking the temporal synchrony between input and representation, which even supervised ASR models using Transformers find difficult (cited: Watanabe et al. 2017; Kim et al. 2017).

The key idea is to treat the code sequence **Z(t)** as something to be randomly resampled — either compressed (fewer codes than frames, §4.2) or expanded (more codes, §4.4) — so that whatever rhythm information remains in **Z̃(t)** cannot be usefully decoded. The decoder is then trained to reconstruct the spectrogram conditioned on a **domain ID** (speaker identity), so it must learn to generate the target speaker's natural rhythm from the compressed codes.

The full system is:

```
MFCC C(t) → Enc → Z(t) → Res → Z̃(t) → Dec(D) → Ŝ(t) ≈ X(t)
```

(Paper Figure 2, §4.1, eq. 4)

---

## Files and what they do

### Feature extraction / data prep

**`prepare_train_data.py`**
Offline preprocessing script, not called during training. Iterates the VCTK directory tree and for each wav file:

1. High-pass filters at 30 Hz (`butter_highpass` in `utils.py`)
2. Computes STFT → 80-band log mel spectrogram (`pySTFT` + librosa mel basis, 16 kHz, FFT 1024, hop 256)
3. Normalises to `[0,1]`: `S = (D_db + 80) / 100`
4. Computes normalised MFCCs from the mel spectrogram via a precomputed DCT matrix (`dctmx`) and saved z-score statistics (`mfcc_stats.pkl`)
5. Runs the pretrained SEA encoder (`model_sea.Generator`) on the first 20 MFCC dimensions to produce **teacher codes** — a 4-dimensional frame-level representation (see `hparams_sea.py`: `dim_neck_sea=8`, but AutoPST uses `dim_neck_sea=4` in `hparams_autopst.py`)
6. Saves three `.npy` files per utterance: mel spectrogram, full normalised MFCCs (all dims), teacher codes

The metadata pickle (`train_vctk.meta`) is a list-of-lists: `[speaker_id, speaker_embedding, file1.npy, file2.npy, ...]` per speaker.

**Why MFCC not mel?** §4.1 notes that MFCC has "little pitch information", which is intentional — the encoder should not encode pitch.

---

### The SEA encoder (`model_sea.py`)

The Self-Expressing Autoencoder (SEA) is from Bhati et al. (2020), modified to use similarity-based downsampling. It appears here only in two roles:

1. **Pretrained feature extractor** — `Generator.encode()` is called in `prepare_train_data.py` to produce teacher codes saved to disk
2. **The online encoder** — `Encoder_2` (imported as `Encoder_Code_2` in `model_autopst.py`) is the actual encoder inside the Generator models

**`Encoder` (kernel_size=1)** vs **`Encoder_2` (kernel_size=5)**
`Encoder` uses pointwise 1×1 convolutions; `Encoder_2` uses 5-wide convolutions (padding=2, same-length output). AutoPST uses `Encoder_2`, which has a wider receptive field and no final ReLU on the last layer (contrast lines 113-114 vs 234-238 in `model_sea.py`). This is the live encoder in both training stages.

**`GroupNorm_Mask`** (`model_sea.py:11-47`)
Standard PyTorch `GroupNorm` does not respect padding. This custom version applies the boolean mask before computing mean and variance, so that padded frames do not contaminate the statistics. The mean is computed as a sum over valid positions divided by the count of valid positions, and likewise for variance.

**`M43_Sequential`** (`model_sea.py:51-55`)
A minimal subclass of `nn.Sequential` that passes a `mask` argument through to the `GroupNorm_Mask` module in position 1. The `ConvNorm` in position 0 does not receive the mask (it is just a 1D conv), but the normalisation that follows it does.

The architecture is 5 layers of (ConvNorm → GroupNorm_Mask → ReLU), followed by two downprojection layers (512→128→32), and a final projection to `dim_neck_sea=4`. The result is a 4-dimensional frame-aligned code sequence. This is the **information bottleneck** described in §4.1 / §5.1 ("encoder output dimension is set to four").

---

### The resampling module (`data_loader.py:segment_np`)

This is the core novelty of the paper (§4.2–4.5). It is implemented **in the data loader, not the model** — resampling is done in NumPy on the CPU at batch construction time, not as a differentiable operation.

**`Utterances.segment_np`** (`data_loader.py:69-109`):

```python
def segment_np(self, cd_long, tau=2):
    # Build Gram matrix G of cosine similarities
    cd_norm = np.sqrt((cd_long ** 2).sum(axis=-1, keepdims=True))
    G = (cd_long @ cd_long.T) / (cd_norm @ cd_norm.T)
    ...
    rate = np.random.uniform(0.8, 1.3)     # global G ~ U[u_l, u_r], paper eq. 8
    for t in range(1, L+1):
        q = np.random.uniform(rate-0.1, rate)  # local L(t) ~ U[G-0.05, G+0.05]
        epsilon = np.quantile(tmp, q)           # threshold τ(t), paper eq. 8
        if q <= 1:  # downsampling case, paper §4.2
            if np.all(G[prev_boundary, t:t+tau] < epsilon):
                # new segment boundary
                num_rep.append(t - prev_boundary)
                ...
        else:       # upsampling case, paper §4.4
            if np.all(G[prev_boundary, t:t+tau] < epsilon):
                num_rep.append(t - prev_boundary)     # normal segment
            else:
                num_rep.extend([t-prev_boundary-0.5, 0.5])  # insert empty segment
```

The function returns two arrays:

- **`num_rep`** — the resampled segment lengths, including the 0.5-weight empty segments for the upsampling case (eq. 10)
- **`num_rep_sync`** — the segment lengths with no empty insertions (used only in Stage 1)

**How `tau` works** (paper eq. 6): the boundary condition requires that *all* frames in `[t, t+tau)` are below the threshold. With `tau=2` (hardcoded), a new segment starts only if both the current frame and the next have dropped in similarity. This prevents spurious boundaries in transiently dissimilar frames.

**The double randomisation** (paper §4.3):
- `rate ~ U[0.8, 1.3]` is the global threshold percentile, shared across all frames in the utterance. This obscures the global speech rate.
- `q ~ U[rate-0.1, rate]` is the per-frame perturbation. This obscures local fine-grained rhythm patterns.

The two cases (`q <= 1` → downsample, `q > 1` → upsample) directly implement §4.2 and §4.4. The `0.5` in `num_rep.extend([t-prev_boundary-0.5, 0.5])` is the empty-segment encoding: at mean-pooling time, this 0.5-weight segment gets merged with the previous real code to produce the duplicate (eq. 10).

---

### Filter-bank mean pooling (`utils.py:filter_bank_mean`)

```python
def filter_bank_mean(num_rep, codes_mask, max_len_long):
```

This converts the variable-length `num_rep` array into a differentiable `(B, L_short, L_long)` mean-pooling matrix so that `torch.bmm(fb, cd_long)` produces the compressed code sequence `Z̃(m)` (paper eq. 7).

The implementation uses cumulative sums to compute left and right edges for each segment, then builds a binary mask of which long-sequence positions fall inside each segment. The `torch.min(lower, upper)` triangular construction is a relic — the immediately following line `fb = (fb > 0).float()` discards the triangular weights and makes it a simple mean pool. So effectively:

```
Z̃(m) = mean( Z(t_m : t_{m+1}) )   # eq. 7
```

In the upsampling case, the 0.5-weight empty segment means the empty segment has zero span and the mean pool returns a copy of the adjacent code — implementing eq. 10 without special-casing.

---

### The AutoPST model (`model_autopst.py`)

#### `Prenet` (lines 20-41)
A linear projection followed by sinusoidal positional encoding (`onmt_modules/embeddings.py`). Used as the embedding layer for both encoder and decoder inputs. The `step` parameter threads through to the positional encoding for autoregressive inference.

#### `Encoder_Tx_Spk` (lines 74-91)
The "text" encoder (called "text" because it encodes the code sequence, which plays the role of phoneme tokens in a TTS system). It concatenates the speaker embedding to each code frame before projecting and feeding to the Transformer encoder:

```python
spk_emb = spk_emb.unsqueeze(0).expand(src.size(0), -1, -1)
src_spk = torch.cat((src, spk_emb), dim=-1)
```

Input dimension: `dim_code + dim_spk = 4 + 82 = 86`. This is then projected to `enc_rnn_size=256` by the Prenet MLP. The concatenation implements the domain ID conditioning D mentioned in eq. 4.

#### `Decoder_Sp` (lines 45-70)
The speech decoder. Takes a shifted target spectrogram (teacher-forced during training), attends to the encoder memory, and outputs `dim_freq + 1 = 81` values: one gate logit plus 80 mel bins. The split is `spect, gate = spect_gate[:,:,1:], spect_gate[:,:,:1]`.

#### `Generator_1` — synchronous stage (lines 130-200)

This implements **Figure 5(a)** of the paper. The key method is `pad_sequences_rnn` (lines 145-155):

```python
def pad_sequences_rnn(self, cd_short, num_rep, len_long):
    for i in range(B):
        code_sync = cd_short[i].repeat_interleave(num_rep[i], dim=0)
        out_tensor[i, :len_long[i]-1, :] = code_sync
```

This is the **re-alignment module** (labelled "Align" in Figure 5a). Each downsampled code `Z̃(m)` is repeated `num_rep_sync[m]` times to re-expand the sequence back to the original length, so the decoder sees a frame-synchronous input. This is Stage 1: the decoder has access to rhythm information (via the alignment), so the encoder is forced to encode content only.

**Stage 1 uses `num_rep_sync`** (the version without empty-segment insertions), not `num_rep`.

In `forward` (lines 158-179):
1. Encode MFCC → codes via `encoder_cd` (Encoder_2)
2. Mean-pool to get `cd_short` via `filter_bank_mean`
3. Re-expand to frame length via `pad_sequences_rnn` → `cd_short_sync`
4. Encode (code, speaker) → Transformer encoder memory
5. Prepend speaker token: `memory_tx_spk = cat([spk_emb_1, memory_tx], dim=0)`
6. Decode spectrogram

The speaker embedding prepended to the memory (step 5) is a single extra token at position 0, giving the decoder a "global style" token to attend to — analogous to a style token in GST-style TTS.

#### `Generator_2` — asynchronous stage (lines 204-257)

This implements **Figure 5(b)**. The differences from `Generator_1` are:

1. No `pad_sequences_rnn` — the decoder gets `cd_short` directly (asynchronous, length `L_short` not `L_long`)
2. `encoder_cd` is frozen in `solver_2.py` (line 37: `self.freeze_layers(self.P.encoder_cd)`)
3. The mean-pool uses `.detach()` on both `fb` and `cd_long`: `cd_short = torch.bmm(fb.detach(), cd_long.detach())`
4. Encoder memory lengths become `len_short+1` not `len_spect+1`

The asynchronous mismatch between encoder sequence length (L_short) and decoder sequence length (L_long) means the Transformer cross-attention must learn to handle non-square attention matrices — the decoder produces ~800 frames while attending to ~100 codes.

The gradient detach on `cd_long` means the encoder receives no gradient signal from the reconstruction loss in Stage 2. This is what "freezes" the encoder effectively — the explicit `freeze_layers` call prevents any updates to it.

---

### Training (`solver_1.py`, `solver_2.py`)

Both solvers share the same loss:

```python
loss_tx2sp = (F.mse_loss(spect_pred, sp_real, reduction='none') * mask).sum() / mask.sum()
loss_stop_sp = BCEWithLogitsLoss(stop_pred_sp, mask_sp_real.float())
loss_total = loss_tx2sp + loss_stop_sp
```

The MSE mask extends 10 frames past the actual utterance length (`len_real + 10`, clipped to tensor length) to include the stop region in the loss. The stop target is the padding mask itself — frames within the utterance are 0 (continue), frames beyond are 1 (stop).

The stop gate uses `BCEWithLogitsLoss` with no weighting, which may be imbalanced (most frames are within the utterance, so most targets are 0). In practice the gate threshold at inference is 0.48 (slightly below 0.5).

**Stage 1** (`solver_1.py`) uses `num_rep_sync` and `len_short_sync` (line 61).
**Stage 2** (`solver_2.py`) uses `num_rep` and `len_short` (line 75) — the version including empty segment weights.

Optimizer: Adam, lr=1e-4, β=(0.9, 0.999). No learning rate schedule. Checkpoints saved every 10,000 iterations (suffix `-A.ckpt` for Stage 1, `-B.ckpt` for Stage 2).

---

### Inference (`fast_decoders.py`, `Generator.infer_onmt`)

Inference uses autoregressive decoding (`DecodeFunc_Sp.infer`, lines 36-74). At each step `t`:

1. Feed `current_pred` (previous output frame, or zeros at t=0) to the decoder
2. Predict next frame and gate
3. Quantise gate: `stop = round(sigmoid(gate) - 0.48 + 0.5)` — this is equivalent to `sigmoid(gate) > 0.48`
4. Feed the gate prediction as `tgt_words` to the decoder on the next step (used by `override_decoder.py` to skip teacher-forcing the stop token)
5. Break when all batch items have stopped

The `tgt_words` mechanism in `override_decoder.py` (`OnmtDecoder_1`) overrides the standard OpenNMT decoder behaviour, which would teacher-force the stop token during training. During inference there is no reference, so the predicted gate value is fed back.

At inference, `Generator_2.infer_onmt` feeds `cd_long` (the full-length code sequence, *not* mean-pooled) directly to the encoder — the resampling is only applied during training. This means inference uses all the available code frames, letting the decoder figure out the rhythm from the codes plus the target speaker embedding.

---

### Transformer modules (`onmt_modules/`)

Adapted from OpenNMT-py. The key configuration used:

| Parameter | Value | Note |
|---|---|---|
| `enc_layers` | 4 | Transformer encoder depth |
| `dec_layers` | 4 | Transformer decoder depth |
| `enc_rnn_size` / `dec_rnn_size` | 256 | Model dimension |
| `transformer_ff` | 1024 | FFN hidden dimension (4× model dim) |
| `heads` | 8 | Attention heads |
| `dropout` | 0.1 | Applied after attention and FFN |
| `max_relative_positions` | 0 | No relative positional encoding |
| `self_attn_type` | `"scaled-dot"` | Standard attention |

The encoder produces a memory bank of shape `(L_src, B, d_model)`. The decoder's cross-attention queries this memory bank. Sequence masking uses `onmt_modules/misc.py:sequence_mask`.

---

## Data flow summary

```
WAV → highpass → STFT → mel 80-band → normalize → S (mel spectrogram)
                                     → DCT → normalize → C (MFCC, 14 dims used)
                                     → SEA encoder → teacher codes Z_teacher

                save S, C, Z_teacher to disk

Training batch:
    C → Encoder_2 (8-layer conv, bottleneck 4-dim) → Z(t)   [L_long × 4]
    Z_teacher + segment_np → num_rep                         [L_short]
    filter_bank_mean(num_rep, Z(t)) → Z̃(m)                  [L_short × 4]

Stage 1:
    pad_sequences_rnn(Z̃, num_rep_sync) → Z'(t)             [L_long × 4]
    Encoder_Tx_Spk(Z'(t), spk_emb) → memory                 [L_long × 256]
    Decoder_Sp(S_shifted, memory) → Ŝ(t), gate              [L_long × 80]
    loss = MSE(Ŝ, S) + BCE(gate, padding_mask)

Stage 2:  [encoder_cd frozen]
    Encoder_Tx_Spk(Z̃(m), spk_emb) → memory                 [L_short × 256]
    Decoder_Sp(S_shifted, memory) → Ŝ(t), gate              [L_long × 80]
    loss = MSE(Ŝ, S) + BCE(gate, padding_mask)
```

---

## Things that could trip you up

**Teacher codes vs. online encoder**: `prepare_train_data.py` saves teacher codes using the SEA `Generator.Encoder` (kernel_size=1), but during training `model_autopst.py` imports `Encoder_2` (kernel_size=5) as its online encoder. These have different architectures. The teacher codes on disk are used in `segment_np` to build the Gram matrix — the segmentation is based on the precomputed codes, not on the codes being learned. The online encoder learns to produce codes suitable for the decoder independently.

**`dim_neck_sea` inconsistency**: `hparams_sea.py` sets `dim_neck_sea=8` but `hparams_autopst.py` sets `dim_neck_sea=4`. The SEA model loaded by `prepare_train_data.py` uses `hparams_sea`, so teacher codes are 8-dimensional. But the `Encoder_2` inside `Generator_1/2` uses `hparams_autopst`, so the online encoder produces 4-dimensional codes. The `segment_np` function in `data_loader.py` operates on `cd_real` loaded from the teacher code files — these have 8 dimensions, not 4. The segmentation quality depends on the 8-dim codes. Only the downstream encoding (Encoder_2) uses 4-dim. This discrepancy is not documented.

**`segment_np` uses the stored teacher codes, not the online encoder output**: the Gram matrix `G` is built from `cd_real` (disk-loaded), not from the forward-pass codes. Gradient does not flow through the segmentation.

**The `num_rep` values are floats** (because of the `0.5` trick for empty segments), but `pad_sequences_rnn` calls `repeat_interleave` which requires integers. `pad_sequences_rnn` is only called in Stage 1, which uses `num_rep_sync` (integer values only). Stage 2 uses `filter_bank_mean` which handles floats via the triangular/mean-pooling construction.

**Inference bypasses resampling entirely**: `infer_onmt` in both `Generator_1` and `Generator_2` passes `cd_long` (full-length encoder output, not mean-pooled) directly to `encoder_tx`. The resampling procedure described at length in §4 is *only active during training*. At inference time the model just encodes the full MFCC sequence and relies on the decoder's learned rhythm-from-domain-ID behaviour.

---

## Connection to paper claims

| Paper claim | Code location |
|---|---|
| §3.1: measure rhythm as frame-aligned phone repetitions | `data_loader.py:segment_np` (counts are `num_rep`) |
| §4.1: MFCC instead of spectrogram to reduce pitch | `data_loader.py:61` (`cep_tmp = np.load(...)[:, 0:14]`), `prepare_train_data.py:69` |
| §4.1: information bottleneck, encoder output dim = 4 | `hparams_autopst.py`: `dim_neck_sea=4` |
| §4.2: similarity-based downsampling (eq. 6, 7) | `data_loader.py:segment_np` q≤1 branch; `utils.py:filter_bank_mean` |
| §4.3: double-randomised thresholding (eq. 8) | `data_loader.py:80-91` (`rate`, `q`) |
| §4.4: upsampling with empty segment insertion (eq. 9, 10) | `data_loader.py:101` (`num_rep.extend([..., 0.5])`) |
| §4.6: Stage 1 synchronous training (Figure 5a) | `model_autopst.py:Generator_1`, `solver_1.py` |
| §4.6: Stage 2 asynchronous, encoder frozen (Figure 5b) | `model_autopst.py:Generator_2`, `solver_2.py:37` |
| §5.1: 8×(1×5) conv encoder with GroupNorm | `model_sea.py:Encoder_2`, `GroupNorm_Mask` |
| §5.1: Transformer decoder, 4 enc + 4 dec layers | `hparams_autopst.py`: `enc_layers=4`, `dec_layers=4` |
| §5.1: WaveNet vocoder | `demo.ipynb` (external, not in this repo) |
| §5.1: VCTK dataset, 109 speakers | `hparams_autopst.py`: `dim_spk=82` (subset used) |
