Project ideas:

1. Codec-based speech similarity search
    - Data from librivox (monthly reading projects)
    - EnCodec / X-Codec2 (LLaSA) /etc.
    - FAISS or other vector search
    - Maybe wav2tok (ICLR ’23) using a codec instead of wav2vec
2. Speech to text pipeline
    - Mapping (audio, English) to other language
    - Gutenberg, Runeberg, Wikisource, etc.
    - Aligning sentences is solved (Hunalign, etc.) but locating those sentences in a pre-chunked audio dataset is not (i.e., pick from Librispeech, MLS, etc. instead of redoing)
    - Finding book candidates may be difficult
    - Produce a dataset for use in fine-tuning Whisper, but actual fine-tuning not feasible
