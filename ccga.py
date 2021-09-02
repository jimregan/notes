# coding=utf-8
# Copyright 2021 The TensorFlow Datasets Authors and the HuggingFace Datasets Authors.
# Copyright 2021 Jim O'Regan
#
# Based on Corpus Crawler (utils.py):
# Copyright 2017 Google Inc. All rights reserved.
#
# Based on Corpus Crawler's Irish crawler (crawl_ga.py):
# Copyright 2017 Google Inc. All rights reserved.
# Copyright 2017 Jim O'Regan
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
"""Corpus Crawler Irish web text dataset."""

import collections
import os
import re
import struct
import unicodedata
import base64
import hashlib
from html.entities import name2codepoint
from email import message_from_string as Message
from urllib.parse import urlparse
from pathlib import Path
from typing import Optional

import pyarrow as pa

import datasets


_DESCRIPTION = """\
Irish web corpus, crawled with Corpus Crawler.

Uses a list of URLs, collected by the crawler, to
retrieve the files from the crawler's cache.
"""

#_SCRAPES = ["20180911", "20191117", "20210810"]
_SCRAPES = ["20191117", "20210810"]


logger = datasets.utils.logging.get_logger(__name__)
_DATA_URL = 'https://gist.githubusercontent.com/jimregan/66612f4ecb88ed96d41d43266e6d0872/raw/26bd05f11b4c1c31e33d36528ac53dea587be8ef/crawled-{}.txt'


class CorpusCrawlerIrishConfig(datasets.BuilderConfig):
    """BuilderConfig for CorpusCrawlerIrish."""

    def __init__(self, **kwargs):
        super(CorpusCrawlerIrishConfig, self).__init__(version=datasets.Version("2.1.0", ""), **kwargs)

class CorpusCrawlerIrish(datasets.GeneratorBasedBuilder):
    """Corpus Crawler crawled text dataset."""

    BUILDER_CONFIGS = [
        CorpusCrawlerIrishConfig(name=scrape) for scrape in _SCRAPES
    ]

    def _info(self):
        return datasets.DatasetInfo(
            description=_DESCRIPTION,
            features=datasets.Features(
                {
                    "url": datasets.Value("string"),
                    "genre": datasets.Value("string"),
                    "publication_date": datasets.Value("string"),
                    "title": datasets.Value("string"),
                    "text": datasets.Value("string"),
                    "video_url": datasets.Value("string"),
                }
            ),
        )

    def _split_generators(self, dl_manager):
        if not self.config.data_dir:
            raise ValueError(f"Path to Corpus Crawler cache directory must be specified, but got data_dir={self.config.data_dir}")
        cc_cache = self.config.data_dir

        if not self.config.name:
            raise ValueError(f"Scrape set must be specified, but got name={self.config.name}")
        scrape_set = self.config.name
        dl_path = dl_manager.download(_DATA_URL.format(self.config.name))

        return [
            datasets.SplitGenerator(
                name=datasets.Split.TRAIN,
                gen_kwargs={
                    "name": scrape_set,
                    "data_dir": cc_cache,
                    "data_file": dl_path,
                })
        ]

    def _generate_examples(self, name, data_dir, data_file):
        """Generate examples from a Corpus Crawl cache."""
        logger.info("generating examples from = %s", name)
        links = _get_links(data_file)
        if not self.config.data_dir:
            self.config.data_dir = data_dir
        dd_path = Path(data_dir)
        if not dd_path.is_dir():
            raise Exception('No directory: ' + data_dir)

        _id = 1
        for link in links:
            res = self._fetch_page(link, data_dir)
            for para in res['text']:
                example = {
                    "genre": res['genre'],
                    "url": res['url'],
                    "publication_date": res['publication-date'],
                    "video_url": res['video'],
                    "title": res['title'],
                    "text": para
                }
                yield _id, example
                _id += 1
    
    def _fetch_page(self, url, data_dir):
        _EXTRATORS = {
            'www.unicode.org': do_udhr,
            'tuairisc.ie': do_tuairisc_ie,
            'www.rte.ie': do_nuachtrte,
            'www.irishtimes.com': do_irishtimes,
            'www.chg.gov.ie': do_chg,
            'www.ainm.ie': do_ainm_ie,
            'gaeltacht21.blogspot.com': do_blogspot,
            'aonghus.blogspot.com': do_blogspot,
            'nimill.blogspot.com': do_blogspot,
            'turasailse.blogspot.com': do_blogspot,
            'caomhach.blogspot.com': do_blogspot,
            'breacleabhar.blogspot.com': do_blogspot,
            'gearoid.blogspot.com': do_blogspot,
            'philo-celtic.blogspot.com': do_blogspot,
            'iomhannablag.blogspot.com': do_blogspot,
            'smaointefanacha.blogspot.com': do_blogspot,
            'imeall.blogspot.com': do_blogspot,
            'coislife.ie': do_coislife_ie,
            'meoneile.ie': do_meoneile_ie,
            'peig.ie': do_peig_ie,
            'www.forasnagaeilge.ie': do_forasnagaeilge_ie,
        }
        parsed_url = urlparse(url)
        host = parsed_url.netloc
        extract = _EXTRATORS.get(host)
        if extract:
            fr = fetch(data_dir, url)
            if fr is None:
                raise Exception("Failed to fetch {} from {}" % (url, data_dir))
            return extract(fr)


