mv snack1.7.0/* .
rmdir snack1.7.0/
ls
git add .
git commit -m 'Version 1.7.0'
ls
less COPYING 
wget https://www.speech.kth.se/snack/dist/snack2.0.7.tar.Z
wget https://www.speech.kth.se/snack/dist/snack2.1.6.tar.gz
wget https://www.speech.kth.se/snack/dist/snack2.0.7.tar.gz
mv snack2.1.6.tar.gz ..
mv snack2.0.7.tar.gz ..
ls
git tag -a snack1.7.0 -m 'contents of http://www.speech.kth.se:80/snack/dist/snack1.7.0.tar.Z'
ls
git log
git commit --amend --author="Kåre Sjölander <kare@speech.kth.se>" --no-edit
git log
cd ..
wget https://www.speech.kth.se/snack/dist/snack1.7.0.tar.Z
ls -al snack1.7.0.tar.Z 
tar ztvf snack1.7.0.tar.Z |less
tar zxvf snack1.7.0.tar.Z 
cd snack1.7.0/
ls -al
cd -
cd snack
ls -al
date
less COPYING 
man date
date -r README 
date -r COPYING 
git commit --amend --date="$(date -r COPYING)" --no-edit 
git log
ls
rm *
rm -rf *
tar zxvf ../snack2.0.7.tar.gz 
mv snack2.0.7/* .
rmdir snack2.0.7/
ls
git status
git add .
#git commit --author="Kåre Sjölander <kare@speech.kth.se>" --date="$(date -r COPYING)" -m "Version 
ls
git commit --author="Kåre Sjölander <kare@speech.kth.se>" --date="$(date -r COPYING)" -m "Version 2.0.7"
git log
git tag -a snack2.0.7 -m 'contents of http://www.speech.kth.se:80/snack/dist/snack1.7.0.tar.Z'
git log
git remote add origin git@github.com:kth-tmh/snack.git
git branch -M main
git push -u origin main
ls
rm -rf *
git tag -m snack2.0.7 -m 'contents of http://www.speech.kth.se:80/snack/dist/snack2.0.7.tar.gz'
git tag --edit snack2.0.7 -m 'contents of http://www.speech.kth.se:80/snack/dist/snack2.0.7.tar.gz'
git tag -d snack2.0.7 
git tag -a snack2.0.7 -m 'contents of http://www.speech.kth.se:80/snack/dist/snack2.0.7.tar.gz'
git push --tags
ls
tar zxvf ../snack2.1.6.tar.gz 
mv snack2.1.6/* .
rmdir snack2.1.6/
git add .
git commit --author="Kåre Sjölander <kare@speech.kth.se>" --date="$(date -r COPYING)" -m "Version 2.1.6"
git log
git tag -a snack2.1.6 -m 'contents of https://www.speech.kth.se/snack/dist/snack2.1.6.tar.gz'
git push origin main 
git push --tags
wget http://web.archive.org/web/20250708034751*/http://www.speech.kth.se:80/snack/dist/snack2.2.2.tar.gz
less snack2.2.2.tar.gz 
rm snack2.2.2.tar.gz 
wget http://www.speech.kth.se:80/snack/dist/snack2.2.2.tar.gz
tar zxvf snack2.2.2.tar.gz 
ls
rm -rf *
wget http://www.speech.kth.se:80/snack/dist/snack2.2.2.tar.gz
ls -al snack2.2.2.tar.gz 
tar zxvf snack2.2.2.tar.gz 
ls -al snack2.2.2
tar ztvf snack2.2.2.tar.gz 
ls
rm snack2.2.2.tar.gz 
mv snack2.2.2/* .
rmdir snack2.2.2/
git add .
git commit --author="Kåre Sjölander <kare@speech.kth.se>" --date="$(date -r README)" -m "Version 2.2.2"
git log
git tag -a snack2.2.2 -m 'contents of https://www.speech.kth.se/snack/dist/snack2.2.2.tar.gz'
ls
less README 
git push --tags
git push origin main 
ls
cd ..
wget http://www.speech.kth.se:80/snack/dist/snack2.2.2.tar.gz
tar ztvf snack2.2.2.tar.gz 
wget https://www.speech.kth.se/snack/dist/snack2.2.10.tar.gz
cd snack
ls
rm -rf *
tar zxvf ../snack2.2.10.tar.gz 
git add .
git commit --author="Kåre Sjölander <kare@speech.kth.se>" --date="$(date -r README)" -m "Version 2.2.10"
date -r R
git mv snack2.2.10/* .
ls
rmdir snack2.2.10/
git add .
git commit --author="Kåre Sjölander <kare@speech.kth.se>" --date="$(date -r README)" -m "Version 2.2.10"
git tag -a snack2.2.10 -m 'contents of https://www.speech.kth.se/snack/dist/snack2.2.10.tar.gz'
git push origin main 
git push --tags
cd ..
mkdir snack-dist
cd snack-dist/
wget https://www.speech.kth.se/snack/dist/snack2.2.10.tar.gz
wget https://www.speech.kth.se/snack/dist/snack2210-tcl.zip
wget https://www.speech.kth.se/snack/dist/snack2210-py.zip
wget https://www.speech.kth.se/snack/dist/snack2.2.10-linux.tar.gz
wget https://www.speech.kth.se/snack/dist/snack2.2.9-osx.tar.gz
rm *
wget https://www.speech.kth.se/snack/dist/snack170n.exe https://www.speech.kth.se/snack/dist/snack170o.exe https://www.speech.kth.se/snack/dist/snack170.sea.hqx https://www.speech.kth.se/snack/dist/snack1.7.0.tar.Z
rm *
ls
wget https://www.speech.kth.se/snack/dist/snack2.0.7.tar.gz
wget https://www.speech.kth.se/snack/dist/snack2.0.7.sea.hqx
wget https://www.speech.kth.se/snack/dist/snack207p.exe
wget https://www.speech.kth.se/snack/dist/snack207o.exe
wget https://www.speech.kth.se/snack/dist/snack207n.exe
rm *
wget https://www.speech.kth.se/snack/dist/libsnacksphere.so https://www.speech.kth.se/snack/dist/libsnacksphere.dll https://www.speech.kth.se/snack/dist/ogg.tar.gz https://www.speech.kth.se/snack/dist/snack2.1.6.tar.gz https://www.speech.kth.se/snack/dist/snack2.1.6.tar.Z https://www.speech.kth.se/snack/dist/snack2.1.6.sea.hqx https://www.speech.kth.se/snack/dist/snack216p.exe https://www.speech.kth.se/snack/dist/snack216n.exe
rm *
wget https://www.speech.kth.se/snack/dist/libsnacksphere.so https://www.speech.kth.se/snack/dist/libsnacksphere.dll https://www.speech.kth.se/snack/dist/ogg.tar.gz https://www.speech.kth.se/snack/dist/snack2.2.2.tar.Z https://www.speech.kth.se/snack/dist/snack2.2.2.tar.gz https://www.speech.kth.se/snack/dist/snack2.2.sea.hqx https://www.speech.kth.se/snack/dist/snack222p.exe https://www.speech.kth.se/snack/dist/snack222n.exe
cd ..
rm -rf snack-dist/
cd snack
ls
git rm COPYING 
git mv BSD.txt LICENSE.txt
git commit -m 'make licence look nice in github'
git push origin main 
ls
claude 
claude --resume 6ba5b925-5a00-4900-97b5-ca3a2650b4ad
git status
less generic/minimp3.h 
git status
less generic/jkFormatMP3.h 
less generic/jkFormatMP3.c 
git checkout -b dev
git add generic/minimp3*
git status
git diff
git push origin dev 
git diff
git status
git status
find . -name '*.[ch]' |xargs grep CONST
git diff
git diff
git status
git diff generic/snack.c
git status
git branch
git log
git push origin modernise 
git log
git checkout -b python-ext
git log
git revert 574402784e7bcad3e6686d724fda8fe68128f32b
git log
git revert 34830e0853b951b4001dccf66698d3fef13c58b4
git push origin python-ext 
git checkout modernise 
git log
git revert 54da16683646ce8e0927777141633c3372108992
git push origin modernise 
git fetch
git fetch
git checkout copilot/build-github-packages 
git log
git diff
git diff
git status
git diff generic/jkCanvSpeg.c
git add generic/jkCanvSpeg.c
git commit -m 'tk 9 fixes'
git diff
git push origin copilot/build-github-packages 
git diff
git diff
git status
git status
git diff
git log
git push origin copilot/build-github-packages 
git log
git push origin copilot/build-github-packages 
git log
git push origin modernise 
git push origin copilot/build-github-packages 
git push origin copilot/build-github-packages 
git diff
git log
git push origin copilot/build-github-packages 
git push origin copilot/build-github-packages 
git push origin copilot/build-github-packages 
git log
git push origin copilot/build-github-packages 
git status
git log
git checkout -b 5169fdb122c9bbcfabce48218da8ddff15e03d76 debian
git checkout -b debian 5169fdb122c9bbcfabce48218da8ddff15e03d76 
ls ../*xz
ls
rm -rf *
tar zxvf ../snack_2.2.10.20090624+dfsg.orig.tar.xz
mv snack2.2.10/* .
rmdir snack2.2.10/
git status
git diff
git log
git add .
git commit -m 
less generic/SnackMpg.c
ls ../*xz
tar zxvf ../snack_2.2.10.20090624+dfsg-4.debian.tar.xz
git status
git add debian/
git commit -m snack_2.2.10.20090624+dfsg-4.debian
git push origin debian 
ls
cd debian/
ls
less patches/CVE-2012-6303.patch 
less patches/CVE-2012-6303.patch 
cd ..
git apply debian/patches/CVE-2012-6303.patch
git log
git diff
git stash
git am debian/patches/CVE-2012-6303.patch
git log
less debian/patches/CVE-2012-6303.patch
git status
git am --abort
git log
git diff
git log
less debian/patches/CVE-2012-6303.patch
vi debian/patches/CVE-2012-6303.patch
grep From: debian/patches/*
vi debian/patches/tcl9.patch 
grep From: debian/patches/*
vi debian/patches/make-shuffle.patch 
grep From: debian/patches/
vi debian/patches/make-shuffle.patch 
grep From: debian/patches/*
vi debian/patches/gnu-hurd.patch 
vi debian/patches/gcc-15.patch 
vi debian/patches/gcc-15.patch 
vi debian/patches/args.patch 
vi debian/patches/autoconf.patch 
grep From: debian/patches/*
vi debian/patches/libs.patch 
vi debian/patches/alsa.patch 
grep From: debian/patches/
grep From: debian/patches/*
git log
git push origin debian 
git log
git log
git push --force origin debian 
git checkout main 
git stash
git checkout main 
git log
git push origin main 
git pull origin main 
git push origin main 
git log
git cherry-pick d59d87385942375289d1617ba2b72c44b59e4178
git push origin main 
git log
git checkout debian 
git log
git tag -a snack_2.2.10.20090624+dfsg-4.debian -m 'Debian packaging and patches'
git push --tags 
git rm -r debian/
git commit -m 'remove debian/ directory'
git push origin debian 
git checkout copilot/build-github-packages 
git log
git checkout debian 
git log
git format-patch -1 777c7cda9d1e6db7c4796bb01b7f8d639eee4d01
git revert 777c7cda9d1e6db7c4796bb01b7f8d639eee4d01
vi 0001-Patch-makes-porting-of-the-tkSnack-Python-module-and.patch 
git am 0001-Patch-makes-porting-of-the-tkSnack-Python-module-and.patch 
git log
git push origin debian 
rm 0001-Patch-makes-porting-of-the-tkSnack-Python-module-and.patch 
git branch
git log
git push origin debian 
git log
git revert 3f49a68e36d688b4434f0772bd7cc4f5bcb395f8
git revert -m 3f49a68e36d688b4434f0772bd7cc4f5bcb395f8
git reset --hard HEAD^
git push --force origin debian 
git checkout debian 
git log
git checkout -b debian-upstream 4e917d233f6a52ba32c86451f4a416d6467e6f27
git push origin debian-upstream 
git checkout main 
git pull origin main 
git checkout debian
git merge -X ours main
git push origin debian
git fetch
git checkout copilot/build-github-packages 
git diff
git diff
git branch
git log
git log
git push origin copilot/build-github-packages 
git pull origin copilot/build-github-packages 
git config pull.rebase false
git pull origin copilot/build-github-packages 
git log
git push origin copilot/build-github-packages 
git status
git fetch
git merge main
vi generic/jkAudIO.h 
git diff
vi generic/jkAudIO.h 
git diff
git log
vi python/tkSnack.py 
git diff
git add python/tkSnack.py 
git commit -m 'take main version'
vi generic/snack.h 
git diff
git add generic/snack.h 
git commit -m 'take main version'
vi generic/jkSound.h 
git diff
git add generic/jkSound.h 
git commit -m 'take main version'
git push origin copilot/build-github-packages 
git checkout main 
git pull origin main 
git log
git checkout copilot/build-github-packages 
git log
git diff
git diff
git log
git log
git push origin copilot/build-github-packages 
git checkout main generic/jkFormant.c
git diff
git status
git add generic/jkFormant.c
git commit -m revert
git push origin copilot/build-github-packages 
git checkout main generic/snack.h
git checkout main generic/sigproc2.c
git checkout main generic/jkFormant.c
git commit -m revert
git push origin copilot/build-github-packages 
git checkout main generic/jkFormant.c
git checkout main generic/jkGetF0.c
git checkout main generic/jkSoundFile.c
git checkout main generic/sigproc2.c
git checkout main generic/snack.h
git commit -m revert
git push origin copilot/build-github-packages 
vi generic/jkSound.h 
git add generic/jkSound.h 
git commit -m 'missing #endif'
git push origin copilot/build-github-packages 
git pull origin copilot/build-github-packages 
git push origin copilot/build-github-packages 
git checkout main generic/jkCanvSpeg.c
git commit -m revert
git push origin copilot/build-github-packages 
git diff
git status
git add generic/jkCanvItems.h 
git commit -m 'fix'
git push origin copilot/build-github-packages 
git diff
git diff
git add unix/Makefile.in 
git commit -m 'remove X11'
git push origin copilot/build-github-packages 
cd ..
wget http://deb.debian.org/debian/pool/main/s/snack/snack_2.2.10.20090624+dfsg.orig.tar.xz
tar zxvf snack_2.2.10.20090624+dfsg.orig.tar.xz
wget http://deb.debian.org/debian/pool/main/s/snack/snack_2.2.10.20090624+dfsg-4.debian.tar.xz
tar zxvf snack_2.2.10.20090624+dfsg-4.debian.tar.xz
git log
ssh deepflow 
ssh deepflow 
cat ~/.huggingface/token 
rm /Users/joregan/Desktop/Screenshot\ 2026-04-10\ at\ 16.01.49.png /Users/joregan/Desktop/Screenshot\ 2026-04-10\ at\ 16.01.53.png /Users/joregan/Desktop/Screenshot\ 2026-04-10\ at\ 16.01.39.png /Users/joregan/Desktop/Screenshot\ 2026-04-10\ at\ 16.01.48.png /Users/joregan/Desktop/Screenshot\ 2026-04-10\ at\ 16.01.37.png /Users/joregan/Desktop/Screenshot\ 2026-04-10\ at\ 16.01.32.png /Users/joregan/Desktop/Screenshot\ 2026-04-10\ at\ 16.01.35.png /Users/joregan/Desktop/Screenshot\ 2026-04-10\ at\ 16.01.30.png 
less ~/.ssh/config
vi /tmp/files
vi /tmp/files
ssh deepflow 
ssh tts2
less To
less TODO.md 
git log TODO.md
git add TODO.md 
git commit -m more
git diff
ls mo-sceal-fein/
less mo-sceal-fein/MsfChapter1.ogg.w2v.json 
cat mo-sceal-fein/MsfChapter1.ogg.w2v.json |jq .|less
git mv TODO.md to-sort/
git commit -m mv
claude
£ claude --resume 87a616ee-ce3f-4fdd-b6b7-8f976b89739a
ssh sbtaldeep23
ssh sbtaldeep21
ssh sbtaldeep21
ssh sbtaldeep21
ssh sbtaldeep21
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep21
ssh sbtaldeep22
ssh sbtaldeep23
ssh sbtaldeep21
ssh sbtaldeep23
ssh sbtaldeep23
ssh sbtaldeep23
ssh sbtaldeep21
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep23
ssh sbtaldeep23
ssh sbtaldeep21
ssh sbtaldeep21
ssh sbtaldeep23
ssh sbtaldeep23
ssh sbtaldeep23
ssh sbtaldeep23
ssh sbtaldeep23
ssh sbtaldeep23
ssh sbtaldeep23
ssh sbtaldeep23 
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep22
ssh sbtaldeep23
ssh sbtaldeep23
ssh sbtaldeep22
ssh sbtaldeep21
ssh sbtaldeep24
ssh sbtaldeep24
ssh sbtaldeep24
ssh sbtaldeep24
ssh sbtaldeep24
ssh sbtaldeep24
ssh sbtaldeep24
ssh sbtaldeep24
ssh sbtaldeep23
ssh sbtaldeep21
ssh sbtaldeep24
ssh sbtaldeep24
ssh sbtaldeep21
ssh sbtaldeep23
ssh sbtaldeep24
ssh sbtaldeep24
