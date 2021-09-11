#!/usr/bin/env python3

from vosk import Model, KaldiRecognizer, SetLogLevel
import sys
import os
import subprocess
import glob
from pathlib import Path

SetLogLevel(0)

model = Model("/home/jim/Playing/model")
rec = KaldiRecognizer(model, 16000)
rec.SetWords(True)

if sys.argv and sys.argv[0]:
    dir = Path(sys.argv[1])
else:
    exit()

if not dir.is_dir():
    exit()

for file in dir.glob('*.mp3'):
    outfile = dir / f"{file.stem}.json"
    process = subprocess.Popen(['ffmpeg', '-loglevel', 'quiet', '-i',
                                str(file),
                                '-ar', '16000', '-ac', '1', '-f', 's16le', '-'],
                                stdout=subprocess.PIPE)

    while True:
        data = process.stdout.read(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            print(rec.Result())
        else:
            print(rec.PartialResult())

    with open(outfile, "w+") as f:
        f.write(rec.FinalResult() + "\n")
