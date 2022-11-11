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


def get_aligned_pairs(a: List[str], b: List[str]) -> List[str]:
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
                outputs.append(f"<eps> {x}")
        elif tag == "delete":
            for x in a[i1:i2]:
                outputs.append(f"{x} <eps>")
        elif tag == "replace":
            for x, y in pad_replacements(a[i1:i2], b[j1:j2]):
                outputs.append(f"{x} {y}")
    return outputs


def get_args():
    parser = argparse.ArgumentParser(description="""
    Simple replacement for Kaldi's align-text
    """)
    parser.add_argument('files', type=str, nargs='+', help='files to process')
    parser.add_argument('--lower', help='lowercase words', action='store_true', default=True)
    args = parser.parse_args()

    return args


def main():
    args = get_args()


if __name__ == '__main__':
    main()
