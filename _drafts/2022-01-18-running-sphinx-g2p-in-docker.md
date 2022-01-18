```
FROM bitspeech/tensor2tensor:1.6.6-gpu

RUN apt-get update

RUN apt-get install -y wget git

RUN pip install git+https://github.com/cmusphinx/g2p-seq2seq
```
