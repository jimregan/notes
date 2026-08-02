# Codebase Summary

This repository implements the experiments from the ACL 2026 paper *[b]=[d]-[t]+[p]: Self-supervised Speech Models Discover Phonological Vector Arithmetic*. It is organized as a collection of executable research scripts rather than an installable Python package.

## Workflow

```text
TIMIT / VoxAngeles
        |
        v
prepare_datasets.py
        |
        v
phone-aligned CSV metadata
        |
        v
extract_features.py
        |
        v
layerwise SSL or spectral embeddings
        |-- estimate_similarity.py --> analogy similarity results
        |-- pcs.py                 --> PCS scores
        `-- analyze_synth.py       --> modified speech measurements
                                              |
                                              v
                                plot_everything.py / plot_synth.py
```

## Main Components

### `prepare_datasets.py`

Converts TIMIT or VoxAngeles alignments into CSV rows containing audio paths, IPA phones, segment times, and dataset splits. TIMIT phones are explicitly mapped to IPA, while VoxAngeles annotations are read from Praat TextGrid files.

### `extract_features.py`

Produces phone-level representations from:

- Hugging Face speech models such as WavLM, HuBERT, and wav2vec 2.0
- MFCC features
- Mel spectrograms

The script can either extract features from a complete utterance and slice the resulting representation, or slice the audio before feature extraction. It supports center, average, or no temporal pooling and stores the resulting DataFrame as a pickle file.

### `estimate_similarity.py`

Runs the main phonological-vector-arithmetic experiment. It:

- Filters rare phones and phones unknown to PanPhon
- Uses PanPhon feature vectors to discover valid analogies such as `a = b + c - d`
- Compares arithmetic similarity with same-phone and different-phone baselines
- Uses repeated Monte Carlo sampling and 99% confidence intervals
- Parallelizes processing across phone analogies

### `pcs.py`

Calculates the Phonological Consistency Score. It groups equivalent phonological contrasts using a union-find structure and measures how well cosine similarity distinguishes corresponding contrast vectors from mismatched ones using ROC AUC.

### `analyze_synth.py`

Performs the synthesis experiments. A phonological direction is defined as the difference between the mean embeddings of phones with positive and negative values for a selected PanPhon feature. Scaled versions of this direction are added to selected phone frames and resynthesized through a custom Vocos model.

The generated audio is evaluated using measurements including formants, bandwidth, harmonicity, spectral center of gravity, zero-crossing rate, and RMS behavior. Both SSL representations and an MFCC baseline are supported.

### `plot_everything.py`

Generates the publication figures. It compares:

- Models and representation layers
- TIMIT and VoxAngeles
- Feature slicing and audio slicing
- Consonants and vowels
- SSL models and spectral baselines
- Synthesis effects
- Phonological Consistency Scores

### `plot_synth.py`

Generates the demonstration audio and spectrograms stored in `examples/`.

## Data Conventions

Most intermediate files are expected under an uncommitted `feats/` directory:

| Artifact | Naming convention |
| --- | --- |
| Dataset metadata | `feats/{dataset}.csv` |
| Embeddings | `feats/{dataset}-{model}-{layer}-{slice}.pkl` |
| Similarity results | `feats/similarities-{dataset}-{model}-{slice}.pkl` |
| PCS results | `feats/pcs-{dataset}-{model}.pkl` |
| Synthesis measurements | CSV names containing the dataset, model, phone class, and feature |

Figures are written under `plots/`. Selected demonstration PNG and WAV files are committed under `examples/`.

## Dependencies and Execution

The documented environment targets Python 3.10. Major dependencies include:

- PyTorch and Transformers
- librosa
- pandas and NumPy
- SciPy and scikit-learn
- PanPhon
- PraatIO and Parselmouth
- Hugging Face Datasets
- tqdm and Matplotlib

Synthesis additionally requires the custom `wavlm` branch of Vocos. GPU acceleration is optional for basic feature extraction but is effectively expected for large-model and synthesis experiments.

## Engineering Notes

- The repository contains approximately 2,000 lines across seven Python scripts.
- There are no automated tests, packaging metadata, lockfile, continuous-integration configuration, or formal dependency file.
- Scripts depend on fixed directory and filename conventions.
- Plot generation assumes that a nearly complete collection of intermediate artifacts has already been produced.
- Several experimental assumptions are hard-coded, including 16 kHz SSL audio, model strides, model layer counts, a 50-example phone cutoff, and exactly 95 VoxAngeles languages.
- Intermediate representations use Python pickle files and should only be loaded from trusted sources.

See `README.md` for installation instructions and example commands for running the complete pipeline.
