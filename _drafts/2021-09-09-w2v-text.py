#!/usr/bin/env python
# coding: utf-8

# In[ ]:


dir = "/home/jim/abair-corpora/"
col_names = ["id", "set", "gender", "url", "text", "phonemes"]


# In[ ]:


import os


# In[ ]:


inputs = []
for (path, dirs, files) in os.walk(dir):
    if "/comhra/" in path:
        continue
    if "corpusfile.txt" in files:
        inputs.append(os.path.join(path, "corpusfile.txt"))


# In[ ]:


from datasets import load_dataset
dset = load_dataset("csv", data_files=inputs, column_names=col_names, delimiter="\t", split="train", index_col=False)
dset = dset.filter(lambda x: x['text'] is not None)


# In[ ]:


def irish_lc(text):
    def lcword(word):
        if word[0:1] in "nt" and word[1:2] in "AÁEÉIÍOÓUÚ":
            return word[0:1] + "-" + word[1:].lower()
        else:
            return word.lower()
    return " ".join(list(map(lcword, text.split(" "))))


# In[ ]:


assert irish_lc("bhúr nAthair") == "bhúr n-athair"


# In[ ]:


import re
chars_to_ignore_regex = '[\,\?\.\!\-\;\:\"\“\%\‘\”…—–\(\)]'

def remove_special_characters(batch):
    batch["text"] = batch["text"].replace("’", "'")
    batch["text"] = batch["text"].replace("(Tor@m)", "")
    batch["text"] = re.sub(chars_to_ignore_regex, '', irish_lc(batch["text"]))
    batch["text"] = batch["text"].replace("\xa0", " ")
    batch["text"] = batch["text"].replace("\ufeff", "")
    batch["text"] = batch["text"].replace("1983", "naoi déag ochtó a trí")
    batch["text"] = batch["text"].replace("tg4", "t g ceathair")
    batch["text"] = re.sub('  +', ' ', irish_lc(batch["text"])) + " "
    return batch

dset = dset.map(remove_special_characters)


# In[ ]:


def is_all_alphabetic(batch):
    sentence = batch["text"]
    for char in sentence:
        if char not in "aábcdeéfghiíjklmnoópqrstuúvwxyz' ":
            return False
    return True
dset = dset.filter(is_all_alphabetic)


# In[ ]:


def extract_all_chars(batch):
  all_text = " ".join(batch["text"])
  vocab = list(set(all_text))
  return {"vocab": [vocab], "all_text": [all_text]}

vocab_train = dset.map(extract_all_chars, batched=True, batch_size=-1, keep_in_memory=True, remove_columns=dset.column_names)


# In[ ]:


#vocab_list = list(set(vocab_train["vocab"][0]) | set(vocab_test["vocab"][0]))
vocab_list = list(set(vocab_train["vocab"][0]))

vocab_dict = {v: k for k, v in enumerate(vocab_list)}
print(vocab_dict)


# In[ ]:


def fix_path(batch):
    batch["audio"] = batch["url"].replace("https://www.abair.tcd.ie/asr_data_irish_audio/", "/media/phonetics/asr_data_irish/audio/")
    return batch

dset = dset.map(fix_path)


# In[ ]:


from pathlib import Path
def check_paths(batch):
    audio_path = Path(batch["audio"])
    return audio_path.is_file()
dset = dset.filter(check_paths)


# In[ ]:


vocab_dict["|"] = vocab_dict[" "]
del vocab_dict[" "]


# In[ ]:


vocab_dict["[UNK]"] = len(vocab_dict)
vocab_dict["[PAD]"] = len(vocab_dict)
print(len(vocab_dict))


# In[ ]:


import json
with open('/home/jim/w2v-out/vocab.json', 'w') as vocab_file:
    json.dump(vocab_dict, vocab_file)


# In[ ]:


from transformers import Wav2Vec2CTCTokenizer

tokenizer = Wav2Vec2CTCTokenizer("/home/jim/w2v-out/vocab.json", unk_token="[UNK]", pad_token="[PAD]", word_delimiter_token="|")


# In[ ]:


from transformers import Wav2Vec2FeatureExtractor

feature_extractor = Wav2Vec2FeatureExtractor(feature_size=1, sampling_rate=16000, padding_value=0.0, do_normalize=True, return_attention_mask=True)


# In[ ]:


from transformers import Wav2Vec2Processor

processor = Wav2Vec2Processor(feature_extractor=feature_extractor, tokenizer=tokenizer)


# In[ ]:


import torchaudio

def speech_file_to_array_fn(batch):
    speech_array, sampling_rate = torchaudio.load(batch["audio"])
    batch["speech"] = speech_array[0].numpy()
    batch["sampling_rate"] = sampling_rate
    batch["target_text"] = batch["text"]
    return batch

dset = dset.map(speech_file_to_array_fn, remove_columns=dset.column_names)


# In[ ]:


import librosa
import numpy as np

def resample(batch):
    batch["duration"] = librosa.get_duration(y=batch["speech"], sr=batch["sampling_rate"])

    if batch["sampling_rate"] != 16_000:
        batch["speech"] = librosa.resample(np.asarray(batch["speech"]), batch["sampling_rate"], 16_000)
        batch["sampling_rate"] = 16_000

    return batch

dset = dset.map(resample, num_proc=4)


# In[ ]:


def filter_length(batch):
    length = batch["duration"]
    return length > 1.0 and length < 9.0
dset = dset.filter(filter_length)


# In[ ]:


