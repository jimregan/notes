```
FROM bitspeech/tensor2tensor:1.6.6-gpu

RUN apt-get update &&\
    apt-get install -y wget git &&\
    pip install git+https://github.com/cmusphinx/g2p-seq2seq
```
