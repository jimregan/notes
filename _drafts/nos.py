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
Nós is an Irish-language magazine site.
This script crawls the Nós website to create a text dataset.
"""

class NosDataset(datasets.GeneratorBasedBuilder):
    """Scraper dataset for Nós."""

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
                "date": datasets.Value("string"),
                "text": datasets.Value("string"),
                "video_url": datasets.Value("string"),
                "categories": datasets.Sequence(datasets.Value("string")),
                "tags": datasets.Sequence(datasets.Value("string")),
            }
        )

        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=features,
            supervised_keys=None,
        )

    def _split_generators(self, dl_manager):
        """Returns SplitGenerators."""

        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
                gen_kwargs={
                    "split": "train",
                },
            ),
        ]

    def _generate_examples(
        self, split
    ):
        """ Yields examples as (key, example) tuples. """
        menu_links = _read_menu()
        articles = _get_article_list(menu_links)
        _id = 1
        for url in articles:
            page = requests.get(url)
            soup = BeautifulSoup(page.text, 'lxml')

            title = _get_title(soup)
            subtitle = _get_subhead(soup)
            details = _get_details(soup)
            paras = _get_text(soup)
            video = _get_video(soup)
            if self.config.name == "documents":
                paras = ['\n'.join(paras)]
            for para in paras:
                yield _id, {
                    "title": title,
                    "subtitle": subtitle,
                    "url": url,
                    "author": details.get("author", ""),
                    "date": details.get("date", ""),
                    "categories": details.get("categories", []),
                    "tags": details.get("tags", []),
                    "video_url": video,
                    "text": para
                }
                _id += 1


def _get_title(soup):
    title_tag = soup.find('title')
    ogtitle = soup.find("meta", {"property": "og:title"})
    ogtitle_text = ogtitle.get('content', '')
    if title_tag and title_tag.text and title_tag.text.strip() != "":
        return title_tag.text.strip()
    elif ogtitle_text and ogtitle_text.strip() != "":
        return ogtitle_text.strip()


def _get_text(soup):
    out = []
    content = soup.find("div", {"id": "single-area-center"})
    for para in content.find_all('p'):
        if para.text and para.text.strip() != "":
            out.append(para.text.strip().replace('\xa0', ' '))
    return out


def _get_video(soup):
    vid = soup.find('div', {'id': 'video-wrapper'})
    if vid:
        iframe = vid.find('iframe')
        if iframe:
            return iframe.get('src', '')
    return ''


def _get_subhead(soup):
    out = []
    content = soup.find("div", {"id": "single-area-center"})
    if content.h1 and content.h1.span:
        return content.h1.span.get_text(strip=True)
    else:
        return ''


def _get_details(soup):
    details = {}
    pubdet = soup.find("div", {"id": "single-publish-details"})
    ptags = [p for p in pubdet.find_all('p')]
    if ptags[0].b:
        details['author'] = ptags[0].b.get_text(strip=True)
    if ptags[1]:
        details['date'] = ptags[1].get_text(strip=True)
    broll = pubdet.find("div", {"class": "blogroll-tag-category"})
    cats = set()
    for cat in broll.find_all("a", {"class": "featured-category"}):
        if cat.get_text(strip=True) != "":
            cats.add(cat.get_text(strip=True))
    if len(cats) > 0:
        details['categories'] = list(cats)

    tags = set()
    for tag in broll.find_all("a", {"class": "featured-tag"}):
        if tag.get_text(strip=True) != "":
            tags.add(tag.get_text(strip=True))
    if len(tags) > 0:
        details['tags'] = list(tags)
    return details


def _get_remainder(soup):
    import re
    pagination = soup.find("div", {"class": "pagination"})
    if not pagination:
        return []
    current = pagination.find("span", {"class": "current"})
    if not (current and current.get_text(strip=True) == "1"):
        return []
    cats = [a for a in pagination.find_all('a')]
    last_cat = cats[-1]
    last_url = last_cat.get('href', '')
    if not last_url:
        return []
    m = re.match("(.*/)([0-9]+)/$", last_url)
    if not m:
        return []
    base = m.group(1)
    num = int(m.group(2)) + 1
    return [f'{base}{i}/' for i in range(2, num)]


def _collect_articles(soup):
    out = set()
    for art in soup.find_all("article", {"class": "blogroll-post"}):
        a = art.find('a')
        out.add(a.get('href'))
    return list(out)


def _read_menu():
    page = requests.get("http://nos.ie/")
    soup = BeautifulSoup(page.text, 'lxml')
    menu = soup.find("ul", {"id": "menu-main-menu"})
    cat_pages = set()
    for li in menu.find_all("li"):
        if li.a:
            cat_pages.add(li.a['href'])
    return cat_pages


def _get_article_list(urls):
    rest = set()
    articles = set()
    for url in urls:
        page = requests.get(url)
        soup = BeautifulSoup(page.text, 'lxml')
        new = _get_remainder(soup)
        rest = rest.union(new)
        art = _collect_articles(soup)
        articles = articles.union(art)
    for url in rest:
        page = requests.get(url)
        soup = BeautifulSoup(page.text, 'lxml')
        art = _collect_articles(soup)
        articles = articles.union(art)
    return list(articles)
