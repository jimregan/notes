#!/usr/bin/env python

"""
Converts a directory of .pcm files (for NST Swedish TTS data) into wav
"""
from pathlib import Path
import argparse
import wave
import sys
try:
    import soundfile as sf
    HAVE_SOUNDFILE = True
except ImportError:
    HAVE_SOUNDFILE = False

_HEADER = b'PCM44   \x00\x00\x00\x00\x00\x00\x00S'


def is_pcm(filename) -> bool:
    """
    Check the header of a .pcm file

    Args:
        filename: the file to check

    Returns:
        True is header is present, False otherwise
    """
    with open(filename, "rb") as pcm:
        pcm.seek(0)
        cond = (pcm.read(16) == _HEADER)
        # reset location, just in case
        pcm.seek(0)
        return cond


def read_with_soundfile(filename):
    """
    Uses soundfile to read the .pcm file

    Args:
        filename: the file to check

    Returns:
        a tuple containing an array of frames,
        and the sample rate.
    """
    if not HAVE_SOUNDFILE:
        return None
    return sf.read(filename, channels=2, samplerate=44100, endian="BIG",
                   dtype="int16", format="RAW", subtype="PCM_16", start=16)


def write_wav_sf(output_file, data):
    """
    Write a .wav file with the output from read_with_soundfile

    Args:
        output_file: filename to write
        data: array of frames returned by read_with_soundfile
    """
    with wave.open(output_file, "w") as of:
        of.setframerate(44100)
        of.setsampwidth(2)
        of.setnchannels(2)
        of.writeframes(data)


def convert_sf(infile, outfile):
    """
    Convert a .pcm file to .wav using soundfile

    Args:
        infile: the .pcm file to convert
        outfile: the name of the .wav file to write
    """
    data, sr = read_with_soundfile(infile)
    write_wav_sf(outfile, data)


# This is a leftover from the waxholm checks
# soundfile is a pain to install, so doesn't
# hurt to have it, as awful and inefficient
# as it is.
def convert_raw(infile, outfile):
    """
    Convert a .pcm file to .wav without soundfile
    (by unpacking and repacking big-endian to little)

    Args:
        infile: the .pcm file to convert
        outfile: the name of the .wav file to write
    """
    with open(infile, "rb") as inf, wave.open(outfile, "w") as outf:
        bs = b''
        inf.seek(16)
        short = inf.read(2)
        while short:
            bs += short[::-1]
            short = inf.read(2)
        outf.setframerate(44100)
        outf.setsampwidth(2)
        outf.setnchannels(2)
        ba = bytearray(bs)
        outf.writeframes(ba)


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--pcm-dir', required=True, default="mf", type=str)
    parser.add_argument('--wav-dir', required=True, default="wav", type=str)
    return parser.parse_args()


def main(args):
    pcm_path = Path(args.pcm_dir)
    wav_path = Path(args.wav_dir)

    convert = convert_sf
    if not HAVE_SOUNDFILE:
        convert = convert_raw

    if not pcm_path.is_dir():
        print(f"PCM directory ({str(pcm_path)}) does not exist, cannot continue")
        sys.exit()
    if not wav_path.is_dir():
        if wav_path.exists():
            print(f"Wav directory given exists, but is a file", str(wav_path))
            sys.exit()
        else:
            wav_path.mkdir()

    for file in pcm_path.glob("*.pcm"):
        stem = file.stem
        if not is_pcm(str(file)):
            print(f"File {stem} does not appear to be a PCM file")
            continue
        wavfile = wav_path / f"{stem}.wav"
        convert(str(file), str(wavfile))

if __name__ == '__main__':
    args = get_args()
    main(args)

