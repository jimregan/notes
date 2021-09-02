import os
from pathlib import Path

import datasets

from bs4 import BeautifulSoup

_CITATION = """\
@article{ite2003corpas,
  title={Corpas Náisiúnta na Gaeilge/National Corpus of Irish, Volume 1},
  author={Institiúid Teangeolaíochta Éireann},
  journal={Dublin: ITÉ},
  year={2003}
}
"""

_DESCRIPTION = """\
Corpus of written Irish.
"""

_TEXTDIRS = [
    "fiction", "information", "instruction", "non_fiction", "official"
]

class CNGDataset(datasets.GeneratorBasedBuilder):
    """National Corpus of Irish."""

    VERSION = datasets.Version("1.1.0")

    BUILDER_CONFIGS = [
        datasets.BuilderConfig(name="documents", version=VERSION, description="Plain text portion of the corpus: whole documents"),
        datasets.BuilderConfig(name="paragraphs", version=VERSION, description="Plain text portion of the corpus: paragraphs"),
        datasets.BuilderConfig(name="pos", version=VERSION, description="Part-of-speech tagging subset"),
    ]

    def _info(self):
        if self.config.name == "documents" or self.config.name == "paragraphs":
            features = datasets.Features(
                {
                    "title": datasets.Value("string"),
                    "doc_id": datasets.Value("string"),
                    "author": datasets.Value("string"),
                    "date": datasets.Value("string"),
                    "text": datasets.Value("string"),
                    "classes": datasets.Sequence(datasets.Value("string"))
                }
            )
        else:
            features = datasets.Features(
                {
                    "title": datasets.Value("string"),
                    "doc_id": datasets.Value("string"),
                    "author": datasets.Value("string"),
                    "date": datasets.Value("string"),
                    "classes": datasets.Sequence(datasets.Value("string")),
                    "words": datasets.Sequence(datasets.Value("string")),
                    "pos": datasets.Sequence(datasets.Value("string"))
                }
            )

        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=features,
            supervised_keys=None,
            citation=_CITATION,
        )

    def _split_generators(self, dl_manager):
        """Returns SplitGenerators."""
        manual_dir = os.path.abspath(os.path.expanduser(dl_manager.manual_dir))

        if not os.path.exists(manual_dir):
            raise FileNotFoundError(
                "{} does not exist. Make sure you insert a manual dir via `datasets.load_dataset('jimregan/ncg', data_dir=...)` with the path to the corpus directory".format(
                    manual_dir
                )
            )

        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
                gen_kwargs={
                    "data_dir": manual_dir,
                    "split": "train",
                },
            ),
        ]

    def _generate_examples(
        self, data_dir, split
    ):
        """ Yields examples as (key, example) tuples. """

        if self.config.name == "documents" or self.config.name == "paragraphs":
            dirs = _TEXTDIRS
        else:
            dirs = ["pos"]

        cng_path = Path(data_dir)

        for dir in dirs:
            dir_path = cng_path / dir
            _id = 1
            for filepath in dir_path.glob('*.SGM'):
                with open(filepath, encoding="utf-16-le") as f:
                    fid = filepath.stem
                    content = f.read()
                    soup = BeautifulSoup(content, 'html.parser')
                    title = _get_title(soup)
                    author = _get_author(soup)
                    classes = _get_categories(content)
                    date = _get_creation(soup)
                    if self.config.name == "pos":
                        for sent in _get_pos(soup):
                            words = [tok["word"] for tok in sent]
                            tags = [tok["msd"] for tok in sent]
                            yield fid, {
                                "title": title,
                                "docid": fid,
                                "author": author,
                                "date": date,
                                "classes": classes,
                                "words": words,
                                "pos": tags
                            }
                            _id += 1
                    else:
                        text = _get_paragraphs(soup)
                        if self.config.name == "documents":
                            text = ["\n".join(text)]
                        for para in text:
                            yield fid, {
                                "title": title,
                                "docid": fid,
                                "author": author,
                                "date": date,
                                "classes": classes,
                                "text": para
                            }
                            _id += 1

                        
def _get_title(soup):
    title = soup.find("title")
    if title.text and title.text.strip() != "":
        return title.text.strip()


def _get_author(soup):
    author = soup.find("author")
    if author.text and author.text.strip() != "":
        return author.text.strip()


def _get_creation(soup):
    creation = soup.find("creation")
    if creation.text and creation.text.strip() != "":
        return creation.text.strip()


def _get_paragraphs(soup):
    import re
    out = []
    body = soup.find('body')
    for p in body.find_all(['p', 'head']):
        text = p.text.strip()
        text = text.replace('\n', ' ')
        text = re.sub('  +', ' ', text)
        if text:
            out.append(text)
    return out


def _get_categories(text):
    import re
    out = []
    for cat in re.findall('<catRef target="([^"]+)">', text):
        out.append(cat)
    return out


def _get_pos(soup):
    out = []
    for sent in soup.find_all('s'):
        words = []
        for word in sent.find_all('w'):
            if word.text:
                text = word.text.strip()
            msd = word.get('msd')
            if msd and text:
                words.append({"msd": msd, "word": text})
        out.append(words)
    return out
