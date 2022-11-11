import argparse

try:
    from pympi import Eaf
except ImportError:
    print("Error importing pympi")
    print("Hint: pip install pympi-ling")
    quit()

try:
    import webvtt
except ImportError:
    print("Error importing webvtt")
    print("Hint: pip install webvtt-py")
    quit()


def get_args():
    parser = argparse.ArgumentParser(description="""
    Convert WebVTT files to Elan EAF
    """)
    parser.add_argument('files', type=str, nargs='+', help='list of files to convert')
    parser.add_argument('--tier-name', help='Name of the speech tier (from the VTT captions)', type=str, default="speech")
    args = parser.parse_args()

    return args


def convert_vtt_to_elan(filename, tiername="whisper"):
    outfile = filename.replace(".vtt", ".eaf")
    eaf = Eaf()
    eaf.add_tier(tiername)
    count = 1
    for caption in webvtt.read(filename):
        start = int(caption.start_in_seconds * 1000)
        end = int(caption.end_in_seconds * 1000)
        text = caption.text.replace("\n", " ").replace("\r", "")
        eaf.add_annotation(tiername, start, end, text)
    eaf.to_file(outfile)


def main():
    args = get_args()

    for file in args.files:
        convert_vtt_to_elan(file, args.tier_name)


if __name__ == '__main__':
    main()