# Corpus Crawler: utils.py
_TAG_REGEX = re.compile(r'\<.+?\>', flags=re.DOTALL)
def striptags(s):
    return _TAG_REGEX.sub('', s)


def unichar(i):
    try:
        return chr(i)
    except ValueError:
        # non-BMP codepoint in narrow Python build
        return struct.pack('i', i).decode('utf-32')


def replace_html_entities(html):
    entities = name2codepoint
    html = re.sub(r'&#([0-9]+);',
                  lambda z:unichar(int(z.group(1))), html)
    html = re.sub(r'&#[xX]([0-9a-fA-F]+);',
                  lambda z:unichar(int(z.group(1), 16)), html)
    html = re.sub(r'&([a-zA-Z]+);',
                  lambda z:unichar(entities.get(z.group(1).lower(), 0x20)), html)
    return html


def cleantext(html):
    html = re.sub(r'<script.+?</script>', ' ', html, flags=re.DOTALL)
    html = replace_html_entities(striptags(html))
    # Some web sites insert zero-width spaces, possibly as byte order marks
    # (from Microsoft Notepad) which their scripts failed to recognize as such.
    html = html.replace('\u200B', '')
    return unicodedata.normalize('NFC', ' '.join(html.split()))


def clean_paragraphs(html):
    text = html.replace('\n', ' ')
    text = re.sub(r'</(?:div|DIV|p|P|[hH][1-6]|table|TABLE|tr|td|article)>',
                  '\n', text)
    text = re.sub(r'<(?:br|BR)\s*/?>', '\n', text)
    return list(filter(None, [cleantext(p) for p in text.split('\n')]))


def extract(before, after, html):
    s = html.split(before, 1)
    return s[1].split(after)[0] if len(s) == 2 else None


FetchResult = collections.namedtuple('FetchResult',
                                     ['headers', 'content', 'url', 'filepath'])


def fetch(cache_dir, url):
    logger.info("fetching url %s from cache %s", url, cache_dir)
    try:
        digest = hashlib.sha256(url.encode('utf-8')).digest()
        filepath = os.path.join(cache_dir,
            "f" + base64.urlsafe_b64encode(digest).decode('utf-8'))
    except:
        digest = hashlib.sha256(url).digest()
        filepath = os.path.join(cache_dir,
            "f" + base64.urlsafe_b64encode(digest))

    try:
        with open(filepath, 'r', encoding='utf-8-sig', newline='') as f:
            cached = f.read().split('\r\n\r\n\r\n', 1)
        if len(cached) == 2:
            headers, content = cached
            try:
                content = content.encode('utf-8')
            except:
                # already encoded as bytes
                pass
            headers = Message(headers)
            return FetchResult(headers, content, url, filepath)
    except IOError:
        raise Exception("fetch() failed")


