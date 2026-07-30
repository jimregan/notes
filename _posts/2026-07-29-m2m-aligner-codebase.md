---
title: m2m-aligner codebase overview
layout: post
toc: true
description: Claude-generated codebase overview
categories: [m2m-aligner, claude]
---

# Codebase Overview: m2m-aligner

## What it is

**m2m-aligner** implements a many-to-many alignment EM algorithm (Ristad &
Yianilos 1998 stochastic transducer) for building lexicon alignments — e.g.
letter-to-phoneme alignment for grapheme-to-phoneme conversion,
transliteration, etc. Written by Sittichai Jiampojamarn (U. Alberta),
released as v1.0 in 2010. It's a small, self-contained C++98 research tool
(~1,300 lines of project code plus a bundled TCLAP argument-parsing
library).

## Files

| File | Role |
|---|---|
| `mmAligner.cpp` | `main()` — parses CLI args via TCLAP (`--maxX`, `--maxY`, `--delX/Y`, `--maxFn`, `--nBest`, `--init`, etc.), builds a `param` struct, then either loads a saved model (`--alignerIn`) or trains one (`mmEM::training`), writes it out, and runs `mmEM::createAlignments` to produce output |
| `mmEM.h` / `mmEM.cpp` | The core EM aligner class `mmEM`. Holds `probs`/`counts` as nested `map<string, map<string,long double>>` (substring→substring probability tables), plus a `limitSet`. Key methods: `initialization`, `expectation`/`maximization` (EM loop), `forwardEval`/`backwardEval` (forward-backward), `viterbi_align`/`nViterbi_align` (1-best and n-best Viterbi decoding for final alignments), file I/O (`readFileXY`, `readInitFile`, `readAlignerFromFile`, `writeAlingerToFile`), and `createAlignments` (driver that reads input, decodes, writes output) |
| `param.h` | Plain `PARAM` struct carrying all CLI-configured options through the pipeline |
| `util.h` | Header-only string helpers: `Tokenize`, `splitBySpace`, `join`, `stringify`/`convertTo` (generic string↔type conversion) |
| `tclap-1.2.1/` | Vendored copy of the TCLAP command-line parsing library (third-party, not project code) |
| `toAlignEx` | Sample input (word→pronunciation pairs from CMU Pronouncing Dictionary) for smoke-testing |
| `makefile` / `makefile.default` / `makefile.stlport` | Build via plain `make`; `makefile.stlport` variant swaps `<map>` for STLport's `<hash_map>` for speed |
| `COPYING` | BSD-style license |

## How it flows

1. `main()` reads CLI options into a `param`.
2. If no `--alignerIn`, `mmEM::training()` runs EM (init → alternating
   expectation/maximization until `--cutoff` threshold) over word pairs
   read from the input file (`news` or `l2p` format), then serializes the
   learned probability table to a `.model` file.
3. `mmEM::createAlignments()` reloads the model and Viterbi-decodes each
   pair (1-best or n-best), writing `.align` output (and `.align.err` for
   failures if `--errorInFile`).

## Notable characteristics

- Single-purpose CLI tool, no dependencies beyond bundled TCLAP.
- No test suite, no build system beyond `make`.
- `mmEM.cpp` method breakdown (line numbers as of current `mmEM.cpp`):
  - `readInitFile` — line 31
  - `initialization` — line 86
  - `maximization` — line 232
  - `backwardEval` — line 308
  - `forwardEval` — line 380
  - `printAlphaBeta` — line 452
  - `expectation` — line 465
  - `readFileXY` — line 555
  - `training` — line 608
  - `writeAlingerToFile` — line 661
  - `readAlignerFromFile` — line 686
  - `nViterbi_align` — line 728
  - `viterbi_align` — line 910
  - `createAlignments` — line 1059
