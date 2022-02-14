import librosa
import torch
from pyannote.audio import Pipeline
from pathlib import Path
import argparse


def get_diarization(audio_path: Path, pipeline):
    base = audio_path.stem
    audio, sr = librosa.load(audio_path, mono=False)
    audionp = torch.from_numpy(audio)
    diarization = pipeline({"waveform": audionp, "sample_rate": sr})
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