def do_udhr(fetchresult):
    out = {}
    text = fetchresult.content.decode('utf-8').split('---', 1)[1]
    out['location'] = fetchresult.url
    out['genre'] = 'Legal'
    paras = []
    for paragraph in text.splitlines():
        paragraph = paragraph.strip()
        if len(paragraph) > 0:
            paras.append(paragraph)
    out['text'] = paras
    return out


# corpuscrawler: crawl_ga.py
_ENGLISH_MONTHS = {
    'january': 1,
    'february': 2,
    'march': 3,
    'april': 4,
    'may': 5,
    'june': 6,
    'july': 7,
    'august': 8,
    'september': 9,
    'october': 10,
    'november': 11,
    'december': 12
}


def _byline_to_pubdate(byline):
    date = re.search(r'(\d{1,2}) ([^ ]+?) (\d{4})', byline)
    if not date:
        return None
    day = int(date.group(1))
    year = int(date.group(3))
    month = _ENGLISH_MONTHS[date.group(2).lower()]
    if not month:
        return None
    out = "{}-{:0>2d}-{:0>2d}".format(year, month, day)
    return out


def _rte_writable_paragraph(text):
    if text == '':
        return False
    if text.startswith('© RTÉ '):
        return False
    if text.startswith('By using this website, you consent'):
        return False
    if text.startswith('RTÉ.ie is the website of Raidió Teilifís Éireann'):
        return False
    if text.find('is not responsible for the content') >= 0:
        return False
    if text.find('RTÉ uses cookies in accordance with our Cookie Policy') >= 0:
        return False
    if re.match('^[\*\+]+$', text):
        return False
    return True


def _rte_cleanall(html):
    section_article_regex = re.compile(r'<section[^>]+itemprop="articleBody"[^>]*>')
    search = section_article_regex.search(html)
    out = []
    if search:
        body = extract(search.group(0), '</section>', html)
        for para in clean_paragraphs(body):
            if _rte_writable_paragraph(para):
                out.append(para)
        return '\n'.join(out)
    for paragraph in re.findall(r'<p>(.+?)</p>', html):
        cleaned = cleantext(paragraph)
        if _rte_writable_paragraph(cleaned):
            out.append(cleaned)
        else:
            continue
    return out


def _sceala_clean(paras):
    out = []
    for para in paras:
        if '\n____' not in para:
            out.append(para)
        else:
            out.append(para.split('\n____')[0])
            break
    return out


def do_nuachtrte(fetchresult):
    out = {}
    pubdate_regex = re.compile(r'name="DC.date" (?:scheme="DCTERMS.URI" )?content="([0-9T:+\-]{19,25})"')
    html = fetchresult.content.decode('utf-8')
    pubdate_match = pubdate_regex.search(html)
    pubdate = pubdate_match.group(1) if pubdate_match else None
    if pubdate is None: pubdate = fetchresult.headers.get('Last-Modified')
    out['location'] = fetchresult.url
    if 'nuacht' in fetchresult.url:
        out['genre'] = 'News'
    if pubdate:
        out['publication-date'] = pubdate
    title = re.search(r'<title>(.+?)</title>', html)
    if title:
        title = striptags(title.group(1).split('- RTÉ')[0]).strip()
    if title:
        out['title'] = cleantext(title)
    cleaned = _rte_cleanall(html)
    if '/sceala/' in fetchresult.url:
        cleaned = _sceala_clean(cleaned)
    out['text'] = cleaned
    return out


def do_meoneile_ie(fetchresult):
    out = {}
    html = fetchresult.content.decode('utf-8')
    title = extract(r'<title>', '</title>', html).strip()
    title = title.split('&lt;')[0].strip() if title else ''
    video = re.search(r"<iframe.*src='(//player.vimeo.com/video/[0-9]+)[^>]*></iframe>", html)
    body = extract("<div class='article-content'>", '</article>', html) or ''
    byline = extract("<div class='byline'>", '</span>', html) or ''
    byline = _byline_to_pubdate(byline)
    if body.find('<strong>%s</strong>' % title) >= 0:
        out['title'] = title
    paras = clean_paragraphs(body)
    if paras:
        out['location'] = fetchresult.url
        out['genre'] = 'News'
    if video:
        out['video'] = f'https:{video.group(1)}'
    if byline:
        out['publication-date'] = byline
    paras_filt = []
    for para in paras:
        if para == 'Roinn':
            continue
        else:
            paras_filt.append(para)
    out['text'] = paras_filt
    return out


