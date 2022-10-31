ls
tail -f todo-new.log 
git add nemo_text_processing/text_normalization/sv/taggers/cardinal.py 
git commit -s -m 'finished?'
git log
tail -f todo-new.log 
cd .psst/
ls web.archive.org/
find . -name web
cd ts
ls
tail -f todo-new.log 
tail -f .psst/ts/todo-new.log 
grep Saving .psst/ts/todo-new.log |wc
tail -f  .psst/ts/todo-new.log 
cd .psst/ts/
ls
grep Saving todo-new.log > sav
less sav 
cat todo-new|sed -e 's#http://web.archive.org/web/https://##'|while read i;do b=$(echo $i|awk -F'?' '{print $1}'); grep $b sav || echo http://web.archive.org/web/https://$i >> todo-new.f;done
wc -l todo-new.f
wc -l todo-new
mv todo-new.f todo-new
rm -rf web.archive.org/
nohup wget -x -c -o todo-new.log -i todo-new &
tail -f  todo-new.log 
less todo-new.log 
killall wget
rm -rf web.archive.org/
nohup wget -x -c --trust-server-names -o todo-new.log -i todo-new &
tail -f  todo-new.log 
last|head
cd ..
cd .psst/ts/
tail -f  todo-new.log 
grep Saving todo-new.log |wc
less todo-new.log 
ls
ps aux|grep wget
tail -f  todo-new.log 
grep Saving todo-new.log 
tail -f  todo-new.log 
l
w
tail -f  todo-new.log 
cd ..
mkdir tsx
rm -rf tsx/faced/
rm -rf tsx/
tail -f  todo-new.log 
cd ts/
tail -f  todo-new.log 
cd ..
cp nemo_text_processing/text_normalization/es/taggers/date.py nemo_text_processing/text_normalization/sv/taggers/
£cp nemo_text_processing/text_normalization/es/data/money/currency_major.tsv nemo_text_processing/text_normalization/sv/data/money
mkdir nemo_text_processing/text_normalization/sv/data/money
cp nemo_text_processing/text_normalization/es/data/money/currency_major.tsv nemo_text_processing/text_normalization/sv/data/money
git add nemo_text_processing/text_normalization/sv/data/money/currency_major.tsv 
git commit -s -m 'add currency major'
git log
touch nemo_text_processing/text_normalization/sv/data/money/currency_plurals.tsv 
vi nemo_text_processing/text_normalization/sv/data/money/currency_plurals.tsv 
git add  nemo_text_processing/text_normalization/sv/data/money/currency_plurals.tsv 
git add nemo_text_processing/text_normalization/sv/data/money/currency_major.tsv 
git commit -s -m 'add currency plurals'
cd nemo_text_processing/text_normalization/es/taggers/
for i in *;do if [ ! -e ../../sv/taggers/$i ];then cp $i ../../sv/taggers/;fi;done
cd ../verbalizers/
cd ..
cp -r verbalizers/ ../sv/
cd ..
cd sv/verbalizers/
ls
git add __init__.py 
git commit -s -m 'copy from es/'
git add verbalize.py verbalize_final.py 
git commit -s -m 'adapt from es/'
git log
git diff
cd ..
cd data/
ls
mkdir ordinals
vi ordinals/digit.tsv
vi ordinals/teen.tsv
git add ordinals/digit.tsv ordinals/teen.tsv 
git commit -s -m 'teens/digits'
git add ../verbalizers/electronic.py 
git commit -s -m 'adapt from es/'
git add ../verbalizers/decimals.py 
git commit -s -m 'adapt from es/'
git log
git diff ../taggers/cardinal.py 
git add ../taggers/cardinal.py 
git commit -s -m 'fix million/millard..trillion/trilliard'
git log
git add ../taggers/cardinal.py 
git commit -s -m 'fix some spelling'
source /home/joregan/miniconda3/bin/activate
conda activate fs2
git add ../taggers/cardinal.py 
git commit -s -m 'default to space before "tusen"'
tail -f  .psst/ts/todo-new.log 
w
last|head
tail -f  .psst/ts/todo-new.log 
source /home/joregan/miniconda3/bin/activate
conda activate fs2
rm -rf waxholm
git clone https://huggingface.co/datasets/KTH/waxholm
conda activate fs2
python3
tail -f  .psst/ts/todo-new.log 
cd .psst/ts/
grep Saving todo-new.log > sav
cat todo-new|sed -e 's#http://web.archive.org/web/https://##'|while read i;do b=$(echo $i|awk -F'?' '{print $1}'); grep $b sav || echo http://web.archive.org/web/https://$i >> todo-new.f;done
mv todo-new.f todo-new
rm -rf web.archive.org/
nohup wget -x -c --trust-server-names -o todo-new.log -i todo-new &
tail -f todo-new.log 
grep dub todo-new|wc
wc -l todo-new
tail -f todo-new.log 
less todo-new.log 
tail -f todo-new.log 
tail -f  .psst/ts/todo-new.log 
conda activate fs2
python3
python
tail -f  .psst/ts/todo-new.log 
grep Saving todo-new.log > sav
cd .psst/ts/
grep Saving todo-new.log > sav
cat todo-new|sed -e 's#http://web.archive.org/web/https://##'|while read i;do b=$(echo $i|awk -F'?' '{print $1}'); grep $b sav || echo http://web.archive.org/web/https://$i >> todo-new.f;done
cd .psst/ts/
ls
wc -l todo-new
wc -l todo-new.f 
rm todo-new.f 
cat todo-new|sed -e 's#http://web.archive.org/web/https://##'|while read i;do b=$(echo $i|awk -F'?' '{print $1}'); grep $b sav || echo http://web.archive.org/web/https://$i >> todo-new.f;done
mv todo-new.f todo-new
wc -l todo-new
nohup wget -x -c --trust-server-names -o todo-new.log -i todo-new &
tail -f todo-new.log 
conda activate fs2
python
last|head
cd .psst/ts/
ls
rm -rf web.archive.org/
less sav 
tail -f todo-new.f 
ls
tail -f  .psst/ts/todo-new.log 
cd .psst/ts/
grep Saving todo-new.log > sav
cat todo-new|sed -e 's#http://web.archive.org/web/https://##'|while read i;do b=$(echo $i|awk -F'?' '{print $1}'); grep $b sav || echo http://web.archive.org/web/https://$i >> todo-new.f;done
mv todo-new.f todo-new
wc -l todo-new
ls
rm -rf web.archive.org/
rm todo-new.log 
nohup wget -x -c --trust-server-names -o todo-new.log -i todo-new &
tail -f todo-new.log 
cd psst-data/
ls
cd ..
mkdir ljspeech
cd ljspeech/
ls
wget https://data.keithito.com/data/speech/LJSpeech-1.1.tar.bz2
tar jxvf LJSpeech-1.1.tar.bz2 
ls
cd LJSpeech-1.1/
ls
less metadata.csv 
tail -f  .psst/ts/todo-new.log 
find .psst/ts/web.archive.org
tail -f  .psst/ts/todo-new.log 
top
tail -f  .psst/ts/todo-new.log 
cd ljspeech/
ls
rm LJSpeech-1.1
rm LJSpeech-1.1.tar.bz2 
ls
cd LJSpeech-1.1/
ls
ls wavs/
mkdir wav16
£for i in wavs/*;do 
conda activate fs2
conda install sox
for i in wavs/*;do ffpmeg -i $i -ar 16000 $(echo $i|sed -e 's/wavs/wav16/');done
conda install ffmpeg
for i in wavs/*;do ffpmeg -i $i -ar 16000 $(echo $i|sed -e 's/wavs/wav16/');done
conda install ffmpeg
which ffmpeg
for i in wavs/*;do /home/joregan/miniconda3/envs/fs2/bin/ffmpeg -i $i -ar 16000 $(echo $i|sed -e 's/wavs/wav16/');done
ls
ls wav16/
ls -al wav16
ls -al wavs
ls -al wav16
ffprobe wav16/LJ050-0278.wav 
ls
pwd
grep "' " metadata.csv 
grep "s'" metadata.csv 
grep "s'" metadata.csv |less
less text.tsv 
cat text.tsv |awk -F'\t' '{print $2}'
cat text.tsv |awk -F'\t' '{print $2}'|sed -e 's/[a-z ]//g'
cat text.tsv |awk -F'\t' '{print $2}'|sed -e 's/[a-z ]//g'|grep -v '^$'
cat text.tsv |awk -F'\t' '{print $2}'|sed -e 's/[-a-z ]//g'|grep -v '^$'
cat text.tsv |less
cat text.tsv |awk -F'\t' '{print $2}'|sed -e 's/[a-z ]//g'|grep -v '^$'
ls
pwd
less ../../frames.tsv 
cat ../../frames.tsv |awk '{print $2}'
cat ../../frames.tsv |awk '{print $2}'|head -n 30 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
echo $((16000 * 60 * 10))
cat ../../frames.tsv |awk '{print $2}'|head -n 100 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
cat ../../frames.tsv |awk '{print $2}'|head -n 90 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
cat ../../frames.tsv |awk '{print $2}'|head -n 95 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
cat ../../frames.tsv |awk '{print $2}'|head -n 93 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
cat ../../frames.tsv |awk '{print $2}'|head -n 92 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
echo $((9600000 - 9464570))
perl -e 'print 135430 / 16000.0'
wc -l ../../frames.tsv 
wc -l ../../frames.tsv |awk '{print $1}'
head -n $(( $(wc -l ../../frames.tsv |awk '{print $1}') - 92 )) ../../frames.tsv 
head -n $(( $(wc -l ../../frames.tsv |awk '{print $1}') - 92 )) ../../frames.tsv |wc
head -n $(( $(wc -l ../../frames.tsv |awk '{print $1}') - 92 )) ../../frames.tsv |grep 135430
head -n $(( $(wc -l ../../frames.tsv |awk '{print $1}') - 92 )) ../../frames.tsv |awk 'BEGIN{max=135430;highest=0;id=""}{if($2<=max && $2 > highest){highest=$2;id=$1;}}END{print id}'
head -n $(( $(wc -l ../../frames.tsv |awk '{print $1}') - 92 )) ../../frames.tsv |awk 'BEGIN{max=135430;highest=0;id=""}{if($2<=max && $2 > highest){highest=$2;id=$1;}}END{print id "\t" highest}'
head -n 92 ../../frames.tsv 
head -n 92 ../../frames.tsv |awk '{print $1}' >> 10min.ids
head -n $(( $(wc -l ../../frames.tsv |awk '{print $1}') - 92 )) ../../frames.tsv |awk 'BEGIN{max=135430;highest=0;id=""}{if($2<=max && $2 > highest){highest=$2;id=$1;}}END{print id "\t" highest}'
head -n $(( $(wc -l ../../frames.tsv |awk '{print $1}') - 92 )) ../../frames.tsv |awk 'BEGIN{max=135430;highest=0;id=""}{if($2<=max && $2 > highest){highest=$2;id=$1;}}END{print id}' >> 10min.ids 
wc -l 10min.ids 
less 10min.ids 
cat 10min.ids |sort|uniq|wc
echo $((16000 * 60 * 20))
cat ../../frames.tsv |awk '{print $2}'|head -n 175 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
cat ../../frames.tsv |awk '{print $2}'|head -n 185 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
cat ../../frames.tsv |awk '{print $2}'|head -n 188 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
cat ../../frames.tsv |awk '{print $2}'|head -n 190 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
cat ../../frames.tsv |awk '{print $2}'|head -n 189 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
head -n 188 ../../frames.tsv |awk '{print $1}' >> 20min.ids
#head -n $(( $(wc -l ../../frames.tsv |awk '{print $1}') - 92 )) ../../frames.tsv |awk 'BEGIN{max=135430;highest=0;id=""}{if($2<=max && $2 > highest){highest=$2;id=$1;}}END{print id}' >> 10min.ids 
cat ../../frames.tsv |awk '{print $2}'|head -n 188 |awk 'BEGIN{total=0}{total+=$0}END{print total}'
head -n $(( $(wc -l frames.tsv |awk '{print $1}') - 188 )) frames.tsv |awk 'BEGIN{max=105070;highest=0;id=""}{if($2<=max && $2 > highest){highest=$2;id=$1;}}END{print id}' 
less 20min.ids 
echo LJ028-0034 >> 20min.ids 
cat ../../frames.tsv 
cat ../../frames.tsv |awk 'BEGIN{total=0}{total += $2}END{print total}'
perl -e 'print 1377879296 / 16000'
wc -l ../../frames.tsv 
echo $((1310 * 2))
tail -n 2620 ../../frames.tsv 
tail 20min.ids 
tail -n 2620 ../../frames.tsv |grep LJ028-0034
tail 10min.ids
tail -n 2620 ../../frames.tsv |grep LJ045-0202
ls
mkdir w2v
cd w2v/
wget https://dl.fbaipublicfiles.com/fairseq/wav2vec/wav2vec_small.pt https://dl.fbaipublicfiles.com/fairseq/wav2vec/wav2vec_small_960h.pt
conda activate fs2
ls
pwd
conda install -c anaconda mkl
pip3 install pyflashlight
cd ..
git clone https://github.com/flashlight/flashlight/
cd flashlight/
ls
cd bindings/python/
ls
conda install kenlm
pip install kenlm
ls
ls ../../../
conda install -c eumetsat fftw3
pip install https://github.com/kpu/kenlm/archive/master.zip
conda install cmake
python3 setup.py install
nvidia-smi 
conda install -c nvidia/label/cuda-11.3.0 cuda-nvcc
python3 setup.py install
which nvcc
nvcc
conda install -c conda-forge cudatoolkit-dev
conda install -c conda-forge cudatoolkit-dev=11.3
python3 setup.py install
conda install mkl-include
python3 setup.py install
ls
cd ../../../
git clone https://github.com/kpu/kenlm
cd kenlm/
mkdir build
cd build/
cmake ..
conda install boost
cmake ..
make -j 4
make install
ls
make install -DCMAKE_INSTALL_PREFIX=/home/joregan/miniconda3/envs/fs2/
cmake -DCMAKE_INSTALL_PREFIX=/home/joregan/miniconda3/envs/fs2/ ..
make 
make install
cd -
cd ../flashlight/bindings/python/
python setup.py test
python setup.py install
cd ..
conda install vcpkg
cd ..
cd miniconda3/envs/fs2/
ls
mkdir git
cd git/
$ git clone https://github.com/microsoft/vcpkg
git clone https://github.com/microsoft/vcpkg
cd vcpkg/
ls
./bootstrap-vcpkg.sh 
ls
cd 
cd flashlight/
ls
../miniconda3/envs/fs2/git/vcpkg/vcpkg 
../miniconda3/envs/fs2/git/vcpkg/vcpkg install
../miniconda3/envs/fs2/git/vcpkg/vcpkg install flashlight-cuda
tail -f  .psst/ts/todo-new.log 
cd .psst/ts/
grep Saving todo-new.log > sav
cat todo-new|sed -e 's#http://web.archive.org/web/https://##'|while read i;do b=$(echo $i|awk -F'?' '{print $1}'); grep $b sav || echo http://web.archive.org/web/https://$i >> todo-new.f;done
ls
rm -rf web.archive.org/
mv todo-new.f todo-new
nohup wget -x -c --trust-server-names -o todo-new.log -i todo-new &
tail -f todo-new.log 
conda activate fs2
cd flashlight/
../miniconda3/envs/fs2/git/vcpkg/vcpkg install flashlight-cuda
conda install -c anaconda cudnn
../miniconda3/envs/fs2/git/vcpkg/vcpkg install flashlight-cuda
conda install -c conda-forge cudnn
../miniconda3/envs/fs2/git/vcpkg/vcpkg install flashlight-cuda
ls
less cmake/FindCUDNN.cmake 
ls ../miniconda3/envs/fs2/
ls ../miniconda3/envs/fs2/share/
less ../miniconda3/envs/fs2/lib/cudatoolkit_config.yaml 
ls /usr/local/cuda/
runall(){ python psstbaseline/step_2_audio_to_logits.py  --model-name $1 --logits-dir out/logits/$1 ; python psstbaseline/step_3_decode.py --logits-dir out/logits/$1 --decode-dir out/decode/$1; python psstbaseline/step_4_correctness.py --decode-dir out/decode/$1 --correctness-dir out/anal/$1 ; pssteval-asr out/anal/$1/correctness-valid.tsv --out-dir out/eval/$1 ; }
conda activate fs2
cd .psst/
runall birgermoell/psst-fairseq-pitch-shift-timit
last|head
source /home/joregan/miniconda3/bin/activate
conda activate fs2
conda activate fs2
ls
cd .psst/
ls
ls
cd .psst/
ls
find . -name '*tsv'
less ./tmp/psst-fairseq-pitch-shift-timit-decoded-valid.tsv
less ./out1/data/rir/train.tsv
less ./out1/data/rir/test.ltr 
less ./out1/data/rir/train.
less ./out1/data/rir/train.ltr 
tail -f  .psst/ts/todo-new.log 
find .psst -name '*ids'
find . -name '*ids'
ls ljspeech/LJSpeech-1.1/
less ljspeech/LJSpeech-1.1/text.tsv 
less ljspeech/LJSpeech-1.1/metadata.csv 
ls
conda activate fs2
ls 
ls $PWD/ljspeech/LJSpeech-1.1/wav16/
echo $PWD/ljspeech/LJSpeech-1.1/wav16/
ls /home/joregan/ljspeech/
ls /home/joregan/ljspeech/data
mkdir /home/joregan/ljspeech/data
ls
ls *.ids
find . -name 10min.ids
diff -u 10min.ids ljspeech/LJSpeech-1.1/10min.ids 
#mv *.ids ljspeech/LJSpeech-1.1/*.ids 
mkdir /home/joregan/ljspeech/ids
mv *.ids ljspeech/LJSpeech-1.1/*.ids /home/joregan/ljspeech/ids/
ls
less dev.tsv 
ls /home/joregan/ljspeech/LJSpeech-1.1/wav16
for i in dev.tsv train.tsv test.tsv ;do cat $i|awk -F'\t' 'BEGIN{print "/home/joregan/ljspeech/LJSpeech-1.1/wav16"}{print $1 ".wav\t" $2}'; done
for i in dev.tsv train.tsv test.tsv ;do cat $i|awk -F'\t' 'BEGIN{print "/home/joregan/ljspeech/LJSpeech-1.1/wav16"}{print $1 ".wav\t" $2}'; done|less
for i in dev.tsv train.tsv test.tsv ;do cat $i|awk -F'\t' 'BEGIN{print "/home/joregan/ljspeech/LJSpeech-1.1/wav16"}{print $1 ".wav\t" $2}' > ljspeech/data/$i;done
mv ljspeech/data/dev.tsv ljspeech/data/valid.tsv
less /home/joregan/ljspeech/ids/40min.ids 
less /home/joregan/ljspeech/ids/30min.ids 
less /home/joregan/ljspeech/ids/10min.ids 
less /home/joregan/ljspeech/ids/4h.ids 
less ljspeech/data/20min.tsv 
less ljspeech/data/train.tsv 
ls ljspeech/ids/*h.ids
ls ljspeech/data/5mins.tsv 
less ljspeech/data/5mins.tsv 
tail ljspeech/data/10mins.tsv 
tail ljspeech/ids/10min.ids 
grep LJ039-0028 train.tsv 
tail ljspeech/ids/10min.ids 
tail ljspeech/data/
ls ljspeech/data/
source /home/joregan/miniconda3/bin/activate
conda activate fs2
ls *ipynb
less ljspeech-frames.ipynb 
rm ljspeech-frames.ipynb get-ljspeech-frames.ipynb 
conda activate fs2
mkdir .ljs
cd .ljs
pip install kaggle
kaggle kernels output jimregan/create-ljspeech-splits -p data
mkdir ../.kaggle
mv ../kaggle.json ../.kaggle/
kaggle kernels output jimregan/create-ljspeech-splits -p data
ls
mkdir model
cd model/
wget https://dl.fbaipublicfiles.com/fairseq/wav2vec/wav2vec_small_960h.pt
ls
cd ..
ls data/
for i in data/*s;do echo $i;done
for i in data/*s;do echo $i;done|awk -F/ '{print $NF}'
mkdir runs
for i in data/*s;do echo $i;done|awk -F/ '{print $NF}'|while read j;do mkdir runs/$j;done
ls runs/
cd runs/5mins/
mkdir ../../config
vi ../../config/base_960h.yaml
cd ../../model/
pwd
cd -
vi ../../config/base_960h.yaml
# !fairseq-hydra-train task.data=../input/create-ljspeech-splits/10mins/ model.w2v_path=wav2vec_small_960h.pt --config-dir config --config-name base_960h
#fairseq-hydra-train task.data= /home/joregan/.ljs/data/  model.w2v_path=wav2vec_small_960h.pt --config-dir config --config-name base_960h
fairseq-train --help
pwd
cd ..
ls
cd data/
pwd
less ../../.bash_history 
cd ../model/
pwd
ls
sh ../../run-fairseq.sh 5mins 2
cd ..
ls
find data -type f
find data -name '*ltr'
find data -name '*ltr'|perl -pi.bak -ane '{print uc}'
find data -name '*ltr'
find data -name '*ltr'|while read i;do cat perl -pi.bak '{print uc}' $i;done
find data -name '*ltr'|while read i;do cat perl -pi -e '{print uc}' $i;done
find data -name '*ltr'|while read i;do perl -pi -e '{print uc}' $i;done
find data -name '*ltr'
cat data/20mins/train.ltr
rm -rf data/
kaggle kernels output jimregan/create-ljspeech-splits -p data
cp data/test.ltr .
perl -pi -e uc test.ltr 
less test.ltr 
perl -pi -e 'print uc' test.ltr 
less test.ltr 
cp data/test.ltr .
perl -pi -e '$_=uc($_)' test.ltr 
less test.ltr 
rm test.ltr 
find data -name '*ltr'|while read i;do perl -pi -e '{$_=uc($_)}' $i;done
find data -type f
less data/35mins/train.ltr
wget https://dl.fbaipublicfiles.com/fairseq/wav2vec/dict.ltr.txt
for i in data/*s;do echo $i;done
for i in data/*s;do cp dict.ltr.txt $i;done
sh ../../run-fairseq.sh 5mins 2
sh ../run-fairseq.sh 5mins 2
ls runs/5mins/
sh ../run-fairseq.sh 5mins 2
find data -name '*ltr'
find data -name '*ltr'|xargs cat {} \;
find data -name '*ltr'|xargs cat {} \;|tr ' ' '\n'|sort|uniq
find data -name '*ltr'|xargs cat '{}; \;|tr ' ' '\n'|sort|uniq
find data -name '*ltr'|xargs cat {} \;
find data -name '*ltr'|xargs cat {} \; > /tmp/thing
find data -name '*ltr'|xargs cat '{}' ';' > /tmp/thing
find data -name '*ltr'|while read i;do cat $i;done
find data -name '*ltr'|while read i;do cat $i;done|tr ' ' '\n'|sort|uniq
find data -name '*ltr'|while read i;do cat $i;done|tr ' ' '\n'|sort|uniq|wc
wc -l dict.ltr.txt 
cat dict.ltr.txt 
cat dict.ltr.txt |awk '{print $1}' > chars-dict
find data -name '*ltr'|while read i;do cat $i;done|tr ' ' '\n'|sort|uniq > chars-data
diff -u chars-dict chars-data 
cat dict.ltr.txt |awk '{print $1}'|sort > chars-dict
diff -u chars-dict chars-data 
ls
cd model/
wget https://dl.fbaipublicfiles.com/fairseq/wav2vec/wav2vec_small.pt
cd -
sh ../run-fairseq.sh 5mins 2
#find data -name '*ltr'|while read i;do perl -pi -e 's#/kaggle/input/ljspeech-for-asr/wav16/#' $i;done
less data/35mins/train.tsv 
ls /home/joregan/ljspeech/LJSpeech-1.1/wav16 
#find data -name '*ltr'|while read i;do perl -pi -e 's#/kaggle/input/ljspeech-for-asr/wav16##' $i;done
#find data -name '*tsv'|while read i;do perl -pi -e 's#/kaggle/input/ljspeech-for-asr/wav16#/home/joregan/ljspeech/LJSpeech-1.1/wav16#' $i;done
find data -name '*tsv'|while read i;do perl -pi -e 's#/kaggle/input/ljspeech-for-asr/wav16#/home/joregan/ljspeech/LJSpeech-1.1/wav16#' $i;done
less data/35mins/train.tsv 
tmux
tmux attach
cd .psst/
ls
cd ts
ls
tail todo-new.log 
rm -rf web.archive.org/
ls
cd ..
ls
ls web.archive.org/
find web.archive.org -type f
tmux attach
less .psst/step_1c_convert_fairseq_to_huggingface.py 
cd .ljs/
cp ../.psst/step_1c_convert_fairseq_to_huggingface.py  .
ls
ls model/
mkdir hf
ls runs/
conda activate fs2
python step_1c_convert_fairseq_to_huggingface.py 
ls model/
python step_1c_convert_fairseq_to_huggingface.py 
ls model/
python step_1c_convert_fairseq_to_huggingface.py 
ls hf/5mins/
less hf/5mins/config.json 
tmux attach
conda activate fs2
python
mv liepa-lithuanian/ asasd
git clone https://huggingface.co/birgermoell/liepa-lithuanian
cp asasd/*json liepa-lithuanian/
python
cd liepa-lithuanian/
ls
git add *json
git commit -m 'config pieces'
git log
git format-patch -1 510933c0bb6ca8c459af68afb608af8833457b6e
cd .ljs/
conda activate fs2
python step_1c_convert_fairseq_to_huggingface.py 
ls runs/
python step_1c_convert_fairseq_to_huggingface.py 
cd .ljs/
ls
find runs -type f
find runs -type f|grep /runs/
find runs -type f|grep /runs/|awk '{print $NF}'|sort | uniq -c
find runs -type f|grep /runs/|awk '{print $NF}'|sort | uniq -c|grep -v ' 1 '
cd wav2vec-ljspeech-splits/
ls
git checkout -b splits
conda activate fs2
git checkout -b splits
git branch
ls
git checkout -b runs
git checkout 5mins runs 
git add runs/
git commit -m 5mins
git checkout 10mins runs 
git commit -m 10mins
git checkout 15mins runs 
git commit -m 15mins
git checkout 20mins runs 
git commit -m 20mins
git checkout 25mins runs 
git commit -m 25mins
ls
find runs/ -type f
git checkout main 
git push -a
git push --all
git checkout main 
ls
git checkout -b 30mins
cp -r ../runs/30mins/runs/ .
git add runs/
git push --all
ls
git branch
git checkout 10mins
cp ../hf/10mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 15mins
cp ../hf/15mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 20mins
cp ../hf/20mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 25mins
cp ../hf/25mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 30mins
cp ../hf/30mins/* .
git add config.json pytorch_model.bin 
ls
git commit -m hf
git checkout 35mins
cp ../hf/35mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 40mins
cp ../hf/40mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 45mins
cp ../hf/45mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 50mins
cp ../hf/50mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 55mins
cp ../hf/55mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 60mins
cp ../hf/60mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 65mins
cp ../hf/65mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 70mins
cp ../hf/70mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 75mins
cp ../hf/75mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git checkout 80mins
cp ../hf/80mins/* .
git add config.json pytorch_model.bin 
git commit -m hf
git push --all
df
cd ..
python step_1c_convert_fairseq_to_huggingface.py 
ls
ls hf
du hf
rm -rf hf
mkdir hf
ls
ls model/
ls runs/
for i in runs/*mins;do echo rm -rf $i;done
python step_1c_convert_fairseq_to_huggingface.py 
ls
cd wav2vec-ljspeech-splits/
ls
git branch
ls
git checkout main 
git checkout 16hrs runs 
git checkout 16hrs config.json
git checkout 16hrs pytorch_model.bin
git checkout 14hrs runs 
git checkout 12hrs runs 
git checkout 10hrs runs 
git checkout 8hrs runs 
git checkout 6hrs runs 
git checkout 4hrs runs 
git checkout 120mins runs 
git commit -m 'add model from 16hrs; runs from 2-16 hours'
git push
git rm -rf runs/
git checkout 16hrs runs 
git commit -m 'just keep this model\'s runs'
git commit -m "just keep this model's runs"
git push
cd ..
ls
ls ..
cd ..
ls asasd/
rm -rf asasd/
rm -rf flashlight/
ls liepa-lithuanian/
rm -rf liepa-lithuanian/
rm -rf kenlm/
ls
ls nst/
cd .psst/
ls
find web.archive.org -type f
rm -rf web.archive.org/
ls
ls done/
ls
ls foo/
ls home/
ls home/joregan/
rm -rf home/
ls working-repo/
rm -rf working-repo/
ls tt
rm -rf tt
ls
rm -rf timit
rm -rf timit-base/
rm timit_*
ls
less convert_xslr_model.py 
ls
rm nohup.out 
ls
rm -rf lmcomb/
rm -rf rir
rm -rf rir-hf/
ls
rm EchoThiefImpulseResponseLibrary.zip 
ls
rm Audio.zip 
rm -rf cmudict/
ls
ls foo/
rm -rf foo/
rm -rf out
rm -rf out1/
df
du .
rm -rf psst*
ls
ls asd/
rmdir asd
rm -rf done/
ls pretrained/
rm -rf pretrained/
l
ls lmbin/
rmdir lmbin/
ls
cd ..
ls
rm -rf psst-data/
ls w2v/
rm -rf w2v/
ls
df
ls
cd .ljs/
ls
kaggle kernels output jimregan/cmu-us-awb-arctic-fairseq-files -p awb-fs
ls data/
less awb-fs/cmu-us-awb-arctic-fairseq-files.log 
mkdir awb-all
cp awb-fs/*ltr awb-all/
ls
cd wav2vec-ljspeech-splits/
ls
git branch
git checkout 5mins
git checkout -b 5mins-2
git rm -rf runs/
cp -r ../runs/5mins/runs/ .
git add runs/
git commit -m 'new run'
git checkout 5mins-fairseq 
git checkout -b 5mins-fairseq-2
cp ../runs/5mins/checkpoint_* .
git add checkpoint_*
git commit -m 'new run'
ls
git checkout 5mins-2 
cp ../hf/5mins/* .
git diff
git commit -m 'new run'
git checkout 10mins
ls
git log
git rm -rf runs/
cp -r ../runs/10mins/runs/ .
git add runs/
git commit -m 'new run'
cp ../hf/10mins/* .
git add config.json pytorch_model.bin 
git commit -m 'new run'
git log
git branch
git checkout -b 10mins-2
git checkout 10mins
git log
git reset --hard c0aa1105001b065880ffe33866455d687da4db9a
git log
git checkout 10mins-fairseq 
git checkout -b 10mins-fairseq-2
mv ../runs/10mins/checkpoint_* .
git add chec*
git commit -m 'new run'
git checkout 10mins-2 
ls
git log
git checkout 15mins
git checkout -b 15mins-2
git rm -rf runs/
mv ../runs/15mins/runs/ .
git add runs/
git commit -m 'new run'
mv ../hf/15mins/* .
git add .
git commit -m 'new run'
git checkout 15mins-fairseq 
git checkout -b 15mins-fairseq-2
mv ../runs/15mins/checkpoint_* . && git add checkpoint_* && git commit -m 'new run'
git checkout 20mins
git checkout -b 20mins-2
git rm -rf runs/
mv ../runs/20mins/runs/ .
git add runs/
git commit -m 'new run'
mv ../hf/20mins/* .
git add .
git commit -m 'new run'
git checkout 20mins-fairseq 
git checkout -b 20mins-fairseq-2
mv ../runs/20mins/checkpoint_* . && git add checkpoint_* && git commit -m 'new run'
git checkout 25mins
git rm -rf runs/
mv ../runs/25mins/runs/ .
git add runs/
git commit -m 'new run'
mv ../hf/25mins/* .
git add .
git commit -m 'new run'
git checkout 25mins-fairseq 
mv ../runs/25mins/checkpoint_* .
git add checkpoint_*
git commit -m 'new run'
git branch
git log
git checkout -b 25mins-fairseq-2
git checkout 25mins-fairseq
git log
git reset --hard 33a8aad3645777d97042554caac1676699795576
git checkout 30mins
ls
git rm -r runs/
mv ../runs/30mins/runs/ .
git add runs/
git commit -m 'new run'
mv ../hf/30mins/* .
git add .
git commit -m 'new run'
git checkout 30mins-fairseq 
git checkout -b 30mins-fairseq-2
mv ../runs/30mins/checkpoint_* .
git add checkpoint_*
git commit -m 'new run'
git checkout 30mins
git log
git checkout -b 30mins-2
git checkout 30mins
git reset --hard 482512c2314b12fa615fdf2348cabfce0453eb56
git push --all
git checkout 25mins
git log
git checkout -b 25mins-2
git checkout 25mins
git log
git reset --hard 54279dda0ba2cbfd559802f537ba267956d1528e
git push origin 25mins-2 
git push --force origin 25mins
git log
ls
cd ..
git clone https://huggingface.co/jimregan/wav2vec-awb
cd wav2vec-awb/
ls
mv ../runs/awb-all/runs/ .
git add runs/
git commit -m tensorboard
git checkout -b all-cp
ls
mv ../runs/awb-all/checkpoint_* .
git add checkpoint_
git add checkpoint_*
git commit -m checkpoints
git checkout main 
ls
mv ../hf/awb-all/* .
git add config.json pytorch_model.bin 
git commit -m hf
git push --all
git remote show
git remote show origin 
ls
cd ..
ls
less data/awb-all/train.tsv 
less data2/10mins/test.tsv 
less data2/10mins/valid.tsv 
less data2/10mins/train.tsv 
find data2 -name test.tsv|while read i;do mv $i tmpf; echo "/home/joregan/.ljs/cmu_us_awb_arctic/wav" >> $i; cat tmpf >> $i; rm tmpf;done
less data2/10mins/test.tsv 
find data2 -name valid.tsv|while read i;do mv $i tmpf; echo "/home/joregan/.ljs/cmu_us_awb_arctic/wav" >> $i; cat tmpf >> $i; rm tmpf;done
less data2/10mins/valid.tsv 
find data2 -name train.tsv|while read i;do perl -pi.bak -e 's#/kaggle/input/ljspeech-for-asr/wav16#/home/joregan/.ljs/cmu_us_awb_arctic/wav#' $i;done
ls runs/
ls
cd wav2vec-awb/
ls
git log
git checkout -b blank 2475d6dc763fa11630ef19ee9d4fe3e4cea7eb48
git log
git checkout -b 5mins
ls
mv ../runs/5mins/runs/ .
git add runs/
git commit -m tensorboard
git checkout blank 
git checkout -b 10mins
mv ../runs/10mins/runs/ .
git add runs/
git checkout -b 10mins
git commit -m tensorboard
git checkout blank 
git checkout -b 15mins
mv ../runs/15mins/runs/ .
git add runs/
git commit -m tensorboard
git checkout blank 
git checkout -b 20mins
mv ../runs/20mins/runs/ .
git add runs/
git commit -m tensorboard
cd ..
python step_1c_convert_fairseq_to_huggingface.py 
ls hf/
python step_1c_convert_fairseq_to_huggingface.py 
ls runs/40mins/
python step_1c_convert_fairseq_to_huggingface.py 
cd wav2vec-awb/
ls
git log
git checkout 5mins 
mv ../hf/5mins/* .
git add .
git commit -m hf
git log
git checkout -b 5mins-fs 5e0b01fcfc1384a9b1eda77832f83f06f3a7609e
mv ../runs/5mins/checkpoint_* .
git add checkpoint_*
git log
git commit -m checkpoints
git log
git checkout 10mins 
ls
git checkout -b 10mins-fs 
mv ../runs/5mins/checkpoint_* .
mv ../runs/10mins/checkpoint_* .
git add checkpoint_*
git commit -m checkpoints
git branch -a
git checkout 10mins
ls
mv ../hf/10mins/* .
git add .
git commit -m hf
git checkout 15mins 
git checkout -b 15mins-fs
ls
mv ../runs/15mins/checkpoint_* .
git add checkpoint_*
git commit -m checkpoints
git checkout 15mins
ls
mv ../hf/15mins/* .
git add .
git commit -m hf
git checkout 20mins 
git checkout -b 20mins-fs
mv ../runs/20mins/checkpoint_* .
git add checkpoint_*
git commit -m checkpoints
git checkout 20mins
mv ../hf/20mins/* .
git add .
git commit -m hf
git branch -a
git checkout blank 
git checkout -b 25mins
mv ../runs/25mins/runs/ .
git add runs/
git commit -m tensorboard
git checkout -b 25mins-fs
mv ../runs/25mins/checkpoint_* ,.
ls
mv ../runs/25mins/checkpoint_* .
ls
git add checkpoint_*
git commit -m checkpoints
git checkout 25mins
mv ../hf/25mins/* .
git add .
git commit -m hf
git checkout blank 
git checkout -b 30mins
mv ../runs/30mins/runs/ .
git add runs/
git commit -m tensorboard
git checkout -b 30mins-fs
mv ../runs/30mins/checkpoint_* .
git add checkpoint_*
git commit -m checkpoints
git checkout 30mins
git log
mv ../hf/30mins/* .
git add .
git commit -m hf
git checkout blank 
git checkout -b 35mins
mv ../runs/35mins/runs/ .
git add runs/
git commit -m tensorboard
git checkout -b 35mins-fs
mv ../runs/35mins/checkpoint_* .
git add checkpoint_*
git commit -m checkpoints
git checkout 35mins
mv ../hf/35mins/* .
git add .
git commit -m hf
git checkout blank 
git checkout -b 40mins
#mv ../runs/40mins/
ls -al ../runs/40mins/
mv ../runs/40mins/runs/ .
git add runs/
git commit -m tensorboard
git checkout -b 40mins-fs
mv ../runs/40mins/checkpoint_* .
git add checkpoint_*
git commit -m checkpoints
git checkout 40mins
ls
mv ../hf/40mins/* .
git add .
git commit -m hf
git checkout blank 
git checkout -b 45mins
git checkout blank 
git checkout -b 50mins
git checkout blank 
git checkout -b 55mins
git checkout blank 
git checkout -b 60mins
git checkout main 
mkdir kaggle-notebooks
pwd
cd kaggle-notebooks/
ls
git add cmu-us-awb-arctic-fairseq-files.ipynb 
ls
git add create-awb-splits.ipynb 
git commit -m 'add notebooks from Kaggle'
cd ..
mkdir splits
cd splits/
cd ..
rmdir splits/
kaggle kernels output jimregan/create-awb-splits -p splits
git add splits/
git commit -m 'add splits'
git rm splits/create-awb-splits.log splits/dict.ltr.txt 
find splits/ -name 'test.*' |while read i;do git rm $i;done
find splits/ -name 'valid.*' |while read i;do git rm $i;done
ls
find splits/ -type f
find splits/ -name dict.ltr.txt |while read i;do git rm $i;done
git commit -m 'prune'
ls splits/
kaggle kernels output jimregan/cmu-us-awb-arctic-fairseq-files -p data/all
git add data/all/
git commit -m 'all'
git rm data/all/cmu-us-awb-arctic-fairseq-files.log 
git commit -m rm
ls
git push --all
ls
git branch
git checkout 45mins 
mv ../runs/45mins/runs/ .
git add runs/
git commit -m tensorboard
git checkout -b 45mins-fs
#mv ../hf/45mins/* .
mv ../runs/45mins/checkpoint_* .
git add checkpoint_*
git commit -m checkpoints
git checkout 45mins
ls
mv ../hf/45mins/* .
git add .
git commit -m hf
ls
git checkout main 
ls kaggle-notebooks/
git checkout 45mins kaggle-notebooks/we/
git checkout 45mins kaggle-notebooks/wer/
git commit -m 'wer notebooks'
git checkout 45mins
git rm -r kaggle-notebooks/
git commit -m rm
ls
git checkout 50mins 
ls
mv ../runs/50mins/runs/ .
git add runs/
git commit -m tensorboard
git checkout 50mins-fs
git checkout -b 50mins-fs
mv ../runs/50mins/checkpoint_* .
git add checkpoint_*
git commit -m checkpoints
git checkout 50mins
mv ../hf/50mins/* .
git add .
git commit -m hf
git checkout 55mins 
mv ../runs/55mins/runs/ .
git add runs/
git commit -m tensorboard
git checkout 60mins 
mv ../runs/60mins/runs/ .
git add runs/
git commit -m tensorboard
git checkout 55mins 
ls
git checkout -b 55mins-fs
mv ../runs/55mins/checkpoint_* .
git add checkpoint_*
git commit -m checkpoints
git checkout 55mins
mv ../hf/55mins/* .
git add .
git commit -m hf
git checkout 60mins 
ls
git checkout -b 60mins-fs
mv ../runs/60mins/checkpoint_* .
git add checkpoint_*
git commit -m checkpoints
git checkout 60mins
ls
mv ../hf/60mins/* .
git add .
git commit -m hf
git push --all
git checkout main 
ls
git add kaggle-notebooks/wer/
git commit -m 'wer output'
git push --all
ls
less .psst/dict.ltr.txt 
conda activate fs2
w
last|head
ls ../
nvidia-smi 
cd .psst/
mkdir ti
cd ti/
instaloader efendi_music
rm -rf efendi_music/
nvidia-smi 
nvidia-smi -L
cd .ljs/
ls
cd wav2vec-awb/
ls
git log
git branch
ls
git checkout 45mins
conda activate fs2
git checkout 45mins
git diff
git log
git stash
git checkout 45mins
ls
git checkout 45mins-fs 
ls
cp checkpoint_best.pt ../runs/45mins/
cd ..
vi step_1c_convert_fairseq_to_huggingface.py 
python step_1c_convert_fairseq_to_huggingface.py 
cd wav2vec-awb/
git checkout 45mins
cp ../hf/45mins/* .
git status
git diff
ls -al
git add .
git commit -m 'reconvert'
ls -al ../hf/45mins/
ls -al ../hf/55mins/
git push
git push --all
git checkout main 
ls
git add kaggle-notebooks/wer/AWB_WER_plots.ipynb 
git commit -m 'add plot'
git push --all
cd .psst/
ls
ls tmp/
less tmp/psst-fairseq-pitch-shift-timit-decoded-test.tsv 
less tmp/psst-fairseq-pitch-shift-timit-decoded-valid.tsv 
ls
ls ts/
rm -rf ts/
ls
less convtr.py 
ls ti
less res.tsv 
less todo
less todo.log 
less run-timit-rir.py 
less fixme 
ls -al *arpa
less phones7.arpa 
less phones5.arpa 
ls
ls ..
ls
mkdir lmaug
cd lmaug/
unzip ../lm_aug.zip 
ls
cd ..
git clone https://github.com/PSST-Challenge/psstbaseline
cd psstbaseline/
ls
less step_4_correctness.py 
conda activate fs2
cd ../lmaug/
ls
mkdir corr
#python ../psstbaseline/step_4_correctness.py --decode-dir decaug/gaussian 
less ../psstbaseline/step_4_correctness.py 
ls
python ../psstbaseline/step_4_correctness.py --decode-dir decaug/gaussian --correctness-dir corr/gaussian
python ../psstbaseline/step_4_correctness.py --decode-dir decaug/gaussian --correctness-dir corr/gaussian test valid
ls
less corr/gaussian/correctness-valid.tsv 
less corr/gaussian/correctness-test.tsv 
cat corr/gaussian/correctness-test.tsv | awk -F'\t' '{print NF}'
cat corr/gaussian/correctness-test.tsv | awk -F'\t' '($4 != $5){print $4 "\t" $5}'
cat corr/gaussian/correctness-test.tsv | awk -F'\t' '($4 != $5){print $1 "\t" $4 "\t" $5}'
cat corr/gaussian/correctness-test.tsv |sed -e 's/ <sil> / /g'| awk -F'\t' '($4 != $5){print $1 "\t" $4 "\t" $5}'
ls
pssteval-asr --out-dir eval/gaussian corr/gaussian/correctness-*
less eval/gaussian/correctness-test-analysis.json 
conda activate fs2
ls
cd .psst/
ls
cd lmaug/
ls
ls lmtest/
for i in lmtest/*;do echo $i;done
for i in lmtest/* decaug/* ;do echo $i;done
ls
less eval/
less ../psstbaseline/step_4_correctness.py 
#for i in lmtest/* decaug/* ;do echo python ../psstbaseline/step_4_correctness.py --decode-dir $i   ;done
less ../psstbaseline/step_4_correctness.py 
for i in lmtest/* decaug/* ;do echo python ../psstbaseline/step_4_correctness.py --decode-dir $i --correctness-dir corr/$i   ;done
for i in lmtest/* decaug/* ;do python ../psstbaseline/step_4_correctness.py --decode-dir $i --correctness-dir corr/$i   ;done
for i in lmtest/* decaug/* ;do mkdir -p corr/$i; python ../psstbaseline/step_4_correctness.py --decode-dir $i --correctness-dir corr/$i   ;done
for i in lmtest/* decaug/* ;do mkdir -p corr/$i; python ../psstbaseline/step_4_correctness.py --decode-dir $i --correctness-dir corr/$i test valid  ;done
ls
for i in corr/lmtest/* corr/decaug/* ;do mkdir -p res/$i; pssteval-asr --out-dir res/$i  $i/*tsv  ;done
cd .psst/
ls
find . -type f
find . -name '*.tsv'
less ./manifest.tsv
find . -name '*.tsv'
less cleaner.tsv 
less manifest.tsv 
tail manifest.tsv 
wc -l manifest.tsv 
less /home/joregan/.cache/huggingface/datasets/downloads/extracted/34fddb36c6519410c037a7b3d44b064c9b183eeffa87c99e7443c10dcbb3ad6d/test_data.csv 
wc -l /home/joregan/.cache/huggingface/datasets/downloads/extracted/34fddb36c6519410c037a7b3d44b064c9b183eeffa87c99e7443c10dcbb3ad6d/*.csv
less /home/joregan/.cache/huggingface/datasets/downloads/extracted/34fddb36c6519410c037a7b3d44b064c9b183eeffa87c99e7443c10dcbb3ad6d/test_data.csv 
less /home/joregan/.cache/huggingface/datasets/downloads/extracted/34fddb36c6519410c037a7b3d44b064c9b183eeffa87c99e7443c10dcbb3ad6d/train_data.csv 
less manifest.tsv 
grep TEST manifest.tsv 
grep TRAIN manifest.tsv 
cat manifest.tsv |awk 'BEGIN{cnt=0}{cnt+=$2}END{print cnt}'
perl -e 'print 62127773 / 16000'
perl -e 'print  3882.9858125/ 100
perl -e 'print  3882.9858125/ 100'
perl -e 'print  3882.9858125/ 60'
conda list
ls 
ls miniconda3/
ls miniconda3/envs/
conda activate fs2
mkdir .foo
mv grab-full2 .foo/
cd .foo/
cat grab-full2 |head -n 10 | while read i;do instaloader $i;done
ls
rm -rf *
cd ..
rmdir .foo
nvidia-smi 
ew
w
nvidia-smi 
w
df
mkdir .wl
cd .wl/
conda create -n tscr
conda activate tscr
nvidia-smi 
top
w
cd .wl/
ls
ls -al
conda activate tscr
pip install instaloader
instaloader leagh_hxx eva0sullivan maevecarey1 viola.world
ls
ls -al
mkdir .tmp
cd .tmp/
conda activate tscr
pip install instaloader
instaloader ennybear_xo shiwanibassi anneorion afinskaya_anastasiys lisa.tjeng
ls
find . -name '*.py'
find . -name '*.py'|grep -v ./.local
find . -name '*.py'|grep -v ./.local|grep -v NeMo
find . -name '*.py'|grep -v ./.local|grep -v NeMo|grep -v miniconda
find . -name '*.py'|grep -v ./.local|grep -v NeMo|grep -v miniconda|grep -v vscode-server
find . -name '*.py'|grep -v ./.local|grep -v NeMo|grep -v miniconda|grep -v vscode-server|grep -v .cache
cd .ljs/
ls
less step_1c_convert_fairseq_to_huggingface.py 
ls
less dict.ltr.txt 
less chars-dict 
less chars-data 
w
mkdir .wspr
cd .wspr/
conda create --name whisper
conda activate whisper
conda install pip
which pip
pip install git+https://github.com/openai/whisper.git
pip install youtube-dl
youtube-dl https://www.youtube.com/watch?v=j7sk3Ym_UrE
whisper Best\ of\ Leif\ GW\ Persson\ i\ Brottsjournalen\ \(TV4\)-j7sk3Ym_UrE.mp4 --model large --language Swedish
CUDA_LAUNCH_BLOCKING=1 whisper Best\ of\ Leif\ GW\ Persson\ i\ Brottsjournalen\ \(TV4\)-j7sk3Ym_UrE.mp4 --model large --language Swedish
pip install --pre torch torchvision torchaudio -f https://download.pytorch.org/whl/nightly/cu111/torch_nightly.html
CUDA_LAUNCH_BLOCKING=1 whisper Best\ of\ Leif\ GW\ Persson\ i\ Brottsjournalen\ \(TV4\)-j7sk3Ym_UrE.mp4 --model large --language Swedish
pip uninstall  torch torchvision 
pip install --pre torch torchvision torchaudio -f https://download.pytorch.org/whl/nightly/cu111/torch_nightly.html
CUDA_LAUNCH_BLOCKING=1 whisper Best\ of\ Leif\ GW\ Persson\ i\ Brottsjournalen\ \(TV4\)-j7sk3Ym_UrE.mp4 --model large --language Swedish
nvidia-smi 
# pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
pip uninstall  torch torchvision 
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
whisper Best\ of\ Leif\ GW\ Persson\ i\ Brottsjournalen\ \(TV4\)-j7sk3Ym_UrE.mp4 --model large --language Swedish
conda install -c conda-forge ffmpeg
whisper Best\ of\ Leif\ GW\ Persson\ i\ Brottsjournalen\ \(TV4\)-j7sk3Ym_UrE.mp4 --model large --language Swedish
#whisper  --model large --language English
youtube-dl pit0OkNp7s8
whisper IRISH\ FARMER\'S\ STRONG\ ACCENT\ IN\ COUNTY\ KERRY\ IRELAND\ -\ MISSING\ SHEEP-pit0OkNp7s8.mp4  --model large --language English
youtube-dl 5pmZmUzhx9w
cd .wspr/
conda activate whisper
youtube-dl 5pmZmUzhx9w
conda activate whisper
youtube-dl 5pmZmUzhx9w
w
cd .wspr/
conda activate whisper
ls
rm Marion\ Cotillard\ Confused\ by\ Impossibly\ Irish\ Couch\ -\ The\ Graham\ Norton\ Show-5pmZmUzhx9w.f137.mp4.part 
ls
df
mkdir lvse
tmux
cd lvse/
ls -al *txt
less ./#valda_berattelser00.txt 
less ./#valda_berattelser00.mp3.txt 
less ./#valda_berattelser00.txt 
ls -al *txt
less baron_olsen01.txt 
ls -al *txt
less baron_olsen01.txt 
ls -al *txt
less baron_olsen16.txt 
cd lvse/
conda activate whisper
for i in *mp3; do  whisper --language Swedish --model large $i > $(basename $i .mp3).txt;done
cd lvse/
ls -al *txt
lsof
ls -al
ls -al *txt
less djaeknarne_06.txt 
ls -al *txt
less djaeknarne_06.mp3.txt 
nvidia-smi 
tmux
tmux attach
conda activate whisper
cd .wspr/
ls
whisper --help
whisper --help|less
nvidia-smi 
ls
mkdir thing
cd thing/
vi Dockerfile
docker build
docker build .
vi Dockerfile
docker build .
vi Dockerfile
docker build .
vi Dockerfile
docker build .
vi Dockerfile
docker build .
docker exec -it 6caf7fe8a89d /bin/bash
docker ps
w
nvidia-smi 
docker exec 6caf7fe8a89d ls
docker image ls
docker image ls|grep 6caf7fe8a89d
docker rm 6caf7fe8a89d 
docker image rm 6caf7fe8a89d 
docker build -t jim/whisper-test:v1 .
docker image ls
docker image ls|grep jim
docker exec -it jim/whisper-test /bin/bash
docker run -d --name whisper jim/whisper-test
docker run -d --name whisper jim/whisper-test:v1
docker exec -it whisper /bin/bash
docker start whisper 
docker exec -it whisper /bin/bash
docker start 5c83620b61b148ea1ee6c6ce540b0199908d98989e97e181e12081857563cd15
docker exec -it whisper /bin/bash
docker run -t -d --name whisper jim/whisper-test:v1
docker rm whisper
docker run -t -d --name whisper jim/whisper-test:v1
docker exec -it whisper /bin/bash
ls
ls ../.wspr/
docker rm whisper
docker stop whisper
docker rm whisper
docker run -t -d --name whisper -v "../.wspr:/workspace" jim/whisper-test:v1
ls ../waxholm
cd ..
mv .wspr/ wspr
cd -
docker run -t -d --name whisper -v "../wspr:/workspace" jim/whisper-test:v1
docker run -t -d --name whisper -v "/home/jim/wspr:/workspace" jim/whisper-test:v1
docker start whisper 
docker exec -it whisper /bin/bash
docker stop whisper
docker rm whisper
docker run -t -d --name whisper -v "/home/jim/wspr:/data" jim/whisper-test:v1
docker start whisper 
docker exec -it whisper /bin/bash
docker stop whisper
docker rm whisper
#docker run -t -d --name whisper -v "/home/jim/wspr:/workspace" jim/whisper-test:v1
ls /home/jim/wspr/
ls /home/jim/
ls /home/jim/wspr/
rmdir /home/jim/wspr/
sudo rmdir /home/jim/wspr/
sudo rmdir /home/jim/
docker run -t -d --name whisper -v "/home/joregan/wspr:/workspace" jim/whisper-test:v1
docker start whisper 
docker exec -it whisper /bin/bash
docker stop whisper
docker rm whisper
docker run -t -d --name whisper -v "/home/joregan/wspr:/workspace" jim/whisper-test:v1 --runtime=nvidia --gpus all
docker run -t -d --name whisper -v "/home/joregan/wspr:/workspace" jim/whisper-test:v1 --gpus all
docker rm whisper
docker run -t -d --name whisper -v "/home/joregan/wspr:/workspace" jim/whisper-test:v1 --gpus all
sudo dockerd --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
sudo pkill -SIGHUP dockerd
sudo dockerd --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
sudo systemctl daemon-reload   && sudo systemctl restart docker
sudo dockerd --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
docker run -t -d --name whisper -v "/home/joregan/wspr:/workspace" jim/whisper-test:v1 --gpus all
docker rm whisper
docker run -t -d --name whisper -v "/home/joregan/wspr:/workspace" jim/whisper-test:v1 --gpus all
ps aux|grep doclker
ps aux|grep docker
docker ls
docker image ls
docker stop whisper
docker rm whisper
docker run --gpus all nvidia/cuda:10.2-cudnn7-devel nvidia-smi
docker stop nvidia/cuda:10.2-cudnn7-devel 
docker run --gpus all -t -d --name whisper -v "/home/joregan/wspr:/workspace" jim/whisper-test:v1 
docker start whisper 
docker exec -it whisper /bin/bash
docker stop whisper
docker rm whisper
docker build -t jim/whisper-test:v1 .
docker image ls
docker image ls|grep jim
cat Dockerfile 
docker images ls
docker image ls
docker image ls|grep whis
docker image ls|grep hours
docker run --gpus all -t -d --name foo ac180f61009e
docker exec -it foo /bin/bash
docker stop foo
docker rm foo
docker image rm ac180f61009e
less Dockerfile 
nvidia-smi 
conda activate whisper
whisper --model small.en
whisper --model tiny.en
whisper --model tiny.en /dev/null
nvidia-smi 
less wspr/Marion\ Cotillard\ Confused\ by\ Impossibly\ Irish\ Couch\ -\ The\ Graham\ Norton\ Show-5pmZmUzhx9w.txt 
cd thing/
ls
vi Dockerfile 
cd wspr/
wget 'https://lyssna-cdn.sr.se/isidor/2022/09/program_webb_olena_ja_hans_20220929_1515222080_a96.m4a?_h_publicationId=8148325'
conda activate whisper
whisper --model large --language Finnish program_webb_olena_ja_hans_20220929_1515222080_a96.m4a\?_h_publicationId\=8148325  

whisper --model large --language Finnish program_webb_olena_ja_hans_20220929_1515222080_a96.m4a\?_h_publicationId\=8148325  > program_webb_olena_ja_hans_20220929_1515222080_a96.txt 
less program_webb_olena_ja_hans_20220929_1515222080_a96.txt 
youtube-dl https://www.youtube.com/watch?v=vjbG1qNPUS0
LS
ls
less 'program_webb_olena_ja_hans_20220929_1515222080_a96.m4a?_h_publicationId=8148325.vtt'
whisper --model large --language Finnish Daniel\ om\ sitt\ hjärtespråk\ meänkieli\ -\ textad\ på\ meänkieli-vjbG1qNPUS0.mkv 
mkdir rd
cd rd
vi links
grep mp4 links|wc
wget $(grep mp4 links)
cd ../thing/
docker build -t jim/whisper-test:v1 .
less ../.bash_history 
docker build -t jim/whisper-test:v1 .
less ../.bash_history 
docker stop e8ca41d6d30067ebe046312faa7533653429b694e68e3d45ed66b3e96391af88
docker rm e8ca41d6d30067ebe046312faa7533653429b694e68e3d45ed66b3e96391af88
docker stop a2a96298b5d00b7b36b06089fc3aaf285f4777b91979b1ab18a20d8d4b717b05
docker rm a2a96298b5d00b7b36b06089fc3aaf285f4777b91979b1ab18a20d8d4b717b05
docker stop 9892d2f93015ca67992e050f017c6b38da3696b785b9735cd40efc516dfecb62
docker rm 9892d2f93015ca67992e050f017c6b38da3696b785b9735cd40efc516dfecb62
docker stop ae649dbd3daea1ec8383e146bf30046b4461bffdda241c327486a748b2d375e5
docker rm ae649dbd3daea1ec8383e146bf30046b4461bffdda241c327486a748b2d375e5
docker run --gpus all -t -d --name foo 30c1ef9e2495
docker exec -it foo /bin/bash
docker stop ae649dbd3daea1ec8383e146bf30046b4461bffdda241c327486a748b2d375e5
docker rm ae649dbd3daea1ec8383e146bf30046b4461bffdda241c327486a748b2d375e5
docker stop 30c1ef9e2495
docker rm 30c1ef9e2495
docker image ls
docker image ls|grep whis
docker stop e5b764e9ff09896bf8219d83927d1608bbe9ec98edc7221ab01dabda72a4c012
docker rm e5b764e9ff09896bf8219d83927d1608bbe9ec98edc7221ab01dabda72a4c012
docker stop dc2e99251d2d8b689853a66b5fa10614cddcd6342c6e9f787ac33ad7e3d8e896
docker rm dc2e99251d2d8b689853a66b5fa10614cddcd6342c6e9f787ac33ad7e3d8e896
docker stop 84cd613c96341aeb9daa67e01958bb1e1d77411257ad9d7d831d5024e2a15bf7
docker rm 84cd613c96341aeb9daa67e01958bb1e1d77411257ad9d7d831d5024e2a15bf7
nvidia-asm
nvidia-smi 
ps aux|grep docker
ls 
docker stop 5a9f6e693f8c390619539352010771e7006e170579ddae245ee63007bcf125e3
docker rm 5a9f6e693f8c390619539352010771e7006e170579ddae245ee63007bcf125e3
docker stop efb7ca0693fe6ad6c6289bc6d3250ad2a96abe6c7eeae80f57b5b294059741a8
docker rm efb7ca0693fe6ad6c6289bc6d3250ad2a96abe6c7eeae80f57b5b294059741a8
ls
ls ../rd/
docker stop f742e629bb53084b74401c1fed0850e19ccfac6c698f2066219db26b9cd397cc
docker rm f742e629bb53084b74401c1fed0850e19ccfac6c698f2066219db26b9cd397cc
docker stop f742e629bb53084b74401c1fed0850e19ccfac6c698f2066219db26b9cd397cc
docker rm f742e629bb53084b74401c1fed0850e19ccfac6c698f2066219db26b9cd397cc
docker stop 42932cce04af55919e04bbe846ffcb91f5db6a6d5797cc09ed54a54903828432
docker rm 42932cce04af55919e04bbe846ffcb91f5db6a6d5797cc09ed54a54903828432
docker stop 4c1fa2ce532b0a4e710e8aff7fab8a10380234f8c65c8728620f80cc86e2ebae
docker rm 4c1fa2ce532b0a4e710e8aff7fab8a10380234f8c65c8728620f80cc86e2ebae
docker stop 2b03488eed9433b08e5d745143e9ea33c098af972e0efb5a0241ef0ad41a06bf
docker rm 2b03488eed9433b08e5d745143e9ea33c098af972e0efb5a0241ef0ad41a06bf
docker stop 358201c1bd2706ab53fecb9c786e6a5e4b1a6843bf247482caf6c24bc1af7223
docker rm 358201c1bd2706ab53fecb9c786e6a5e4b1a6843bf247482caf6c24bc1af7223
docker
docker container ls
docker stop 4272d14c1a91
docker rm 4272d14c1a91
docker container ls
docker stop 82f61df5373c
docker rm 82f61df5373c
docker container ls
nvidia-smi 
docker container ls
dkill() { docker stop $1; docker rm $1; }
dkill 41f85f4f9cea
dkill 6195597f0d38
dkill fe693a8c5891
docker container ls
dkill 210be7758da7
dkill 52c455e2c1d8
docker container ls
dkill eb11441757d2
dkill 5738a47b1221
dkill 79fb81e9ef9c
docker container ls
less ../.bash_history 
docker container ls
dkill 030a83c1ce05
docker container ls
dkill 997f0d3c1088
docker container ls
dkill ecdf7e89e144
docker container ls
dkill 7ae174a5dba3
dkill 6a7bf7fa97c7
docker container ls
dkill 5404a492be86
docker container ls
docker container ls|grep whisper
docker container ls|grep whisper|awk '{print $1}'
docker container ls|grep whisper|awk '{print $1}'|while read i;do dkill $i;done
docker container ls
dkill bbfbd99639c4c24763a177e8f9e3fa8e9d081996d7d82f9f5a4ada99bdcbd330
dkill 8dc930ffc33fb686be3d536e0ccd83a76e65e2eecc548bc0d5d55082dd179edd
dkill 4ca4f4593d0896d31d996b9772a7f730e4a2b8fef56c09b00fb1f326d6e4577c
dkill 2f9c8d38f7ffb6f163be70d2c153e38d979d55927d5777d507405a02e9eb323e
dkill f04360afcc99287b6ee8dc334efbfce46f3761a9b5908f1802b59225991687b2
dkill 388356da99bce52b5600d1117793c17745ee4c62439d1256318e3e2bf57d9a7c
dkill f04360afcc99287b6ee8dc334efbfce46f3761a9b5908f1802b59225991687b2
dkill 388356da99bce52b5600d1117793c17745ee4c62439d1256318e3e2bf57d9a7c
dkill b7a05358a989f3a21b3cbc7e309ecbb7630829a49249f4bd44b3e94d5db140e0
dkill f2ec28c28a72a927eb68ae324008d22388a602ee56ed885557d67de4ef1e160b
docker container 
dkill 8dac4d9b48217e78617ca4ca41e09925293c57a3c3c474574ad1f87af93d85ba
docker container ls|grep whisper|awk '{print $1}'|while read i;do dkill $i;done
nvidia-smi 
#for i in $(seq 0 7)
cd rd/
for i in *mp4; for t in $(seq 0 7);do echo $i $t;t=$(($t + 1));done
for i in *mp4; do for t in $(seq 0 7);do echo $i $t;t=$(($t + 1));done; done
ls *mp4|awk '{print NR " " $0}'
ls *mp4|awk '{print NR-1 " " $0}'
ls
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); echo $a $b;done
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d -v "/home/joregan/rd:/workspace" --name whisper$a 30c1ef9e2495; docker exec -it whisper$a "bash -c \"whisper --model large --language Swedish $b\"";done
docker rm 23a16cf70950ce5e9dcc20d1c5e718fcdb647ad6ab351441bf4e365411cc60c4
docker stop 23a16cf70950ce5e9dcc20d1c5e718fcdb647ad6ab351441bf4e365411cc60c4
docker rm 23a16cf70950ce5e9dcc20d1c5e718fcdb647ad6ab351441bf4e365411cc60c4
docker stop 67efd76ee1715b7b8129b59077da869be23f5b2876028795475b35208d943d54
docker rm 67efd76ee1715b7b8129b59077da869be23f5b2876028795475b35208d943d54
docker stop 75ee5e4fd1001b9c04724b3a6ccbfbf11fe503578b3b76ec9b5167426d1f8b37
docker rm 75ee5e4fd1001b9c04724b3a6ccbfbf11fe503578b3b76ec9b5167426d1f8b37
docker stop 62387b54a54381de4fc4cf4df1bf69e16d0854f1539d42db10bf0b5f90c03d45
docker rm 62387b54a54381de4fc4cf4df1bf69e16d0854f1539d42db10bf0b5f90c03d45
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d -v "/home/joregan/rd:/workspace" --name whisper$a 30c1ef9e2495; docker exec whisper$a "bash -c \"whisper --model large --language Swedish $b\"";done
docker ls
docker stop 7e7a1592197f2d69f277476d22a0196e8a8a1b94e82db6f8344e2f6bca5c34f0
docker rm 7e7a1592197f2d69f277476d22a0196e8a8a1b94e82db6f8344e2f6bca5c34f0
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d -v "/home/joregan/rd:/workspace" --name whisper$a 30c1ef9e2495; docker exec whisper$a "bash -c \"/opt/conda/bin/whisper --model large --language Swedish $b\"";done
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d -v "/home/joregan/rd:/workspace" --name whisper$a 30c1ef9e2495; docker exec whisper$a "bash -c \"/opt/conda/bin/whisper --model large --language Swedish /workspace/$b\"";done
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d -v "/home/joregan/rd:/workspace" --name whisper$a 30c1ef9e2495; docker exec whisper$a "bash -c \"/opt/conda/bin/whisper --model large --language Swedish /workspace/$b\"; ls /workspace";done
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d --name whisper$a -v "/home/joregan/rd:/workspace" 30c1ef9e2495; docker exec whisper$a "bash -c \"/opt/conda/bin/whisper --model large --language Swedish /workspace/$b\"; ls /workspace";done
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d --name whisper$a -v "/home/joregan/rd:/workspace" 30c1ef9e2495; docker exec whisper$a "/bin/bash -c \"/opt/conda/bin/whisper --model large --language Swedish /workspace/$b\"; ls /workspace";done
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); echo "/opt/conda/bin/whisper --model large --language Swedish /workspace/$b" > r$a.sh; chmod a+x r$a.sh;done
ls -al
cat r0.sh 
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d --name whisper$a -v "/home/joregan/rd:/workspace" 30c1ef9e2495; docker exec whisper$a /whisper/r$a.sh;done
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d --name whisper$a -v "/home/joregan/rd:/workspace" 30c1ef9e2495; docker exec whisper$a /workspace/r$a.sh;done
for i in r*sh;do cat $i;done
for i in r*sh;do mv $i tmp;echo '#!/bin/bash' >> $i; cat tmp >> $i;done
cat r7.sh 
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d --name whisper$a -v "/home/joregan/rd:/workspace" 30c1ef9e2495; docker exec whisper$a /workspace/r$a.sh;done
ls -al
chmod a+x *sh
ls -al
rm tmp 
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d --name whisper$a -v "/home/joregan/rd:/workspace" 30c1ef9e2495; docker exec whisper$a /workspace/r$a.sh;done
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -d --name whisper$a -v "/home/joregan/rd:/workspace" 30c1ef9e2495; docker exec whisper$a /workspace/r$a.sh;done
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d --name whisper$a -v "/home/joregan/rd:/workspace" 30c1ef9e2495; docker exec whisper$a /workspace/r$a.sh;done
ls
rm links 
ls *mp4|awk '{print NR-1 " " $0}'|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d --name whisper$a -v "/home/joregan/rd:/workspace" 30c1ef9e2495; docker exec -d whisper$a /workspace/r$a.sh;done
ls -al
ls *mp4|awk '{print NR-1 " " $0}'|head -n 1|while read i;do a=$(echo "$i"|awk '{print $1}'); b=$(echo "$i"|awk '{print $2}'); docker run --gpus $a -t -d --name whisper$a -v "/home/joregan/rd:/workspace" 30c1ef9e2495; docker exec -d whisper$a /workspace/r$a.sh;done
ls -al
nvidia-smi 
ls
nvidia-smi 
du .
ls
less 2442205170012477721_720p.mp4.txt 
less 2442205170012477721_720p.mp4.vtt 
nvidia-smi 
nvidia-smi 
ls
git clone https://github.com/shivammehta007/Neural-HMM
cd Neural-HMM/
ls
git submodule init; git submodule update
bash start.sh
less start.sh
ls
cd src/
ls
less training_module.py 
ls
less data_module.py 
find . -name '*py'|xargs grep split
less ./utilities/data.py 
find . -name '*py'|xargs grep load_filepaths_and_text
less ./utilities/data.py 
lesss .bash_history 
less .bash_history 
ls
cd .wl/
ls
cd ../ljspeech/
ls
less LJSpeech-1.1/text.tsv 
less LJSpeech-1.1/metadata.csv 
cd ..
wget http://festvox.org/cmu_arctic/dbs_bdl.html
rm dbs_bdl.html 
wget http://festvox.org/cmu_arctic/packed/cmu_us_rms_arctic.tar.bz2
tar jtvf cmu_us_rms_arctic.tar.bz2 
tar jxvf cmu_us_rms_arctic.tar.bz2 
cd cmu_us_rms_arctic/
ls
less etc/txt.done.data 
python
nvidia-smi 
sudo vi /etc/netplan/00-installer-config.yaml
ifconfig 
sudo vi /etc/netplan/00-installer-config.yaml
sudo netplan apply
ifconfig 
ping 10.210.242.10
sudo vi /etc/netplan/00-installer-config.yaml
sudo netplan apply
less /etc/netplan/00-installer-config.yaml
sudo vi /etc/netplan/00-installer-config.yaml
cp /etc/netplan/00-installer-config.yaml .
sudo vi /etc/netplan/00-installer-config.yaml
sudo netplan apply
ping www.google.se
sudo ifconfig eno1 down
ping www.google.com
last
last|head
w
sudo vi /etc/netplan/00-installer-config.yaml
less 00-installer-config.yaml 
sudo vi /etc/netplan/00-installer-config.yaml
less /etc/netplan/00-installer-config.yaml
route -n
sudo vi /etc/netplan/00-installer-config.yaml
sudo netplan apply
ping www.google.se
ping facebook.com
ping kth.se
sudo netplan apply
ping kth.se
ping 10.210.242.10
cat 00-installer-config.yaml 
ping 10.210.242.10
ping www.google.se
sudo vi /etc/netplan/00-installer-config.yaml
cat /etc/netplan/00-installer-config.yaml 
ping 10.210.242.10
w
last
last|head
ping 130.237.3.101
ssh 130.237.3.101
ping 130.237.3.101
last
last|head
last|less
ls
ls wspr/
ls rd
rm rd/2442205170012477721_720p.mp4.*
ls rd
cat rd/r0.sh 
nvidia-smi 
ls ~/.ssh/
ls .ssh/
nvidia-smi 
ls
ls psst-data/
ls .psst/
sudo mkdir /sbtal
sudo mount -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
sudo apt install nfs-common
ls -al /sbtal/
sudo mount -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
dme
dmesg 
netstat
ifconfig 
ping  tmh-vnas.net.kth.se
sudo vi /etc/netplan/00-installer-config.yaml 
sudo netplan apply 
ls -al /sbtal/
ls -al /sbtal/
sudo mount -o v3 -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
ls /sbtal/
ls -al /sbtal/
ls
mkdir notebooks21
mv *.ipynb notebooks21/
ls
mv *tsv notebooks21/
mv waxholm.py sav notebooks21/
ls
mv run-fairseq.sh 00-installer-config.yaml notebooks21/
ls
ls rd/
ls ljspeech/
sudo mv notebooks21/ /sbtal/joregan/
sudo mv cmu_us_rms_arctic /sbtal/joregan/
sudo mv ljspeech/ /sbtal/joregan/
ls
ls
sudo mv NeMo/ /sbtal/joregan/
ls wspr/
sudo mv wspr/  /sbtal/joregan/
mv thing/ bare-docker-for-whisper
sudo mv bare-docker-for-whisper/ /sbtal/joregan/
ls
sudo mv waxholm /sbtal/joregan/
ls lvse/
sudo mv lvse/ /sbtal/joregan/
mv .psst/ psst-experiments
sudo mv psst-experiments/ /sbtal/joregan/
ls
ls nst/
sudo mv nst/ /sbtal/joregan/
ls
sudo mv Neural-HMM/ /sbtal/joregan/
sudo mv cmu_us_rms_arctic.tar.bz2 /sbtal/joregan/
ls ljspeech/
find ljspeech/ -type f|wc
ls -al /sbtal/
ls -al /sbtal/joregan/
ls
cd teanglann/
tail -f raw-sounds 
ls
less wget-log 
wget -x -c https://www.teanglann.ie/CanC/An%20tAontas.mp3
wget -x -c https://www.teanglann.ie/CanU/An%20tAontas.mp3
wget -x -c https://www.teanglann.ie/CanM/An%20tAontas.mp3
grep '_' all 
grep '_' all |sed -e 's/_/%20/g'
wget -x -c $(grep '_' all |sed -e 's/_/%20/g')
tail all 
tail wget-log 
vi all 
tail wget-log 
wc -l all
find www.teanglann.ie -type f|wc
python
conda create --name hf
conda activate hf
which pip
conda install pip
which pip
pip install huggingface
pip install transformers
nvidia-smi 
conda install pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch
python
which python
python
pip install phonemizer
fg
python
conda install espeak
conda install espeak-ng
sudo apt install espeak-ng
python
tmux
mkdir teanglann
cd teanglann/
ls
lynx -dump https://www.teanglann.ie/ga/fuaim/_a
sudo apt install lynx
lynx -dump https://www.teanglann.ie/ga/fuaim/_a
lynx -dump https://www.teanglann.ie/ga/fuaim/_a |grep /ga/fuaim/
lynx -dump https://www.teanglann.ie/ga/fuaim/_a |grep /ga/fuaim/|awk '{print $NF}'
lynx -dump https://www.teanglann.ie/ga/fuaim/_a |grep /ga/fuaim/|awk '{print $NF}'|sed -e 's#/ga/fuaim/#/CanC/#;s/$/.mp3/'
for i in $(seq a z);do lynx -dump https://www.teanglann.ie/ga/fuaim/_$i |grep /ga/fuaim/|awk '{print $NF}';done > raw-sounds
for i in a b c d e f g h i j k l m n o p q r s t u v w x y z;do lynx -dump https://www.teanglann.ie/ga/fuaim/_$i |grep /ga/fuaim/|awk '{print $NF}';done > raw-sounds
wc -l raw-sounds 
cat raw-sounds |sort|uniq
cat raw-sounds |sort|uniq|wc
wc -l raw-sounds 
cat raw-sounds |sort|uniq|wc|sed -e 's#/ga/fuaim/#/CanC/#;s/$/.mp3/'
cat raw-sounds |sort|uniq|sed -e 's#/ga/fuaim/#/CanC/#;s/$/.mp3/'
cat raw-sounds |sort|uniq|sed -e 's#/ga/fuaim/#/CanC/#;s/$/.mp3/' > canc
cat raw-sounds |sort|uniq|sed -e 's#/ga/fuaim/#/CanU/#;s/$/.mp3/' > canu
cat raw-sounds |sort|uniq|sed -e 's#/ga/fuaim/#/CanM/#;s/$/.mp3/' > canm
cat can[cum] > all
wget -x -c -i all
wget -x -c -i all -o wget-log
nvidia-smi 
tail -f transcript.txt 
wc -l transcript.txt 
find www.teanglann.ie -type f|wc
tail -f transcript.txt 
conda activate hf
python
ls
less transcript.txt 
tmux attach
w
sudo apt install ffmpeg
conda activate hf
which ffmpeg 
ffmpeg -i 2442203270007255521_480p.mp4 -acodec pcm_s16le -ac 1 -ar 16000  out.wav
ls -al out.wav 
nvidia-smi 
ls
ls ls
ls
less 2442203270007255521_480p.json 
w
nvidia-smi 
conda activate hf
python
less 2442203270007255521_480p.json 
