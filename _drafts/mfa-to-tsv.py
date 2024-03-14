# coding=utf-8
# Copyright 2024 Jim O'Regan for Språkbanken Tal
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Lint as: python3
from pathlib import Path
import argparse
import textgrid


def get_args():
    parser = argparse.ArgumentParser("Convert MFA TextGrids to TSV")

    parser.add_argument("mfa_directory", type=Path)
    parser.add_argument("tsv_directory", nargs="?", type=Path)

    args = parser.parse_args()
    return args


def main():
    args = get_args()

    DIR = args.mfa_directory
    if args.tsv_directory:
        OUTDIR = args.tsv_directory
    else:
        OUTDIR = DIR

    for file in DIR.glob("*.TextGrid"):
        outfile = OUTDIR / f"{file.stem}.tsv"
        tg = textgrid.TextGrid.fromFile(str(file))
        
        tiers = None
        if len(tg.tiers) == 2:
            if tg.tiers[0].name == "words":
                tiers = tg.tiers[0]
            else:
                tiers = tg.tiers[1]
        if tiers is None:
            continue

        with open(str(outfile), "w") as of:
            for interval in tiers.intervals:
                if interval.mark is None or interval.mark == "":
                    continue
                else:
                    of.write(f'{interval.minTime}\t{interval.maxTime}\t{interval.mark}\n')


if __name__ == '__main__':
        main()
