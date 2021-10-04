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
import re

import datasets

import xml.etree.ElementTree as ET
import xml.sax.saxutils as saxutils

_DESCRIPTION = """\
Press Releases from Department of Children January - May 2019

Distributed by European Language Resource Infrastructure (ELRI)

This collection contains 353 Translation Units of Irish and English
"""

_ELRC_PAGE = "https://elrc-share.eu/repository/browse/press-releases-from-department-of-children-january-may-2019/e11867269d9a11e9a7e100155d0267067257b03f9ef04af696e0f583ddabdc58/"

_URL = "https://elrc-share.eu/repository/download/e11867269d9a11e9a7e100155d0267067257b03f9ef04af696e0f583ddabdc58/"

_LICENCE = """\
Public Domain
The resource is free of all known legal restrictions.
"""

# These TUIDs have rather loose translations
# Mostly, these are either because the sentence was split in Irish,
# for simplicity, or because the translation omits parts of the
# English.
# TUIDs 48-53 in particular are misaligned, because of a missing
# space between full stop and start of next sentence in TUID 48.
# 313-315 are caused by a split in the Irish in 313, so the remainder
# of the English 313 is in 314 in Irish, with a knock-on to 315. 
# TUID 353 belongs here, because it is missing a verb, but we can
# fix it easily.
# 143-145 similarly has a missing full stop in the Irish date in 143.
# This is not an exhaustive list: I was just checking for junk characters!
_JUNK_IDS = [20, 24, 26, 30, 32, 33, 40, 48, 49, 50, 51, 52, 53, 141, 143, 144, 145, 147, 313, 314, 315]



def _clean_en(text):
    if text.startswith("· "):
        text = text[2:]
    return text

def _clean_ga(text, tuid=None):
    if text.startswith("· "):
        text = text[2:]
    elif text.startswith("- "):
        text = text[2:]
    elif text.startswith("D &apos;"):
        text = text.replace("D &apos;", "D&apos;")
    text = text.replace(" d &apos;", " d&apos;")
    if tuid == "353":
        text += " a laghdú"
    return text