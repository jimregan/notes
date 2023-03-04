for i in *;do /tmp/kenlm/build/bin/lmplz -o 5 < $i > $i.5gram.arpa;done
find . -size 0
find . -size 0 -delete
ls
mkdir ../lm_arpa
mv *.arpa ../lm_arpa/
ls
#for i in *;do bn=$(basename $i); if [ ! -e ../lm_arpa/$bn ]; then 
for i in *;do bn=$(basename $i); if [ ! -e ../lm_arpa/$bn ]; then /tmp/kenlm/build/bin/lmplz -o 3 < $i > $i.3gram.arpa;fi;done
cd ~/Playing/notes/_drafts/
git diff
vi ../_posts/2023-02-22-misc-links.md 
rm tabs0 
vi tabs0 
git add tabs0 
git add tabs0 
git commit -m prune/cvt
vi ../_posts/2023-02-22-misc-links.md 
git diff
git add ../_notebooks/2023-02-09-stats-week-2.ipynb 
git add ../_posts/2023-02-22-misc-links.md 
git commit -m more
vi ../_posts/2023-02-22-misc-links.md 
git status
git diff
rm tabs0 
vi tabs0 
git diff tabs0
vi tabs0 
git diff
git add tabs0 
git add ../_posts/2023-02-22-misc-links.md 
git commit -m prune/cvt
vi ../_posts/2023-02-22-misc-links.md 
git diff
git add ../_posts/2023-02-22-misc-links.md 
git commit -m more
vi ../_posts/2023-02-22-misc-links.md 
git add ../_posts/2023-02-22-misc-links.md 
git commit -m more
vi ../_posts/2023-02-22-misc-links.md 
git add ../_posts/2023-02-22-misc-links.md 
git commit -m more
rm tabs0 
vi tabs0 
git diff
git add tabs0 
git commit -m prune
wc -l tabs0 
wc -l tabs
wc -l tabs*
vi ../_posts/2023-02-22-misc-links.md 
git diff
git add ../_posts/2023-02-22-misc-links.md 
git commit -m more
grep sherpa tabs*
vi tabs
vi ../_posts/2023-02-22-misc-links.md 
git add ../_posts/2023-02-22-misc-links.md 
rm tabs
vi tabs
git diff
git add tabs 
git commit -m prune/cvt
grep sametinget tabs*
vi tabs2
git add tabs2 
git commit -m next
vi ../_posts/2023-02-22-misc-links.md 
git add ../_posts/2023-02-22-misc-links.md 
git rm tabs2 
git commit -m prune/cvt
vi ../_posts/2023-02-22-misc-links.md 
grep 1455 tabs*
vi tabs
git diff
git add tabs 
git status
git add ../_posts/2023-02-22-misc-links.md 
git commit -m prune/cvt
vi tabs1 
git add ../_posts/2023-02-22-misc-links.md 
vi tabs1 
git diff
git diff
tail -n 16 tabs1 
tail -n 16 tabs1 >> ../_posts/2023-02-22-misc-links.md 
git diff
git rm tabs1 
git rm -f tabs1 
git add ../_posts/2023-02-22-misc-links.md 
git commit -m prune/cvt
vi ../_posts/2023-02-22-misc-links.md 
vi tabs0 
rm tabs0 
vi tabs0 
git diff
git add ../_posts/2023-02-22-misc-links.md 
git add tabs0 
git commit -m prune/cvt
vi ../_posts/2023-02-22-misc-links.md 
git add ../_posts/2023-02-22-misc-links.md 
git commit -m cvt
mkdir listening-group
cd listening-group/
youtube-dl -o '%(id)s.%(ext)s' --write-subs --sub-lang en NNnIGh9g6fA
man youtube-dl 
youtube-dl -o '%(id)s.%(ext)s' --write-sub --sub-lang en NNnIGh9g6fA
youtube-dl -U
pip uninstall youtube-dl
conda create --name ytdl
conda activate ytdl
conda install pip
which pip
pip install youtube-dl
youtube-dl -o '%(id)s.%(ext)s' --write-sub --sub-lang en NNnIGh9g6fA
pip install yt-dlc
pip install yt-dlp
yt-dlp -o '%(id)s.%(ext)s' --write-sub --sub-lang en NNnIGh9g6fA
ls
yt-dlp -o '%(id)s.%(ext)s' --write-sub --write-all-subs NNnIGh9g6fA
man yt-dlp
yt-dlp -o '%(id)s.%(ext)s' --list-subs NNnIGh9g6fA
yt-dlp -o '%(id)s.%(ext)s' --write-sub --sub-lang=en NNnIGh9g6fA
yt-dlp -o '%(id)s.%(ext)s' --all-subs NNnIGh9g6fA
ls
less NNnIGh9g6fA.en-qlPKC2UN_YU.vtt 
ls
less NNnIGh9g6fA.en-qlPKC2UN_YU.vtt 
less NNnIGh9g6fA.en-qlPKC2UN_YU.vtt 
cd ../M5/
ls|grep webm|wc
ls|grep mp4|wc
ls|grep mkv|wc
wc -l notdone 
less notdone 
less /Users/joregan/Downloads/S0095447010000628.txt 
rm /Users/joregan/Downloads/S0095447010000628.txt 
less /Users/joregan/Downloads/transinf_E94.D_10_2015_en\ \(2\).bib 
rm /Users/joregan/Downloads/transinf_E94.D_10_2015_en\ \(2\).bib 
rm /Users/joregan/Downloads/transinf_E94.D_10_2015_en.bib 
rm /Users/joregan/Downloads/transinf_E94.D_10_2015_en\ \(1\).bib 
git status
git add ../M5/*.mp4
git add ../M5/*.webm
git lfs activate
git lfs install
git commit -m videos
git status
git status
git status
git add ../M5/*.webm
git add ../M5/*.mp4
git add ../M5/*.mkv
git status
git rm ../M5/00Npee-_NZo.f247.webm
git add ../M5/00Npee-_NZo.webm
git add ../M5/01ASJb36Pf0.webm 
git status
git add ../M5/01cmKEaP9Gc.mp4
git commit -m videos
git status
git add ../M5/*.mkv
git add ../M5/*.mp4
git add ../M5/*.webm
git status
git status
git add ../M5/0AXUQcCu8sM.webm
git rm ../M5/0AXUQcCu8sM.f247.webm 
git status
git status
git add ../M5/*mkv
git statsu
git status
git status
git status
git status
git status
git add ../M5/*webm
git status
git status
git status
git status
git add ../M5/*mkv
git status
git add ../M5/*webm
git status
git commit -m videos
git push origin raw-videos 
git status
git status
git status
git add ../M5/*mkv
git status
git add ../M5/*mp4
git status
git add ../M5/*webm
git status
git add ../M5/*mkv
git status
git commit -m videos
ls ../M5/
git status
git add ../M5/*mkv
git add ../M5/*mp4
git status
git add ../M5/*webm
git status
git status
git add ../M5/*mkv
git status
git status
git add ../M5/*webm
git status
git add ../M5/*mkv
git status
git status
git add ../M5/*mkv
git status
git add ../M5/*webm
git status
git commit -m videos
git push origin raw-videos 
git status
git add ../M5/*mkv
git add ../M5/*mm4
git add ../M5/*mp4
git status
git status
git add ../M5/*webm
git status
git add ../M5/3g7j-UTRgcA.webm 
git commit -m videos
git status
git push origin raw-videos 
git status
git status
git add ../M5/*webm
git status
git status|grep '\.f'
conda activate ytdl
yt-dlp  -o '%(id)s.%(ext)s' --all-subs --  6wNUyNDU0gU
# 6x6cTRk75X0
git status
git status|grep '\.f'
mv 6wNUyNDU0gU.mkv ../M5/
git rm ../M5/6wNUyNDU0gU.f247.webm
git rm -f ../M5/6wNUyNDU0gU.f247.webm
git add ../M5/6wNUyNDU0gU.mkv 
git status|grep '\.f'
cd ../M5/
yt-dlp  -o '%(id)s.%(ext)s' --all-subs --  6x6cTRk75X0
git rm 6x6cTRk75X0.f247.webm 
git add 6x6cTRk75X0.mkv 
git status
git add *.mkv
git add ./*.mkv
git status
git status|grep '\.f'
git add ./*.mp4
git status
git add *.webm
git add ./*.webm
git status
git lfs install
git commit -m videos
git push origin raw-videos 
git status
git add ./*.mkv
git add ./*.mp4
git status
git add ./*.webm
git status
git status
git add FkOOtdd_gUw.mkv Fkcm8PPK_1M.webm
git status
git add FlYF2_W-Xno.webm 
git status
git commit -m videos
git push origin raw-videos 
git status
git status
git status
git add ./*mkv
git add ./*mp4
git status
git add ./*webm
git status
git status
git add MwhYETim1nw.webm
git commit -m videos
git push origin raw-videos 
git status
git add *webm
git add ./*webm
git add ./*mkv
git add ./*mp4
git add ./*webm
git status
git commit -m videos
ls *vtt
git status
less Nc8_yClgLQY.hu.vtt 
git status
git add ./*mkv
git add ./*mp4
git status
git add ./*webm
git commit -m videos
git push origin raw-videos 
git status
git add ./*.webm
git status
git add ./*.mkv
git add ./*.mp4
git status
git add ./*.webm
git status
git add ./*.mkv
git status
git add ./*.webm
git commit -m videos
git status
git add ./*.webm
git add ./*.mkv
git status
git commit -m videos
vi notdone 
git status
git add ./*.webm
git add ./*.mkv
git status
ls
git status
git add ./*.mp4
git status
git status
git add 9zyEzfgL3yw.webm 
git status
git status
git add A-iEM6DV9oc.mp4 
git status
git commit -m videos
git push origin raw-videos 
git status
git status
git add ./*.mp4
git add ./*.mkv
git add ./*.webm
git push origin raw-videos 
git status
git commit -m videos
git push origin raw-videos 
git status
git add A0*webm
git status
git add Aa*webm
git add A_*webm
df
ls
git remote show origin 
git status
git status|grep webm
git status|grep webm|awk '{print $NF}'
git status|grep webm|awk '{print $NF}'|while read i;do scp $i sbtaldeep22:hungarian-youtube-speech/M5/ ; done
df
df -m
df -m
ls
git add A*webm
df
git status
du -sh ..
cd ..
cd ..
scp -r youtube-hu/ sbtaldeep22:
rsync -avh youtube-hu/ sbtaldeep22:youtube-hu/
rsync -avh youtube-hu/ sbtaldeep22:youtube-hu/
rsync -avh youtube-hu/ sbtaldeep22:youtube-hu/
rsync -avh youtube-hu/ sbtaldeep22:youtube-hu/
rsync -avh youtube-hu/ sbtaldeep22:youtube-hu/
du -m .
du -m youtube-hu
rm -rf youtube-hu/
ls
cd M5/
ls
ls *mkv
ls ./*mkv
ls ./*mkv | sed -e 's/\.\///;s/\.mkv//'
ls ./*mkv | sed -e 's/\.\///;s/\.mkv//' >> done
ls ./*webm | sed -e 's/\.\///;s/\.webm//' >> done
ls ./*mp4 | sed -e 's/\.\///;s/\.mp4//' >> done
less done 
for i in ./*.info.json;do echo $i|sed -e 's/\.\///;s/\.info.json//'
for i in ./*.info.json;do echo $i|sed -e 's/\.\///;s/\.info.json//';done
for i in ./*.info.json;do echo $i|sed -e 's/\.\///;s/\.info.json//';done | while read j;do grep -- $j done || echo $j >> notdone;done
conda activate ytdl
cat notdone |while read i;do yt-dlp  -o '%(id)s.%(ext)s' -- $i;done
cat notdone |while read i;do yt-dlp  -o '%(id)s.%(ext)s' --write-sub --sub-lang hu -- $i;done
cat notdone |while read i;do yt-dlp  -o '%(id)s.%(ext)s' --all-subs -- $i;done
vi notdone 
echo ZP5GDfGgo6k |while read i;do yt-dlp  -o '%(id)s.%(ext)s' --all-subs -- $i;done
#git add ZP5GDfGgo6k.webm 
ls ./*mp4 | sed -e 's/\.\///;s/\.mp4//' >> done
ls ./*webm | sed -e 's/\.\///;s/\.mp4//' >> done
ls ./*mkv | sed -e 's/\.\///;s/\.mp4//' >> done
rm done 
ls ./*mkv | sed -e 's/\.\///;s/\.mp4//' >> done
ls ./*webm | sed -e 's/\.\///;s/\.mp4//' >> done
ls ./*mp4 | sed -e 's/\.\///;s/\.mp4//' >> done
rm notdone 
for i in ./*.info.json;do echo $i|sed -e 's/\.\///;s/\.info.json//';done | while read j;do grep -- $j done || echo $j >> notdone;done
wc -l notdone 
cat notdone |while read i;do yt-dlp  -o '%(id)s.%(ext)s' --all-subs -- $i;done
echo AawwRvlXGD4 |while read i;do yt-dlp  -o '%(id)s.%(ext)s' --all-subs -- $i;done
cd ~/Playing/sync_asr/
ls
less rdfilt-edit 
cd Playing/notes/_drafts/
vi tabs
git add tabs 
git commit -m pt1
cp ../_posts/2022-12-05-misc-links.md ../_posts/2023-02-22-misc-links.md 
vi ../_posts/2023-02-22-misc-links.md 
git add ../_posts/2023-02-22-misc-links.md 
git commit -m 'add'
git status
vi tabs 
git diff
git add tabs 
git commit -m prune
vi tabs0
git add tabs0 
git commit -m next
rm tabs0
vi tabs0
git diff
git add tabs0 
git commit -m prune
vi tabs1
git add tabs1 
git commit -m next
rm tabs1
vi tabs1
git diff
git add tabs1 
git commit -m prune
vi ../_posts/2023-02-22-misc-links.md 
git add ../_posts/2023-02-22-misc-links.md 
git commit -m cvy
vi ../_posts/2023-02-22-misc-links.md 
grep vga_be tab*
grep openv tab*
rm tabs0 
vi tabs0 
git diff
git add tabs0 
git commit -m prune
wc -l tabs0 
grep 2205.03026 tabs*
vi ../_posts/2023-02-22-misc-links.md 
git add ../_posts/2023-02-22-misc-links.md 
grep sherpa tabs*
rm tabs
vi tabs
git diff
git add tabs 
git commit -m prune/cvt
vi ../_posts/2023-02-22-misc-links.md 
rm /Users/joregan/Downloads/10.1007_s10579-018-9411-5-citation.ris 
less /Users/joregan/Downloads/transinf_E94.D_10_2015_en.bib 
vi ../_posts/2023-02-22-misc-links.md 
vi tabs0 
rm tabs0 
vi tabs0 
git diff
git add tabs0 
git statuws
git status
git add  ../_posts/2023-02-22-misc-links.md
git commit -m prune/cvt
vi tabs0 
vi ../_posts/2023-02-22-misc-links.md 
vi ../_posts/2023-02-22-misc-links.md 
vi ../_posts/2023-02-22-misc-links.md 
vi tabs0 
rm tabs0 
vi tabs0 
git add  ../_posts/2023-02-22-misc-links.md
git add tabs0 
git commit -m prune/cvt
rm tabs0 
vi tabs0 
git diff
git add tabs0 
git commit -m prune
wc -l tabs0 
df -m
df -m