def do_irishtimes(fetchresult):
    out = {}
    html = fetchresult.content.decode('utf-8')
    pubdatere1 = re.compile(r'<meta itemprop="datePublished" content="([^"]*)"/>')
    pubdatere2 = re.compile(r'"datePublished": "([^"])"')
    out['location'] = fetchresult.url
    out['genre'] = 'News'
    title = re.search(r'<title>(.+?)</title>', html)
    pubdate_match = pubdatere1.search(html)
    pubdate_match = pubdate_match if pubdate_match else pubdatere2.search(html)
    pubdate = pubdate_match.group(1) if pubdate_match else None
    if pubdate is None:
        pubdate = fetchresult.headers.get('Last-Modified')
    if pubdate:
        out['publication-date'] = pubdate
    if title:
        out['title'] = cleantext(title.group(1))
    paras = []
    for paragraph in re.findall(
            r'<p class="no_name">(.+?)</p>',
            html.split('<div class="article_bodycopy">')[1]):
        cleaned = cleantext(paragraph)
        paras.append(cleaned)
    out['text'] = paras


def do_blogspot(fetchresult):
    out = {}
    pubdate_regex = re.compile(
        r"<abbr class='published' title='([^']*)'>[^<]*</abbr>")
    html = fetchresult.content.decode('utf-8')
    pubdate_match = pubdate_regex.search(html)
    pubdate = pubdate_match.group(1) if pubdate_match else None
    if pubdate is None: pubdate = fetchresult.headers.get('Last-Modified')
    title = re.search(r"<meta content='([^']+)' property='og:title'/>",
                      html)
    title = title.group(1) if title else ''
    post = extract("<div class='post-body entry-content'>",
                    "<div class='post-footer'>", html)
    if post == None:
        post = extract("<div class='post-header'>",
                        "<div class='post-footer'>", html)
    if post == None:
        post = extract('<div class="post-body">',
                        '<p class="post-footer">', html)
    paras = clean_paragraphs(post)
    if paras:
        out['title'] = title
        out['location'] = fetchresult.url
        out['genre'] = 'News'
        if pubdate:
            out['publication-date'] = pubdate
        out['text'] = paras
    return out


def do_ainm_ie(fetchresult):
    out = {}
    html = fetchresult.content.decode('utf-8')
    title = re.search(r'<title>(.+?)</title>', html)
    title = title.group(1).split('|')[0] if title else ''
    body = extract('<div class="article">',
                    '<!-- .contentWrapper-->', html) or ''
    body = body.split('<div id="machines"')[0]
    paras = clean_paragraphs(body)
    pubdate = fetchresult.headers.get('Last-Modified')
    if paras:
        out['title'] = title
        out['location'] = fetchresult.url
        out['genre'] = 'Biography'
        if pubdate:
            out['publication-date'] = pubdate
        out['text'] = paras
    return out


def do_tuairisc_ie(fetchresult):
    out = {}
    pubdate_regex = re.compile(
        r'<time datetime="(20\d\d-\d\d-\d\d)\s+(\d\d:\d\d)" '
        r'itemprop="datePublished">')
    html = fetchresult.content.decode('utf-8')
    title = extract('<h1 class="title article--full__title">', '</h1>',
                    html) or ''
    pubdate_match = pubdate_regex.search(html)
    if pubdate_match:
        pubdate = '%sT%s:00Z' % (
            pubdate_match.group(1), pubdate_match.group(2))
    body = extract(
        '<div class="article--full__content" itemprop="articleBody">',
        '</article>', html)
    if body:
        paras = clean_paragraphs(body)
        if paras:
            out['title'] = title
            out['location'] = fetchresult.url
            out['genre'] = 'News'
            if pubdate:
                out['publication-date'] = pubdate
            out['text'] = paras
        return out


