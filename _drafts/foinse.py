# coding=utf-8
# Copyright 2021 The TensorFlow Datasets Authors and the HuggingFace Datasets Authors.
# Copyright 2021 Phonetics and Speech Laboratory, Trinity College, Dublin
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

import os
from pathlib import Path

import datasets

from bs4 import BeautifulSoup
import requests

_DESCRIPTION = """\
Foinse was an Irish-language magazine site.
This script uses a list of articles retrieved from the
Wayback Machine to build a corpus
"""

_DATA_URL = "https://huggingface.co/datasets/jimregan/foinse/raw/main/urls.txt"


class FoinseDataset(datasets.GeneratorBasedBuilder):
    """Scraper dataset for Foinse."""

    VERSION = datasets.Version("1.1.0")

    BUILDER_CONFIGS = [
        datasets.BuilderConfig(name="documents", version=VERSION, description="Plain text portion of the corpus: whole documents"),
        datasets.BuilderConfig(name="paragraphs", version=VERSION, description="Plain text portion of the corpus: paragraphs"),
    ]

    def _info(self):
        features = datasets.Features(
            {
                "title": datasets.Value("string"),
                "subtitle": datasets.Value("string"),
                "url": datasets.Value("string"),
                "author": datasets.Value("string"),
                "date_text": datasets.Value("string"),
                "text": datasets.Value("string"),
                "category": datasets.Value("string"),
                "summary": datasets.Value("string"),
                "subcategory": datasets.Value("string"),
            }
        )

        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=features,
            supervised_keys=None,
        )

    def _split_generators(self, dl_manager):
        """Returns SplitGenerators."""
        dl_path = dl_manager.download(_DATA_URL)

        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
                gen_kwargs={
                    "split": "train",
                    "data_file": dl_path
                },
            ),
        ]

    def _generate_examples(
        self, split, data_file
    ):
        """ Yields examples as (key, example) tuples. """
        links = _get_links(data_file)
        _id = 1
        for url in links:
            content = get_content(url)

            paras = config.get("text", [])
            if self.config.name == "documents":
                paras = ['\n'.join(paras)]
            for para in paras:
                yield _id, {
                    "title": content.get("title", ""),
                    "url": url,
                    "author": content.get("author", ""),
                    "date_text": content.get("published", ""),
                    "category": content.get("category", ""),
                    "subcategory": content.get("subcategory", ""),
                    "summary": content.get("summary", ""),
                    "text": para
                }
                _id += 1


def get_content(url):
    out = {}
    page = requests.get(url)
    if page.status_code != 200:
        return {}
    page_content = page.text

    soup = BeautifulSoup(page_content, "lxml")

    content = soup.find("div", {"class": "item-page"})
    if not content:
        content = soup.find("div", {"id": "ja-main"})
    if not content:
        return {}
    
    breadcrumbs = soup.find("div", {"class": "ja-breadcrums"})
    if breadcrumbs:
        here = breadcrumbs.find("a", {"class": "pathway"})
        if not here:
            here = breadcrumbs.find("span", {"class": "pathway"})
        if here:
            out["category"] = here.text.strip()
    
    # junk
    jc = content.find("div", {"id": "jc"})
    if jc:
        jc.extract()
    pagenav = content.find("ul", {"class": "pagenav"})
    if pagenav:
        pagenav.extract()
    for js in content.find_all("script", {"type": "text/javascript"}):
        js.extract()

    h2 = content.find("h2")
    if h2:
        title = h2.text.strip()
        if title:
            out["title"] = title
        h2.extract()

    h1 = content.find("h1")
    if h1:
        heading = h1.text.strip()
        if heading:
            out["subcategory"] = heading
        h1.extract()

    published_tag = content.find("dd", {"class": "published"})
    if not published_tag:
        published_tag = content.find("span", {"class": "createdate"})
    if published_tag:
        out["published"] = published_tag.text.strip()

    author_tag = content.find("dd", {"class": "createdby"})
    if not author_tag:
        author_tag = content.find("span", {"class": "createby"})
    if author_tag:
        out["author"] = author_tag.text.strip()
    artinfo = content.find("dl", {"class": "article-info"})
    if not artinfo:
        artinfo = content.find("div", {"class": "article-meta"})
    if artinfo:
        artinfo.extract()

    paragraphs_tags = content.find_all("p")
    paragraphs = [p.text.replace("\xa0", " ").strip() for p in paragraphs_tags]
    out["text"] = paragraphs
    
    raw_text = content.text
    
    raw_out = []
    for raw_line in raw_text.split("\n"):
        line = raw_line.replace("\xa0", " ").strip()
        if line == "":
            continue
        raw_out.append(line)
    if paragraphs != raw_out:
        out["text"] = raw_out
        
    summary = extract_summary(out["text"])
    if summary:
        out["summary"] = summary
    out["text"] = filter_para_list(out["text"])

    vocab_list = []
    for vocab in content.find_all("a", {"class": "glossarylink"}):
        item = {}
        item["en"] = vocab.get("title").strip()
        item["ga"] = vocab.text.strip()
        vocab_list.append(item)
    out["vocab"] = vocab_list
    
    return out


def extract_summary(inlist):
    if len(inlist) > 2:
        if inlist[-2] == "Did you understand this story? Here are the main points:":
            return inlist[-1]
    return ""


def filter_para_list(inlist):
    out = []
    for para in inlist:
        if para == "":
            continue
        elif para.strip() == "Foinse - News as Gaeilge":
            return out
        elif para.strip() == "Did you understand this story? Here are the main points:":
            return out
        else:
            out.append(para)
    return out


def _get_links(scrape):
    links = set()
    if not os.path.exists(scrape):
        raise Exception(f"File {scrape} does not exist")
    with open(scrape) as f:
        for url in f.readlines():
            links.add(url.rstrip())
    return list(links)
