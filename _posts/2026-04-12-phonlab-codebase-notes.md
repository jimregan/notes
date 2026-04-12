# Phonlab Codebase Overview

## Overview

`phonlab` is a general-purpose phonetics toolkit implemented in Python. It is organized as a collection of reusable functions for acoustic phonetics, auditory phonetics, articulatory phonetics, audio preparation, TextGrid handling, and corpus-oriented data wrangling. The package is designed more as a research utility library than as a single application: users import individual functions into notebooks, scripts, or analysis pipelines rather than working through one central command-line interface.

At the top level, the project exposes a flattened public API through `phonlab/__init__.py` and `phonlab/__init__.pyi`. The actual implementations live in subpackages such as `phonlab.acoustic`, `phonlab.auditory`, `phonlab.artic`, and `phonlab.utils`, but the intended usage pattern is generally:

```python
import phonlab as phon
```

and then calling functions like `phon.track_formants()`, `phon.get_f0()`, `phon.tg_to_df()`, or `phon.prep_audio()`.

## High-Level Structure

### `phonlab/`

This is the main package. The top-level `__init__.py` is minimal and uses `lazy_loader` to attach the public API lazily. The `__init__.pyi` stub file is the real map of the exported surface. It enumerates the functions and classes intended to be public and groups them conceptually by submodule.

### `phonlab/acoustic/`

This is the largest and most central part of the codebase. It contains functions for acoustic analysis of speech, including:

- waveform and spectrogram display
- amplitude envelope and intensity-related measures
- pitch tracking
- formant tracking
- voice-quality measures
- consonant measurements
- rhythm analysis
- cepstral analysis

Examples of key modules:

- `track_formants_.py`: high-level formant tracking
- `rlpc.py`, `tvlp.py`, `DPPT.py`: alternative formant-estimation methods
- `get_f0_.py`, `shs.py`: pitch estimation functions
- `get_HNR.py`, `h2h1_.py`, `cepstral.py`, `lpc_residual.py`: voice-quality and cepstral measures
- `fric_meas.py`, `burst_detect.py`, `nasality_measures.py`: consonant and resonance-related analysis
- `tidypraat.py`: conversion of analysis outputs into tidy `pandas` dataframes

This directory suggests that the package is built around a mix of direct signal-processing implementations and wrappers or adapters around established phonetic-analysis workflows.

### `phonlab/auditory/`

This subpackage focuses on auditory and perceptual representations or manipulations of sound. It includes:

- mel spectrogram and auditory-scale representations
- sinewave synthesis
- noise vocoding
- noise addition and signal-in-noise utilities

Examples:

- `mel_sgram.py`
- `noise_vocoder.py`
- `sinewave_synth.py`
- `audspec.py`

These modules are oriented toward auditory phonetics and speech-perception experiments.

### `phonlab/artic/`

This is a smaller subpackage focused on articulatory-style measurement from instrumental signals. In the current checkout, the main file is:

- `egg2oq_.py`: extraction of glottal open quotient and related measures from electroglottography signals

This part of the codebase is narrower in scope than the acoustic and auditory sections.

### `phonlab/utils/`

This subpackage provides the infrastructure that supports the rest of the toolkit. It includes:

- audio loading and preparation
- TextGrid and subtitle handling
- dataframe reshaping and tier manipulation
- plotting helpers
- test-signal generation

Examples:

- `signal.py`: audio loading, built around `librosa.load`
- `prep_audio_.py`: resampling, pre-emphasis, scaling, padding
- `tidy.py`: TextGrid/DataFrame conversion and interval/tier manipulation
- `plot_tiers.py`: plotting aligned annotation tiers

The `utils` package is important because many higher-level acoustic functions depend on it for preprocessing and annotation integration.

### `phonlab/third_party/`

This currently contains vendored support code, such as `robustsmoothing.py`, which is re-exported at the top level as `smoothn`.

### `phonlab/data/`

This package data directory contains bundled example audio, noise files, and small resources used in examples and documentation. The example audio includes WAV files and TextGrids, which makes the package relatively self-contained for demonstrations and teaching.

## Public API Design

The public API is intentionally flat. Rather than asking users to import deeply from submodules, the package exports functions at the top level. This is convenient for notebook-driven research workflows and teaching materials, but it also means the public surface is large and manually curated.

The `__init__.pyi` file is effectively the API registry. It serves several roles at once:

- defines the exported names
- documents how new functions are added to the package
- keeps the lazy-loaded top-level namespace coherent

This is a deliberate design choice: the package treats discoverability and direct function access as more important than strict submodule boundaries.

## Documentation and Examples

The project includes a conventional Sphinx documentation tree under `docs/source/`. The documentation is organized by research task rather than by implementation detail:

- `prep_audio.rst`
- `acoustphon.rst`
- `articphon.rst`
- `audphon.rst`
- `textgrids.rst`
- `corpora.rst`
- `util.rst`

This reinforces the package’s orientation toward applied phonetics workflows.

The `examples/` directory is substantial and includes notebooks and scripts for:

- visualizing audio
- acoustic measurements
- TextGrid processing
- formant tracking
- fricative measurement
- vowel analysis
- Praat-equivalent workflows

The examples are important to understanding the package because they show intended usage patterns more clearly than the README does.

## Testing and Validation Material

There is a `test/` directory, but it is not structured as a conventional automated test suite. It contains notebooks, audio fixtures, CSV data, and a small Python script. This suggests the project relies more on example-driven validation and exploratory testing than on a formal unit/integration test harness.

## Dependency Profile

The project depends on a typical scientific Python stack:

- `numpy`
- `scipy`
- `pandas`
- `matplotlib`
- `scikit-learn`
- `numba`
- `librosa`
- `nitime`

It also depends on:

- `praat-parselmouth`
- `srt`
- `colorednoise`

This dependency set shows that the package combines:

- direct Python signal processing
- machine-learning-oriented helpers
- Praat integration where useful
- dataframe-based annotation workflows

## Architectural Character

The codebase has the feel of a research toolkit that has grown around practical phonetics problems. Its structure is functional rather than object-oriented, with many stand-alone analysis functions that return arrays or `pandas` dataframes. The package emphasizes:

- direct access to algorithms
- tidy tabular outputs
- interoperability with annotations such as TextGrids
- examples and teaching-oriented documentation

It is not organized as a pipeline framework or plugin system. Instead, it provides a broad toolbox from which users can assemble their own workflows.

## Likely Entry Points for New Readers

For a first pass through the codebase, the most useful files are:

- `phonlab/__init__.pyi`: overview of the public API
- `docs/source/index.rst`: conceptual map of the package
- `phonlab/utils/prep_audio_.py`: core audio preprocessing
- `phonlab/utils/tidy.py`: annotation and TextGrid interoperability
- `phonlab/acoustic/track_formants_.py`: representative high-level acoustic analysis
- `phonlab/acoustic/get_f0_.py`: representative pitch-analysis entry point
- `examples/`: intended usage patterns in practice

## Summary

`phonlab` is a broad phonetics utility library centered on reusable analysis functions rather than a single end-user application. Its main strengths are the breadth of acoustic and auditory analysis routines, integration with annotations and dataframes, and extensive example material. The overall architecture favors a large flattened public API backed by subpackages that are organized around phonetics tasks rather than strict software layering.
