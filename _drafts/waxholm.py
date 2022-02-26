import struct
import numpy as np


def fix_text(text):
    return text.replace("{", "ä").replace("}", "å").replace("|", "ö")


class FR:
    def __init__(self, text):
        if not text.startswith("FR"):
            raise IOError("Unknown line type (does not begin with 'FR'): " + text)
        parts = text.split("\t")
        if len(parts) == 5:
            self.type = 'B'
        if len(parts) == 4:
            self.type = 'I'
        if len(parts) == 3:
            self.type = 'E'
            if parts[1].strip() != "OK":
                raise IOError("Unexpected line: " + text)
        self.frame = parts[0][2:].strip()
        if len(parts) > 3:
            self.phone_type = parts[1].strip()[0:1]
            self.phone = parts[1].strip()[1:]
            if not parts[2].strip().startswith(">pm "):
                raise IOError("Unexpected line: " + text)
            self.pm_type = parts[2].strip()[4:5]
            self.pm = parts[2].strip()[5:]
        if len(parts) == 5:
            if not parts[3].strip().startswith(">w "):
                raise IOError("Unexpected line: " + text)
            self.word = fix_text(parts[3].strip()[3:])
        if parts[-1].strip().endswith(" sec"):
            self.seconds = parts[-1].strip()[0:-4]

    def __repr__(self):
        parts = []
        parts.append(f"type: {self.type}")
        parts.append(f"frame: {self.frame}")
        if self.type != 'E':
            parts.append(f"phone: {self.phone}")
        if 'word' in self.__dict__:
            parts.append(f"word: {self.word}")
        if 'pm_type' in self.__dict__:
            parts.append(f"pm_type: {self.pm_type}")
        if 'pm' in self.__dict__:
            parts.append(f"pm: {self.pm}")
        parts.append(f"sec: {self.seconds}")
        return f"FR(" + ", ".join(parts) + ")"


class Mix():
    def __init__(self, filepath):
        self.fr = []
        with open(filepath) as inpf:
            saw_text = False
            saw_phoneme = False
            saw_labels = False
            for line in inpf.readlines():
                if line.startswith("Waxholm dialog."):
                    self.filepath = line[15:].strip()
                if line.startswith("TEXT:"):
                    saw_text = True
                if saw_text:
                    self.text = fix_text(line.strip())
                    saw_text = False
                if line.startswith("FR "):
                    if saw_labels:
                        saw_labels = False
                    self.fr.append(FR(line))
                if line.startswith("Labels: "):
                    self.labels = line[8:].strip()
                    saw_labels = True
                if saw_labels and line.startswith(" "):
                    self.labels += line.strip()


def smp_probe(filename):
    with open(filename, "rb") as f:
        return f.read(9) == b"file=samp"


def smp_headers(filename):
    with open(filename, "rb") as f:
        f.seek(0)
        raw_headers = f.read(1024)
        raw_headers = raw_headers.rstrip(b'\x00')
        asc_headers = raw_headers.decode("ascii")
        asc_headers.rstrip('\x00')
        tmp = [a for a in asc_headers.split("\r\n")]
        back = -1
        while abs(back) > len(tmp) + 1:
            if tmp[back] == '=':
                break
            back -= 1
        tmp = tmp[0:back-1]
        return dict(a.split("=") for a in tmp)


# From python-audio: https://github.com/mgeier/python-audio/blob/master/audio-files/utility.py
# CC-0: https://github.com/mgeier/python-audio/blob/master/LICENSE
def pcm2float(sig, dtype='float32'):
    """Convert PCM signal to floating point with a range from -1 to 1.
    Use dtype='float32' for single precision.
    Parameters
    ----------
    sig : array_like
        Input array, must have integral type.
    dtype : data type, optional
        Desired (floating point) data type.
    Returns
    -------
    numpy.ndarray
        Normalized floating point data.
    See Also
    --------
    float2pcm, dtype
    """
    sig = np.asarray(sig)
    if sig.dtype.kind not in 'iu':
        raise TypeError("'sig' must be an array of integers")
    dtype = np.dtype(dtype)
    if dtype.kind != 'f':
        raise TypeError("'dtype' must be a floating point type")

    i = np.iinfo(sig.dtype)
    abs_max = 2 ** (i.bits - 1)
    offset = i.min + abs_max
    return (sig.astype(dtype) - offset) / abs_max


def smp_read(filename):
    headers = smp_headers(filename)
    if headers["msb"] == "last":
        SPEC = "<h"
    else:
        SPEC = ">h"
    
    with open(filename, "rb") as f:
        f.seek(1024)
        buf = f.read()
        tmp = [a for a in struct.iter_unpack(SPEC, buf)]
        tmp = pcm2float(tmp)
        return np.array(tmp).reshape(1, -1)


def smp_read_np(filename):
    headers = smp_headers(filename)
    if headers["msb"] == "last":
        SPEC = "<h"
    else:
        SPEC = ">h"

    arr = np.memmap(filename, dtype=np.int16, mode="r", offset=1024)
    arr = pcm2float(arr)
    if headers["nchans"] == "1":
        arr = np.reshape(arr, (1, -1))
    elif headers["nchans"] == "2":
        arr = np.array([arr[::2], arr[1::2]])
    else:
        raise IOError("Only know how to handle 1 or 2 channels, got: " + headers["nchans"])
    return arr


def write_wav(filename, arr):
    import wave

    with wave.open(filename, "w") as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(16000)
        f.writeframes(arr)


arr = smp_read_np("/Users/joregan/Playing/waxholm/scenes_formatted/fp2060/fp2060.11.03.smp")
write_wav("out.wav", arr)
