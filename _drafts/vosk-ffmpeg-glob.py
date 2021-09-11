#!/usr/bin/env python3

from vosk import Model, KaldiRecognizer, SetLogLevel
import sys
import os
import subprocess
import glob
from pathlib import Path
import json

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
    rec.Reset()
    output = []
    outfile = dir / f"{file.stem}.json"
    print(f"{file}\n")
    process = subprocess.Popen(['ffmpeg', '-loglevel', 'quiet', '-i',
                                str(file),
                                '-ar', '16000', '-ac', '1', '-f', 's16le', '-'],
                                stdout=subprocess.PIPE)

    while True:
        data = process.stdout.read(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            output.append(json.loads(rec.Result()))
    output.append(json.loads(rec.FinalResult()))

    with open(outfile, "w") as f:
        json.dump(output, f, indent=4)