def prepare_dataset(batch):
    # check that all files have the correct sampling rate
    assert (
        len(set(batch["sampling_rate"])) == 1
    ), f"Make sure all inputs have the same sampling rate of {processor.feature_extractor.sampling_rate}."

    batch["input_values"] = processor(batch["speech"], sampling_rate=batch["sampling_rate"][0]).input_values

    with processor.as_target_processor():
        batch["labels"] = processor(batch["target_text"]).input_ids
    return batch

dset = dset.map(prepare_dataset, remove_columns=dset.column_names, batch_size=8, num_proc=4, batched=True)


# In[ ]:


import torch

from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Union

@dataclass
class DataCollatorCTCWithPadding:
    """
    Data collator that will dynamically pad the inputs received.
    Args:
        processor (:class:`~transformers.Wav2Vec2Processor`)
            The processor used for proccessing the data.
        padding (:obj:`bool`, :obj:`str` or :class:`~transformers.tokenization_utils_base.PaddingStrategy`, `optional`, defaults to :obj:`True`):
            Select a strategy to pad the returned sequences (according to the model's padding side and padding index)
            among:
            * :obj:`True` or :obj:`'longest'`: Pad to the longest sequence in the batch (or no padding if only a single
              sequence if provided).
            * :obj:`'max_length'`: Pad to a maximum length specified with the argument :obj:`max_length` or to the
              maximum acceptable input length for the model if that argument is not provided.
            * :obj:`False` or :obj:`'do_not_pad'` (default): No padding (i.e., can output a batch with sequences of
              different lengths).
        max_length (:obj:`int`, `optional`):
            Maximum length of the ``input_values`` of the returned list and optionally padding length (see above).
        max_length_labels (:obj:`int`, `optional`):
            Maximum length of the ``labels`` returned list and optionally padding length (see above).
        pad_to_multiple_of (:obj:`int`, `optional`):
            If set will pad the sequence to a multiple of the provided value.
            This is especially useful to enable the use of Tensor Cores on NVIDIA hardware with compute capability >=
            7.5 (Volta).
    """

    processor: Wav2Vec2Processor
    padding: Union[bool, str] = True
    max_length: Optional[int] = None
    max_length_labels: Optional[int] = None
    pad_to_multiple_of: Optional[int] = None
    pad_to_multiple_of_labels: Optional[int] = None

    def __call__(self, features: List[Dict[str, Union[List[int], torch.Tensor]]]) -> Dict[str, torch.Tensor]:
        # split inputs and labels since they have to be of different lenghts and need
        # different padding methods
        input_features = [{"input_values": feature["input_values"]} for feature in features]
        label_features = [{"input_ids": feature["labels"]} for feature in features]

        batch = self.processor.pad(
            input_features,
            padding=self.padding,
            max_length=self.max_length,
            pad_to_multiple_of=self.pad_to_multiple_of,
            return_tensors="pt",
        )
        with self.processor.as_target_processor():
            labels_batch = self.processor.pad(
                label_features,
                padding=self.padding,
                max_length=self.max_length_labels,
                pad_to_multiple_of=self.pad_to_multiple_of_labels,
                return_tensors="pt",
            )

        # replace padding with -100 to ignore loss correctly
        labels = labels_batch["input_ids"].masked_fill(labels_batch.attention_mask.ne(1), -100)

        batch["labels"] = labels

        return batch


# In[ ]:


data_collator = DataCollatorCTCWithPadding(processor=processor, padding=True)


# In[ ]:


from datasets import load_metric
wer_metric = load_metric("wer")


# In[ ]:


def compute_metrics(pred):
    pred_logits = pred.predictions
    pred_ids = np.argmax(pred_logits, axis=-1)

    pred.label_ids[pred.label_ids == -100] = processor.tokenizer.pad_token_id

    pred_str = processor.batch_decode(pred_ids)
    # we do not want to group tokens when computing the metrics
    label_str = processor.batch_decode(pred.label_ids, group_tokens=False)

    wer = wer_metric.compute(predictions=pred_str, references=label_str)

    return {"wer": wer}


# In[ ]:


from transformers import Wav2Vec2ForCTC

model = Wav2Vec2ForCTC.from_pretrained(
    "facebook/wav2vec2-large-xlsr-53",
    attention_dropout=0.1,
    hidden_dropout=0.1,
    feat_proj_dropout=0.0,
    mask_time_prob=0.05,
    layerdrop=0.1,
    gradient_checkpointing=False,
    ctc_loss_reduction="mean",
    pad_token_id=processor.tokenizer.pad_token_id,
    vocab_size=len(processor.tokenizer)
)


# In[ ]:


model.freeze_feature_extractor()


# In[ ]:


from transformers import TrainingArguments

training_args = TrainingArguments(
  output_dir="/home/jim/w2v-out",
  group_by_length=False,
  per_device_train_batch_size=16,
  gradient_accumulation_steps=2,
  evaluation_strategy="steps",
  num_train_epochs=30,
  fp16=True,
  save_steps=400,
  eval_steps=400,
  logging_steps=400,
  learning_rate=3e-4,
  warmup_steps=500,
  save_total_limit=2,
)


# In[ ]:


train_testvalid = dset.train_test_split(test_size=0.05)
if not 'train' in train_testvalid:
    raise Exception("train_test_split() is broken: no 'train'")
if not 'test' in train_testvalid:
    raise Exception("train_test_split() is broken: no 'test'")


# In[ ]:


from transformers import Trainer

trainer = Trainer(
    model=model,
    data_collator=data_collator,
    args=training_args,
    compute_metrics=compute_metrics,
    train_dataset=train_testvalid["train"],
    eval_dataset=train_testvalid["test"],
    tokenizer=processor.feature_extractor,
)


# In[ ]:


trainer.train()

