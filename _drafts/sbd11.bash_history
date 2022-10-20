cd riksdag-api-out/
ls
python3
nvidia-smi 
ls
ls|wc
find mhdownload.riksdagen.se -type f|wc
w
last
nvidia-smi 
w
ls
scp -r 130.237.67.68:/data/asr/asr/ .
scp -r joregan@130.237.67.68:/data/asr/asr/ .
w
mkdir docker-files
cd docker-files/
ls
less ../riksdag-uniq 
cd ..
mkdir riksdag-api-out
cd riksdag-api-out/
cat ../riksdag-uniq |awk -F_ '{print $NF}'
cat ../riksdag-uniq |awk -F_ '{print $NF}'|while read i;do wget https://www.riksdagen.se/api/videostream/get/$i;done
cat *
ls
cat H410228 
ls~wc
ls|wc
python
python3
less video_urls.txt 
wget -x -c -i video_urls.txt 
nohup wget -x -c -i video_urls.txt  &
tail -f nohup.out 
w
cd riksdag-api-out/
ls
tail -f nohup.out 
df
rm -rf mhdownload.riksdagen.se/
df
rm nohup.out 
ls
df
ls ..
cd ..
ls ..
df
du ..
ls ../jedlund/ftp/
ls ../jedlund/ftp/tal/
ls ../jedlund/ftp/fokusgrupp/
less ../jedlund/Dockerfile 
last
df ../chreri/
du ../chreri/
df
w
ls
ls ..
df
nvidia-smi 
df
ls
less riksdag-uniq 
ls riksdag-api-out/
ls riksdag-* |zip rd.zip -@
tar cvf rd.tar riksdag-*
gzip rd.tar 
ls -al rd.tar.gz 
w
ls
ls docker-files/
w
nvidia-s
nvidia-smi 
df
ls ..
df ../chreri/
du ../chreri/
ls
w
df
ls
w
df
df|grep -v snap
nvidia-smi 
ls
apt-cache search conda
apt-cache search conda|grep anac
wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.10.3-Linux-x86_64.sh
sh Miniconda3-py38_4.10.3-Linux-x86_64.sh 
tail .bashrc 
. .bashrc 
conda create --name diar
conda create --name diar 
conda activate diar
conda install pytorch torchaudio -c pytorch 
conda activate diar
conda install pytorch torchaudio -c pytorch 
conda install numpy cffi
conda install libsndfile=1.0.28 -c conda-forge
netstat
ssh 130.229.134.26
nvidia-smi 
ls
cd rd-vid/
ls
less 100933_20000_859510.rttm 
ls -al
less 100933_20000_859510.rttm 
ls
less 163129_20000_833940.rttm 
less 163016_20000_833489.rttm 
less 162947_20000_833255.rttm 
less 100933_20000_859510.rttm 
less 161761_20000_828375.rttm 
less 162349_20000_830950.rttm 
less 162438_20000_831916.rttm 
less 162947_20000_833255.rttm 
ls
less 163158_20000_834015.rttm 
ls
nvidia-smi 
ls
nvidia-smi 
ls
less 163438_20000_835047.rttm 
ls
ls *.rttm|wc
ls shared/videos/id
ls shared/videos/|wc
ls *.rttm|wc
ls
ls *.rttm|wc
vi thing.cc
g++ thing.cc 
vi thing.cc 
g++ thing.cc 
./a.out 
cat thing.cc 
g++ thing.cc 
./a.out 
ls
rm a.out Miniconda3-py38_4.10.3-Linux-x86_64.sh thing.cc 
ls
ls rd-vid/
mkdir test
cd test/
ls -al ../rd-vid/shared/
ls -al ../rd-vid/shared/videos/
cp ../rd-vid/shared/videos/194641_20000_1011173.mp4 .
mkdir test1
cp 194641_20000_1011173.mp4 test1/
mkdir test2
vi rttm.py
python rttm.py --outputdir test2 194641_20000_1011173.mp4 
less ../.conda/environments.txt 
conda activate diar
python rttm.py --outputdir test2 194641_20000_1011173.mp4 
rm rttm.py 
vi rttm.py
python rttm.py --outputdir test2 194641_20000_1011173.mp4 
ls test1/
ls test2/
ls
find . -type f
python rttm.py -v --outputdir test2 194641_20000_1011173.mp4 
ls test2
vi rttm.py
python rttm.py -v --outputdir test2 194641_20000_1011173.mp4 
rm rttm.py 
vi rttm.py
python rttm.py -v --outputdir test2 194641_20000_1011173.mp4 
ls test2/
python rttm.py -v --outputdir test2 194641_20000_1011173.mp4 
rm rttm.py 
vi rttm.py
python rttm.py -v --samedir test2 test1/194641_20000_1011173.mp4 
rm rttm.py 
vi rttm.py
python rttm.py -v --samedir test2 test1/194641_20000_1011173.mp4 
python rttm.py -v --samedir test1/194641_20000_1011173.mp4 
ls test1
python rttm.py -v --samedir --outputdir foo test1/194641_20000_1011173.mp4 
less rttm.py 
rm rttm.py 
vi rttm.py
python rttm.py -v --samedir --outputdir foo test1/194641_20000_1011173.mp4 
python rttm.py --help
sudo mount -t cifs -o user=joregan,nounix,sec=ntlmssp //130.229.134.26/riksdag $PWD/shared/
ls  shared/
which python
python rtti.py shared/videos/*mp4
conda install ffmpeg
python rtti.py shared/videos/*mp4
nvidia-smi 
cd rd-vid/shared/
ls *rttm\
ls *rttm
ls
cd videos/
ls
cd ..
ls
cd ..
ls
ls *rttm|wc
ls
less 192628_20000_996774.rttm 
ls *rttm|wc
ls
python
ls
ls *rttm|wc
ls
cd /tmp/
curl -fLo bazel-6.0.0-pre.20220201.3-linux-arm64 'https://objects.githubusercontent.com/github-production-release-asset-2e65be/20773773/72e1e75e-1c99-48a1-81a4-100603dc025e?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220215%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220215T195725Z&X-Amz-Expires=300&X-Amz-Signature=90278b380ac0afa630b3d69d48430135c67e682721cd7dd0b222ebb715434166&X-Amz-SignedHeaders=host&actor_id=227350&key_id=0&repo_id=20773773&response-content-disposition=attachment%3B%20filename%3Dbazel-6.0.0-pre.20220201.3-linux-arm64&response-content-type=application%2Foctet-stream'
lynx
curl -L https://github.com/bazelbuild/bazel/releases/download/6.0.0-pre.20220201.3/bazel-6.0.0-pre.20220201.3-linux-arm64
curl -L https://github.com/bazelbuild/bazel/releases/download/6.0.0-pre.20220201.3/bazel-6.0.0-pre.20220201.3-linux-arm64 > bazel-inst
file bazel-inst 
chmod a+x bazel-inst 
./bazel-inst --help
uname
uname -a
rm bazel-inst 
curl -L https://github.com/bazelbuild/bazel/releases/download/6.0.0-pre.20220201.3/bazel-6.0.0-pre.20220201.3-linux-x86_64 > bazel-inst
chmod a+x bazel-inst 
./bazel-inst --help
ls
ls rd-vid/
cd rd-vid/
ls
ls shared/
ls shared/videos/
cd ..
ls
df
sudo service docker status
w
nvidia-smi 
w
ls
nvidia-smi 
nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version
nvidia-smi -h
nvidia-smi -x
nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version -x
nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version --format=csv
nvidia-smi --query-gpu=timestamp,name,memory.total,driver_version --format=csv
nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv
nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv|awk -F', ' |{print "| " $1 " | " $2 " | " $3 " | " $4 " |"}'
nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv|awk -F', ' '{print "| " $1 " | " $2 " | " $3 " | " $4 " |"}'
nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv|awk -F', ' '{print "| " $1 " | " $2 " | " $3 " |"}'
cat /etc/issue.net 
cat /etc/apt/sources.list.d/nvidia-docker.list
which docker
docker --versio
cat /etc/apt/sources.list.d/cuda.list.save 
ls
last
df
ls ../
w
ls
cd rd-vid/
ls
cd ..
mount
mount|grep smb
ssh 130.229.134.26
ssh 130.229.135.254
sudo umound rd-vid/
sudo umount rd-vid/
mount|grep jore
sudo umount rd-vid/shared 
#sudo mount -t cifs -o user=joregan,nounix,sec=ntlmssp //130.229.135.254/riksdag $PWD/shared/
ssh joregan@n135-p254.eduroam.kth.se
w
ls
rm fd.zip 
rm fd2.zip 
ls
cd ..
ls
df
mkdir riksdag
cd riksdag
ls ..
wget https://data.riksdagen.se/dataset/dokument/bet-2018-2021.xml.zip
unzip bet-2018-2021.xml.zip 
mkdir bet-2018-2021
mv *.xml bet-2018-2021
ls
less bet-2018-2021/h701juu30.xml 
ls
wget https://data.riksdagen.se/dataset/dokument/bet-2018-2021.json.zip
unzip -l bet-2018-2021.json.zip 
mkdir json
cd json/
unzip ../bet-2018-2021.json.zip 
less h901uu7.json
#03:39:39.04
echo $((3 * 60 * 60))
echo $(( $((3 * 60 * 60)) + $((39 * 60)) + 39))
conda activate hfasr
python
pip3 install datasets
python
conda install soundfile
pip3 install soundfile
python
pip3 install librosa
nvidia-smi 
ls -al /tmp/
ls -al /tmp/*wav
ls asr-2017-2018/
less asr-2017-2018/162349_20000_830950.json 
find shared/ -name '162349_20000_830950*'
conda activate hfasr
ffprobe shared/videos/162349_20000_830950.mp4 
nvidia-smi 
ls -al /tmp/*wav
ls asr-2017-2018/
ls -al asr-2017-2018/
less asr-2017-2018/184066_20000_941567.json 
ls -al asr-2017-2018/
less asr-2017-2018/176487_20000_890177.json 
ls -al asr-2017-2018/|wc
ffprobe shared/videos/|wc
ls shared/videos/|wc
ls -al asr-2017-2018/|wc
ls -al asr-2017-2018/
less asr-2017-2018/176487_20000_890177.json 
find shared/ -name '176487_20000_890177*'
ffprobe shared/videos/2017-2018/176487_20000_890177.mp4
less asr-2017-2018/176487_20000_890177.json 
ls -al asr-2017-2018/|wc
less asr-2017-2018/162052_20000_829636.json 
 162052_20000_829636.mp4
less asr-2017-2018/162052_20000_829636.json 
ls -al asr-2017-2018/|wc
ls -al asr-2017-2018/
less asr-2017-2018/184477_20000_943431.json 
less asr-2017-2018/162052_20000_829636.json 
w
#sudo mount -t cifs -o user=joregan,nounix,sec=ntlmssp //130.229.135.254/riksdag $PWD/shared/
cd ..
cd test/
ls
mkdir shared
sudo mount -t cifs -o user=joregan,nounix,sec=ntlmssp //130.229.152.190/riksdag $PWD/shared/
ls shared/
ls shared/videos/
ls shared/videos/2017-2018/
cd shared/videos/2017-2018/
pwd
cd -
mkdir asr-2017-2018
cd asr-2017-2018/
pwd
cd ..
ls shared/videos/2017-2018/|wc
ls shared/videos/2017-2018/*mp4|wc
ls shared/videos/2017-2018/|grep -v mp4
conda create --name hfasr
conda activate hfasr
pip install pydub
pip3 install pydub
ls -al shared/videos/2017-2018/
python3 run-hf-asr.py 
pip install transformers
pip3 install transformers
python3 run-hf-asr.py 
conda install pytorch
python3 run-hf-asr.py 
pip3 install transformers
python3 run-hf-asr.py 
pip3 install pydub
python3 run-hf-asr.py 
conda install ffmpeg
python3 run-hf-asr.py 
less asr-2017-2018/175431_20000_884546.json 
python3 run-hf-asr.py 
ps
ps aux|grep python
rm fd.zip 
ls
w
last
last|less
nvidia-smi 
w
last|head
w
ls
mkdir .tmp
cd .tmp/
conda activate hfasr
pip install instaloader
instaloader addy_kate popova_mariii mariwka chloeelizabethh19
ls
nvidia-smi 
df
ls -al
ls riksdag
ls riksdag-api-out/
ls
df -k
ls thing/
cd thing/
docker build -t jim/whisper-test:v1 .
df
cd ..
df
cd rd
ls
rm *srt *vtt *txt
ls
rm *mp4
ls
cd ..
ls
ls docker-files/
docker images ls
docker image ls
ls
df
docker image ls
docker image rm b414d1ea621e
df
git clone https://github.com/shivammehta007/Neural-HMM.git
cd Neural-HMM/
git submodule init; git submodule update
bash start.sh 
df
docker system df
docker image ls
docker image rm 2b03c9284356
docker stop 8f305f4cf993
docker rm 8f305f4cf993
docker image rm 2b03c9284356
df
docker image prune
docker container prune
df
cd ..
rm -rf Neural-HMM/
df
docker image ls
sudo vi /etc/netplan/00-installer-config.yaml
lshw
lshw|less
sudo vi /etc/netplan/00-installer-config.yaml
sudo netplan apply
ping 10.210.242.10
ifconfig
ping 10.210.242.10
sudo vi /etc/netplan/00-installer-config.yaml
less /etc/netplan/00-installer-config.yaml
sudo ifconfig enp129s0f1 up
less /etc/netplan/00-installer-config.yaml
sudo apt update 
ping se.archive.ubuntu.com
cp /etc/netplan/00-installer-config.yaml  .
df
w
last
last|less
nvidia-smi 
ls
cat 00-installer-config.yaml 
rm 00-installer-config.yaml 
rm -rf miniconda3/
cp /etc/netplan/00-installer-config.yaml  .
sudo  vi /etc/netplan/00-installer-config.yaml  
cat 00-installer-config.yaml 
sudo ifconfig enp129s0f1 down
sudo netplan apply
sudo  cp 00-installer-config.yaml /etc/netplan/00-installer-config.yaml  
less 00-installer-config.yaml 
ssh 10.210.242.135
sudo netplan apply
ssh 10.210.242.135
ifconfig 
sudo ip route add 10.210.242.135/24 via 10.210.242.130 dev enp129s0f1
sudo ip route add 10.210.242.0/24 via 10.210.242.130 dev enp129s0f1
sudo ip addr flush dev enp129s0f1
sudo ip route add 10.210.242.0/24 via 10.210.242.130 dev enp129s0f1
ping www.google.com
cat 00-installer-config.yaml 
cp 00-installer-config.yaml 00-installer-config.yaml.old
vi 00-installer-config.yaml
ping www.google.se
ping 10.210.242.10
sudo netplan apply
vi 00-installer-config.yaml
cat /etc/netplan/00-installer-config.yaml
sudo cp 00-installer-config.yaml /etc/netplan/00-installer-config.yaml
ping 10.210.242.10
ping www.google.se
sudo netplan apply
ping www.google.se
ping 10.210.242.10
ping 10.210.242.135
ping 130.237.3.105
cat /etc/issue.net 
nvidia-smi 
cd thing/
ls
cat Dockerfile 
cat /etc/issue.net 
df
ssh 130.237.3.105
ssh -l joregan 130.237.3.105
ls ~/.ssh/
ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no 130.237.3.105
sudo apt install nfs-common
ls /
sudo mkdir /sbtal
sudo mount -t nfs 10.210.242.10:/tmh_edlund_vol3 /sbtal
ping 10.210.242.10
sudo mount -t nfs 10.210.242.10:/tmh_edlund_vol3 /sbtal
sudo mount -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
ping 10.210.242.10
sudo mount -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
mount
ping tmh-vnas.net.kth.se
telnet tmh-vnas.net.kth.se 2049
showmount -e tmh-vnas.net.kth.se
man mount
sudo mount -v -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
sudo chown nobody:nogroup /sbtal
sudo mount -v -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
sudo mount -v -t nfs 10.210.242.10:/tmh_edlund_vol3 /sbtal
sudo mount -vv -t nfs 10.210.242.10:/tmh_edlund_vol3 /sbtal
sudo mount -vv -t nfs 10.210.242.10:/tmh_beskow_vol2 /sbtal
sudo mount /sbtal
sudo mount -v /sbtal
telnet 10.210.242.130 39460
sudo mount -vv -t nfs -o nfsvers=3 10.210.242.10:/tmh_beskow_vol2 /sbtal
sudo mount -vv -t nfs -o v3 10.210.242.10:/tmh_beskow_vol2 /sbtal
mount /sbtal
sudo mount -vv -t nfs -o v3,anonuid=1000,anongid=1001 10.210.242.10:/tmh_beskow_vol2 /sbtal
sudo mount -v /sbtal
sudo mount -vv -t nfs -o v3 10.210.242.10:/tmh_beskow_vol2 /sbtal
smbclient -L 10.210.242.10
sudo mount -vv -t nfs 10.210.242.10:/tmh_edlund_vol3 /sbtal
rcpinfo -p
sudo apt install rpcbind
rcpinfo -p
rpcinfo
rpcinfo -p
less /etc/network/interfaces 
sudo ufw status verbose
ls -al /sb
ls -al /sbtal/
sudo ufw status 
sudo ufw allow from 10.210.242.10 to any port nfs
sudo ufw status 
sudo ufw app list
sudo ufw enable
dmesg|tail
ping 10.210.242.10
dmesg|tail
rpcinfo -p
telnet 10.210.242.10 880
telnet 10.210.242.10 2049
tcpdump -i enp129s0f1 -n host 10.210.242.10
sudo tcpdump -i enp129s0f1 -n host 10.210.242.10
sudo tcpdump -vv -i enp129s0f1 -n host 10.210.242.10
telnet 10.210.242.10 111
telnet 10.210.242.10 80
nmcli c show
nmcli 
nmcli device show enp129s0f1
nmcli device show enp129s0f0
nmcli device show enp129s0f1
nmcli device show enp129s0f0
nmcli device show enp129s0f1
ping 10.210.242.130
traceroute 10.210.242.130
sudo apt install traceroute
traceroute 10.210.242.130
less /etc/netplan/00-installer-config.yaml 
ip route
route -n
sudo ss -ltn
vi /etc/fstab 
sudo vi /etc/fstab 
dmesg
sudo tcpdump -i enp129s0f1 -n host 10.210.242.10
sudo vi /etc/fstab 
vi 00-installer-config.yaml
sudo vi /etc/netplan/00-installer-config.yaml
sudo netplan apply
sudo tcpdump -i enp129s0f1 -n host 10.210.242.10
sudo vi /etc/fstab 
exportfs -r
sudo tcpdump -i enp129s0f1 -n host 10.210.242.10
showmount -e 1 10.210.242.10
showmount -e 10.210.242.10
rpcinfo -p 10.210.242.10
tshark
sudo apt install tshark
sudo apt-get update
sudo apt install tshark
sudo tshark -tad -n -r clien.pcap -Y 'frame.number == 500' -O rpc | sed '/^Re/,$ !d'
dmesg
showmount -e 10.210.242.10
showmount -h
showmount --all 10.210.242.10
showmount -e --all 10.210.242.10
showmount -d 10.210.242.10
showmount -a 10.210.242.10
showmount -e 10.210.242.10
showmount --no-headers 10.210.242.10
showmount --no-headers -e 10.210.242.10
showmount --version
sudo apt install nmap
sudo nmap -sP 10.210.242.10
sudo nmap -sP '10.210.242.*'
sudo nmap -O -sV 10.210.242.10
sudo vi /etc/fstab 
smbinfo 
apt-cache search smbclient
apt install smbclient
sudo apt install smbclient
smbtree
smbclient \\\\10.210.242.10\\tmh_beskow_vol2
smbclient -vv \\\\10.210.242.10\\tmh_beskow_vol2
smbclient -h
smbclient
sudo tcpdump -i enp129s0f1 -n host 10.210.242.10
sudo mount -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
sudo vi /etc/netplan/00-installer-config.yaml
sudo netplan apply
sudo mount -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
cat 00-installer-config.yaml
sudo vi /etc/netplan/00-installer-config.yaml

traceroute tmh-vnas.net.kth.se
less /etc/netplan/00-installer-config.yaml 
dmesg
sudo mount -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
nvidia-
nvidia-s
nvidia-smi 
df
ls
tar ztvf rd.tar.gz 
ls
conda activate whisper
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
bash Miniconda3-py39_4.12.0-Linux-x86_64.sh 
conda create --name whisper
conda activate whisper
. .bashrc 
conda activate whisper
which pip
pip install git+https://github.com/openai/whisper.git 
whisper --help
sudo mount -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
sudo mount -o v3 -t nfs tmh-vnas.net.kth.se:/tmh_edlund_vol3 /sbtal
#CUDA_VISIBLE_DEVICES=2,3 whisper 
ls
ls rd
ls rd-vid/
ls
ls riksdag
ls test/
CUDA_VISIBLE_DEVICES=2,3 whisper --model large --language Swedish test/194641_20000_1011173.mp4 
pip install ffmpeg
CUDA_VISIBLE_DEVICES=2,3 whisper --model large --language Swedish test/194641_20000_1011173.mp4 
pip uninstall ffmpeg
conda install ffmpeg
date
date; CUDA_VISIBLE_DEVICES=2,3 whisper --model large --language Swedish test/194641_20000_1011173.mp4 ; date
pip install ffmpeg-python
pip install --upgrade ffmpeg-python
python
pip uninstall ffmpeg
pip uninstall ffmpeg-python
pip install ffmpeg-python
date; CUDA_VISIBLE_DEVICES=2,3 whisper --model large --language Swedish test/194641_20000_1011173.mp4 ; date
#scp 130.237.3.105:
ls
ls rd
mv rd rd-sh
scp -r 130.237.3.105:rd .
ls
docker image ls
tmux attach
tmux
tmux attach
cd rd-sh/
ls
cat r7.sh 
cd ../thing/
ls
cat Dockerfile 
docker build -t jim/whisper-test:v1 .
nvidia-smi 
nvidia-smi 
ls /sbtal/joregan/rd/
ls -al /sbtal/joregan/rd/
nvidia-smi 
ps aux
ps aux|grep dock
docker container ls
nvidia-smi 
docker container ls
docker container ls|grep bash|awk '{print $1}'
docker container ls|grep bash|awk '{print $1}'|while read i;do docker container stop $i; docker container rm $i;done
nvidia-smi 
ls /sbtal/joregan/rd/
nvidia-smi 
pwd
nvidia-smi 
docker container ls|grep bash|awk '{print $1}'|while read i;do docker container stop $i; docker container rm $i;done
cd /sbtal/joregan/rd/
ls
cat r0.sh 
for i in *.sh; do echo '$!/bin/bash' >> tmp-new; echo 'echo "Starting"' >> tmp-new;tail -n 1 $i >> tmp-new; echo "Ending" >> tmp-new;mv tmp-new $i;chmod a+x $i;done
cat r0.sh 
cp ~/rd-sh/r* .
for i in *.sh; do echo '$!/bin/bash' >> tmp-new; echo 'echo "Starting"' >> tmp-new;tail -n 1 $i >> tmp-new; echo 'echo "Ending" ' $i >> tmp-new;mv tmp-new $i;chmod a+x $i;done
cat r0.sh 
cp ~/rd-sh/r* .
cat r0.sh 
cat r)
cat r*
rm *.sh
cp ~/rd-sh/r* .
cat r4.sh 
for i in *.sh; do echo '$!/bin/bash' >> tmp-new; echo 'echo "Starting"' >> tmp-new;tail -n 1 $i >> tmp-new; echo 'echo "Ending" ' $i >> tmp-new;mv tmp-new $i;chmod a+x $i;done
rm *.sh
cp ~/rd-sh/r* .
for i in *.sh; do echo '$!/bin/bash' >> tmp-new; echo 'echo "Starting"' $i >> tmp-new;tail -n 1 $i >> tmp-new; echo 'echo "Ending" ' $i >> tmp-new;mv tmp-new $i;chmod a+x $i;done
cat r0.sh 
cat r7.sh 
docker container ls|grep bash|awk '{print $1}'|while read i;do docker container stop $i; docker container rm $i;done
ls
cat r0.sh 
cp ~/rd-sh/r* .
for i in *.sh; do echo '#!/bin/bash' >> tmp-new; echo 'echo "Starting"' $i >> tmp-new;tail -n 1 $i >> tmp-new; echo 'echo "Ending" ' $i >> tmp-new;mv tmp-new $i;chmod a+x $i;done
docker container ls
nvidia-smi 
docker container ls|grep bash|awk '{print $1}'|while read i;do docker container stop $i; docker container rm $i;done
docker container ls
nvidia-smi 
cp ~/rd-sh/r* .
docker container ls|grep bash|awk '{print $1}'|while read i;do docker container stop $i; docker container rm $i;done
nvidia-ms
nvidia-smi 
docker container ls|grep bash|awk '{print $1}'|while read i;do docker container stop $i; docker container rm $i;done
nvidia-smi 
docker container ls|grep bash|awk '{print $1}'|while read i;do docker container stop $i; docker container rm $i;done
docker container ls
nvidia-smi 
docker container ls|grep bash|awk '{print $1}'|while read i;do docker container stop $i; docker container rm $i;done
nvidia-smi 
docker container ls|grep bash|awk '{print $1}'|while read i;do docker container stop $i; docker container rm $i;done
nvidia-smi 
ls
nvidia-smi 
find ../ljspeech -type f|wc
ls ..
ls -al ../
sudo find ../ljspeech/ -type f|cw
sudo find ../ljspeech/ -type f|wc
cd /sbtal/
cd joregan/rd/
ls
ls -al
less 2442209260026978521_720p.mp4.vtt 
less 2442209210026743321_720p.mp4.vtt 
less 2442205170012477721_720p.mp4
less 2442205170012477721_720p.mp4.vtt 
for i in *vtt;do echo $i; tail -n 4 $i;done
nvidia-smi 
ls /sbtal/joregan/rd/
tmux attach
ls
cd youtube/
ls
less proc.json 
less pl_videos.json 
cat pl_videos.json 
cat pl_videos.json |awk -F'"id": "' '{print $2}'
cat pl_videos.json |awk -F'"id": "' '{print $2}'|awk -F'"' '{print $1}'
cat pl_videos.json |awk -F'"id": "' '{print $2}'|awk -F'"' '{print $1}'|wc
cat pl_videos.json |awk -F'"id": "' '{print $2}'|awk -F'"' '{print $1}'|head | while read i;do youtube-dl $i --write-info-json --skip-download ;done
ls
#rm *.info.json
cat *zRtZknBuioU.info.json
cat *zRtZknBuioU.info.json|grep licens
rm *.info.json
cat pl_videos.json |awk -F'"id": "' '{print $2}'|awk -F'"' '{print $1}'|head | while read i;do youtube-dl $i --write-info-json --skip-download -o '%(id)s.%(ext)s' ;done
cat pl_videos.json uploads.json  |awk -F'"id": "' '{print $2}'|awk -F'"' '{print $1}' | while read i;do youtube-dl $i --write-info-json --skip-download -o '%(id)s.%(ext)s' ;done
cat pl_videos.json uploads.json  |awk -F'"id": "' '{print $2}'|awk -F'"' '{print $1}' | while read i;do youtube-dl --write-info-json --skip-download -o '%(id)s.%(ext)s' -- "$i" ;done
python
cat cc-by-ids.txt |while read i;do youtube-dl -o '%(id)s.%(ext)s' --write-sub --sub-lang sv -- "$i" ;done
tmux attach
ls
cd youtube/
ls
less zwxruQCvNO4.info.json 
cd youtube/
ls
cat cc-by-ids.txt 
cat cc-by-ids.txt |wc
cd ..
git clone https://huggingface.co/datasets/jimregan/riksantikvarieambetet-video-raw
cp youtube/*.info.json riksantikvarieambetet-video-raw/
cd riksantikvarieambetet-video-raw/
ls
git add *json
git add ./*json
git commit -m 'metadata'
git config --global user.email jaoregan@tcd.ie
git config --global user.name "Jim O'Regan"
git commit -m 'metadata'
ls
vi .gitattributes 
ls
ls
mkdir youtube
cd youtube/
conda activate whisper
pip install youtube-dl
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f "license=cc-by"
ls
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f "license=Creative Commons Attribution licence (reuse allowed)"
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f 'license=Creative Commons Attribution licence (reuse allowed)'
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f 'license=Creative Commons Attribution licence'
ls
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f license='Creative Commons Attribution license (reuse allowed)'
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f license='Creative Commons Attribution license \(reuse allowed\)'
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' --print-json
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' --print-json > json
grep license json
less json
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f license='Creative Commons Attribution license (reuse allowed)'
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f license='Creative Commons'
ls
rm pfleyFhCGtQ.f136.mp4.part json 
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' 
ls
rm pfleyFhCGtQ.f136.mp4.part 
youtube-dl -j --flat-playlist "https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0" > pl.json
less pl.json 
cat pl.json | awk -F'"url": "' '{print $2}'|awk -F'"' '{print $1}' | while read i;do youtube-dl -j --flat-playlist $i >> pl_videos.json || echo $i >> retry;done
cat ret
ls
youtube-dl -j --flat-playlist "https://www.youtube.com/c/heritageboard/videos?view=0&sort=dd&shelf_id=0" > uploads.json
python
which python
which python3
python3
ls
grep license *json
grep license ./*json
grep license ./*json|head -n 1
for i in ./*.json;do grep license -- $i;done
for i in ./*.json;do grep license -- $ && echo "$i" >> has-licencei;done
for i in ./*.json;do grep license -- $i && echo "$i" >> has-licencei;done
rm has-licencei 
for i in ./*.json;do grep license -- $i && echo "$i" >> has-licencei;done
less has-licencei 
less ./-5DwojwgLe0.info.json
tmux attach
cd youtube/
ls *vtt
ls ./*vtt
less ./YVjsv1KfPFc.sv.vtt 
ls
cd riksdag-api-out/
ls
ls|less
ls
less H9C320220119SoU9
curl https://www.riksdagen.se/api/videostream/get/H210308
wget https://mhdownload.riksdagen.se/VOD/176288_3000_889175.mp4
wget https://mhdownload.riksdagen.se/VOD1/PAL169/2442204240010027521_480p.mp4
rm 2442204240010027521_480p.mp4 
ls
less H9C420210916se1
less H9C320220119SoU9
ls
ls|wc
rm video_urls.txt 
ls|grep -v '^H'
ls
tmux attach
git commit -m 'metadata'
git config --global user.email jaoregan@tcd.ie
git config --global user.name "Jim O'Regan"
git commit -m 'metadata'
ls
vi .gitattributes 
ls
ls
mkdir youtube
cd youtube/
conda activate whisper
pip install youtube-dl
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f "license=cc-by"
ls
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f "license=Creative Commons Attribution licence (reuse allowed)"
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f 'license=Creative Commons Attribution licence (reuse allowed)'
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f 'license=Creative Commons Attribution licence'
ls
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f license='Creative Commons Attribution license (reuse allowed)'
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f license='Creative Commons Attribution license \(reuse allowed\)'
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' --print-json
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' --print-json > json
grep license json
less json
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f license='Creative Commons Attribution license (reuse allowed)'
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' -f license='Creative Commons'
ls
rm pfleyFhCGtQ.f136.mp4.part json 
youtube-dl 'https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0' -o '%(id)s.%(ext)s' 
ls
rm pfleyFhCGtQ.f136.mp4.part 
youtube-dl -j --flat-playlist "https://www.youtube.com/c/heritageboard/playlists?view=1&sort=dd&shelf_id=0" > pl.json
less pl.json 
cat pl.json | awk -F'"url": "' '{print $2}'|awk -F'"' '{print $1}' | while read i;do youtube-dl -j --flat-playlist $i >> pl_videos.json || echo $i >> retry;done
cat ret
ls
youtube-dl -j --flat-playlist "https://www.youtube.com/c/heritageboard/videos?view=0&sort=dd&shelf_id=0" > uploads.json
python
which python
which python3
python3
ls
grep license *json
grep license ./*json
grep license ./*json|head -n 1
for i in ./*.json;do grep license -- $i;done
for i in ./*.json;do grep license -- $ && echo "$i" >> has-licencei;done
for i in ./*.json;do grep license -- $i && echo "$i" >> has-licencei;done
rm has-licencei 
for i in ./*.json;do grep license -- $i && echo "$i" >> has-licencei;done
less has-licencei 
less ./-5DwojwgLe0.info.json
tmux attach
cd youtube/
ls *vtt
ls ./*vtt
less ./YVjsv1KfPFc.sv.vtt 
ls
cd riksdag-api-out/
ls
ls|less
ls
less H9C320220119SoU9
curl https://www.riksdagen.se/api/videostream/get/H210308
wget https://mhdownload.riksdagen.se/VOD/176288_3000_889175.mp4
wget https://mhdownload.riksdagen.se/VOD1/PAL169/2442204240010027521_480p.mp4
rm 2442204240010027521_480p.mp4 
ls
less H9C420210916se1
less H9C320220119SoU9
ls
ls|wc
rm video_urls.txt 
ls|grep -v '^H'
ls
tmux attach
history -a
nvidia-smi
history -a
less 2017-2018-videos.txt 
cat 2017-2018-videos.txt |awk -F'\t' '{print $2}'
ls
ls riksdag-api-out/
less riksdag-api-out/video_urls.txt 
grep http riksdag-api-out/video_urls.txt |wc
cat 2017-2018-videos.txt |awk -F'\t' '{print $2}'|grep http|wc
sudo mkdir /sbtal/riksdag-video
sudo chown joregan.joregan /sbtal/riksdag-video
cp riksdag-api-out/video_urls.txt /sbtal/riksdag-video/
cd /sbtal/riksdag-video/
vi video_urls.txt 
cat video_urls.txt 
cat video_urls.txt |awk -F/ '{print $NF}'|sort|uniq -c |grep -v ' 1'
grep 824855 video_urls.txt 
cat video_urls.txt |sort|uniq > tmp
mv tmp video_urls.txt 
cat video_urls.txt |awk -F/ '{print $NF}'|sort|uniq -c |grep -v ' 1'
wget -i video_urls.txt -o wget.log
history -a
ls
cd /sbtal/riksdag-video/
ls
tail -f wget.log 
wget https://mhdownload.riksdagen.se/riksdagen4/unrestricted/2018/06/13/827680.mp4
ls
wget https://mhdownload.riksdagen.se/VOD1/PAL169/2442207160019939321_480p.mp4
ls
rm video_urls.txt 
wget -i video-urls.txt -o wget1.log
history -a
cd /sbtal/riksdag-video/
ls
tail -f wget1.log 
ls|wc
ls
ls ~/youtube/
ls ~/youtube/|grep -v json
ls ~/youtube/|grep -v json|grep -v vtt
ls ~/youtube/|grep -v json|grep -v vtt|grep -v mp4
tail -f wget1.log 
ls
ls *mp4|wc
tail -f wget1.log 
ls
wc -l video-urls.txt 
tail wget1.log 
ls
cat video-urls.txt 
cat video-urls.txt |awk -F/ '{print $NF}'
cat video-urls.txt |awk -F/ '{print $NF}'|sort|uniq|wc
cat video-urls.txt |awk -F/ '{print $NF}'|sort|uniq|while read i;do if [ ! -e $i ];then echo $i >> missed;fi;done
cat missed 
grep 2442105060000578721_480p.mp4 video-urls.txt 
wget $(grep 2442105060000578721_480p.mp4 video-urls.txt )
grep 2442205180012533121 video-urls.txt 
wget https://mhdownload.riksdagen.se/VOD1/PAL169/2442205180012533121_480p.mp4
ls
vi run.sh
chmod a+x run.sh 
history -a
cd /sbtal/riksdag-video/
mkdir api_output
ls
history -a
