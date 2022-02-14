import torch
from pyannote.audio import Pipeline
from pydub import AudioSegment
from pydub.utils import mediainfo
from pathlib import Path
import argparse
import numpy as np


def get_diarization(audio_path: Path, pipeline):
    base = audio_path.stem
    seg = AudioSegment.from_file(audio_path)
    #info = mediainfo(audio_path)
    #sr = int(info["sample_rate"])
    seg = seg.set_channels(1)
    seg = seg.set_frame_rate(16000)
    segarr = seg.get_array_of_samples()
    waveform = torch.tensor(segarr, dtype=torch.float)
    waveform = torch.reshape(waveform, (1, waveform.shape[0]))
    diarization = pipeline({"waveform": waveform, "sample_rate": 16000})
    diarization.uri = base
    return diarization


def main():
    parser = argparse.ArgumentParser(description='Run speaker diarization using pyannote.')
    parser.add_argument('--model', dest='model', type=str, nargs='?',
                        default="pyannote/speaker-diarization",
                        help='model to use for diarization')
    parser.add_argument('files', metavar='files', type=str, nargs='+',
                        help='files to diarize')
    parser.add_argument('--verbose', '-v', action='count', default=0)
    args = parser.parse_args()

    pipeline = Pipeline.from_pretrained(args.model)

    for file in args.files:
        fpath = Path(file)
        if args.verbose > 0:
            print("Processing: " + file)
        diar = get_diarization(fpath, pipeline)
        base = fpath.stem
        with open(f"{base}.rttm", "w") as outfile:
            diar.write_rttm(outfile)


if __name__ == "__main__":
    main()