def do_coislife_ie(fetchresult):
    out = {}
    html = fetchresult.content.decode('utf-8')
    title = re.search(r'<title>(.+?)</title>', html)
    title = title.group(1).split('&#8211;')[0].strip() if title else ''
    desc = re.search(r'<meta property="og:description" content="([^"]+?)"', html)
    desc = cleantext(desc.group(1))
    body = extract('<div class="tab-content">',
                    '<div class="entry-content in fade tab-pane" id="tab-additional_information">', html) or ''
    paras = clean_paragraphs(title + '<br/>' + body)
    pubdate = fetchresult.headers.get('Last-Modified')
    if paras:
        out['title'] = title
        out['location'] = fetchresult.url
        out['genre'] = 'Commerce'
        if desc:
            out['description'] = desc
        if pubdate:
            out['publication-date'] = pubdate
        outp = []
        for para in paras:
            if para.find('Léigh sliocht as an leabhar') >= 0:
                continue
            else:
                outp.append(para)
        out['text'] = outp
    return out


def do_chg(fetchresult):
    out = {}
    def _chg_content(page):
        return page.split('<div class="container" id="article">')[1].split('<!-- /.right columns -->')[0]
    phtml = fetchresult.content.decode('utf-8')
    ptext = _chg_content(phtml)
    title = re.search(r'<title>(.+?)</title>', phtml)
    if title: title = striptags(title.group(1).split('|')[0]).strip()
    pubdate = fetchresult.headers.get('Last-Modified')
    out['location'] = fetchresult.url
    out['genre'] = 'Government'
    if pubdate:
        out['publication-date'] = pubdate
    if title:
        out['title'] = title
    paras = []
    for paragraph in re.findall(r'<p>(.+?)</p>', ptext):
        cleaned = cleantext(paragraph)
        paras.append(cleaned)
    out['text'] = paras
    return out


def do_peig_ie(fetchresult):
    out = {}
    def peig_cat(page):
        if page.find('/imeachtai/') >= 0:
            return 'Events'
        elif page.find('peig.ie/20') >= 0:
            return 'News'
        elif page.find('/fol%C3%BAntais/') >= 0:
            return 'Job listings'
        else:
            return ''
    # Peig.ie has a lot of posts from other sites
    html = fetchresult.content.decode('utf-8')
    title = re.search(r'<title>(.+?)</title>', html)
    title = title.group(1).split('|')[0].strip() if title else ''
    if '<meta property="article:modified_time"' in html:
        date = re.search(r'<meta property="article:modified_time" content="([^"]+)"', html).group(1)
    else:
        date = re.search(r'"datePublished":"([^"]+)"', html).group(1)
    body = extract('<div class="uk-margin-medium-top" property="text">', '<ul class="uk-pagination', html) or ''
    paras = clean_paragraphs(body)
    genre = peig_cat(fetchresult.url)
    if paras:
        out['location'] = fetchresult.url
        if title:
            out['title'] = title
        if genre:
            out['genre'] =  genre
        if date:
            out['publication-date'] = date
        out['text'] = paras
    return out


def do_forasnagaeilge_ie(fetchresult):
    out = {}
    pubdate_regex = re.compile(r'"datePublished":"([^"]+)",')
    html = fetchresult.content.decode('utf-8')
    if '<html class="no-js" lang="en">' in html:
        return {}
    title = extract('<title>', ' - www.forasnagaeilge.ie</title>',
                    html) or ''
    pubdate_match = pubdate_regex.search(html)
    if pubdate_match:
        pubdate = pubdate_match.group(1)
    body = extract(
        '<div id="main" class="container">',
        '</div><!-- /.content -->', html)
    if body:
        paras = clean_paragraphs(body)
    if paras:
        out['location'] = fetchresult.url
        out['genre'] = 'News'
        if title:
            out['title'] = title
        if pubdate:
            out['publication-date'] = pubdate
        out['text'] = paras
    return out


def _get_links(scrape):
    links = set()
    with open(scrape) as f:
        for url in f.readlines():
            links.add(url.rstrip())
    return list(links)
