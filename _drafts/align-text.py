from difflib import SequenceMatcher
import copy
from typing import List, Tuple
import argparse


def pad_replacements(a_in: List[str], b_in: List[str], padding: str = "<eps>") -> List[Tuple[str, str]]:
    """
    zip() for lists of strings, padded with `padding` if
    there is a mismatch in the number of elements of
    the lists.

        Parameters:
            a_in (list): first list of strings
            b_in (list): second list of strings
            padding (str): string to pad the lists with ("<eps>" by default)
        
        Returns:
            A list of tuples, created from zip() on the padded lists
    """
    a = copy.deepcopy(a_in)
    b = copy.deepcopy(b_in)
    if len(a) > len(b):
        diff = len(a) - len(b)
        for i in range(0, diff+1):
            b.append(padding)
    elif len(b) > len(a):
        diff = len(b) - len(a)
        for i in range(0, diff+1):
            a.append(padding)
    return [x for x in zip(a, b)]


def get_aligned_pairs(a: List[str], b: List[str], padding: str = "<eps>") -> List[str]:
    """
    Aligns the elements of lists a and b, returning a list of
    strings containing the aligned pairs in the format
    used by Kaldi's `align-text`

        Parameters:
            a (list): first list of strings
            b (list): second list of strings
        
        Returns:
            A list of strings, combining the elements from both lists
            with "<eps>" to mark where an insertion or deletion
            took place
    """
    s = SequenceMatcher(None, a, b)
    outputs = []
    for tag, i1, i2, j1, j2 in s.get_opcodes():
        if tag == "equal":
            for x in a[i1:i2]:
                outputs.append(f"{x} {x}")
        elif tag == "insert":
            for x in b[j1:j2]:
                outputs.append(f"{padding} {x}")
        elif tag == "delete":
            for x in a[i1:i2]:
                outputs.append(f"{x} {padding}")
        elif tag == "replace":
            for x, y in pad_replacements(a[i1:i2], b[j1:j2], padding):
                outputs.append(f"{x} {y}")
    return outputs


def get_args():
    parser = argparse.ArgumentParser(description="""
    Simple replacement for Kaldi's align-text

    Computes alignment between two sentences with the same key in the
    two given input text files. This implementation uses Python's
    difflib.

    The input text file 'a' looks as follows:
        key1 a b c
        key2 d e

    The input text file 'b' looks as follows:
        key1 a c
        key2 f e

    The alignment produced will look as follows:
        key1 a a ; b <eps> ; c c
        key2 d f ; e e
    
    where the aligned pairs are separated by ";"
    """)
    parser.add_argument('file_a', type=argparse.FileType('r'), help='first file to compare; left side in the alignments')
    parser.add_argument('file_b', type=argparse.FileType('r'), help='second file to compare; right side in the alignments')
    parser.add_argument('alignment', type=argparse.FileType('w'), help='output file containing aligned pairs')
    parser.add_argument('--special-symbol', help='Special symbol to represent insertions or deletions', type=str, default="<eps>")
    parser.add_argument('--separator', help='Special symbol to represent insertions or deletions', type=str, default=";")
    args = parser.parse_args()

    return args


def read_map(file_handle):
    mapping = {}
    for line in file_handle:
        clean = line.strip()
        if clean == "":
            continue
        parts = clean.split()
        key = parts[0]
        mapping[key] = parts[1:]
    return mapping


def _check_keys(a, b):
    missing_a = []
    missing_b = []
    for key in a:
        if key not in b:
            missing_a.append(key)

    for key in b:
        if key not in a:
            missing_b.append(key)
    
    if missing_a:
        print("Keys present in a but not in b:", " ".join(missing_a))

    if missing_b:
        print("Keys present in b but not in a:", " ".join(missing_b))


def run(args):
    a = read_map(args.file_a)
    b = read_map(args.file_b)
    _check_keys(a, b)
    separator = f" {args.separator} "

    for key in a:
        alignment = get_aligned_pairs(a[key], b[key], args.special_symbol)
        print(f"{key} {separator.join(alignment)}", file=args.alignment)


def main():
    args = get_args()
    try:
        run(args)
    finally:
        for f in [args.file_a, args.file_b, args.alignment]:
            f.close()


if __name__ == '__main__':
    main()
