```
FROM tensorflow/tensorflow:1.8.0-gpu


RUN apt-get update

RUN apt-get install -y wget git

RUN pip install git+https://github.com/tensorflow/tensor2tensor@v1.6.6
RUN git clone https://github.com/cmusphinx/g2p-seq2seq
```
