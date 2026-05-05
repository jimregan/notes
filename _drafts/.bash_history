git clone https://github.com/kth-tmh/snack
cd /tmp
mkdir nico
cd nico/
git init .
tar zxvf ~/Downloads/nico_v1.1.tar.gz 
mv NICO_1-1/* .
ls
rmdir NICO_1-1/
git add .
git commit -m 'Downloaded from http://web.archive.org/web/20060511223110if_/http://www.speech.kth.se:80/NICO/nico_v1.1.tar.gz'
#git tag -a v1.1
git tag -a v1.1 -m '1.1'
ls
tar zxvf ~/Downloads/nico-1.1.1.tar.gz 
mv nico-1.1.1/* .
cd ..
rm -rf nico/
mkdir nico
cd nico/
ls
tar zxvf ~/Downloads/nico_v1.1.tar.gz 
mv NICO_1-1/* .
rmdir NICO_1-1/
git add .
git init .
git add .
ls
ls -al
less doc_html/COMMANDS/Import.html 
ls
less lib/Math.c 
cat lib/Math.c |iconv -f latin1 -t utf-8
cat lib/Math.c |iconv -f latin1 -t utf-8|jead
cat lib/Math.c |iconv -f latin1 -t utf-8|head
cat lib/Math.c |iconv -f latin1 -t utf-8|head -n 123
cat lib/Math.c |iconv -f latin1 -t utf-8|less
ls
git commit --author "Nikko Ström <nikko@speech.kth.se>" --date "$(date -r doc_html/index.html)" -m 'Downloaded from http://web.archive.org/web/20060511223110if_/http://www.speech.kth.se:80/NICO/nico_v1.1.tar.gz'
git log
ls
rm -rf *
tar zxvf ~/Downloads/nico_v1.1.tar.gz 
rm -rf NICO_1-1/
tar zxvf ~/Downloads/nico-1.1.1.tar.gz 
git tag -a v1.1 -m 'v1.1'
mv nico-1.1.1/* .
rmdir nico-1.1.1/
ls doc/index.html 
ls -al
git add .
git status
#git commit --author "Nikko Ström <nikkostrom@users.sourceforge.net>" --date "$(date -r doc/index.html)" -m 'Downloaded from http://web.archive.org/web/20060511223110if_/http://www.speech.kth.se:80/NICO/nico_v1.1.tar.gz'
ls
#git commit --author "Nikko Ström <nikkostrom@users.sourceforge.net>" --date "$(date -r doc/index.html)" -m 'Downloaded from https://sourceforge.net/projects/nico/files/nico/nico-1.1.1/'
git commit --author "Nikko Ström <nikkostrom@users.sourceforge.net>" --date "$(date -r doc/index.html)" -m 'Downloaded from https://sourceforge.net/projects/nico/files/nico/nico-1.1.1/'
git log
git tag -a v1.1.1 -m 'v1.1.1'
ls
rm -rf *
tar zxvf ~/Downloads/nico-1.1.2.tar.gz 
git add .
git commit --author "Nikko Ström <nikkostrom@users.sourceforge.net>" --date "$(date -r doc/index.html)" -m 'Downloaded from https://sourceforge.net/projects/nico/files/nico/nico-1.1.2/'
ls
git status
mv nico-1.1.2/* .
git add .
git status
ls doc/
git commit --author "Nikko Ström <nikkostrom@users.sourceforge.net>" --date "$(date -r doc/index.html)" -m 'Downloaded from https://sourceforge.net/projects/nico/files/nico/nico-1.1.2/'
git log
git tag -a v1.1.2 -m 'v1.1.2'
ls
ls lib/
less lib/RTSim.c 
less ~/Downloads/RTDNN1.1.2_c.patch 
cd lib/
patch -p0 < ~/Downloads/RTDNN1.1.2_c.patch 
patch -p0 < ~/Downloads/RTSim1.1.2_c.patch 
patch -p0 < ~/Downloads/Simulation1.1.2_c.patch 
git diff
vi RTDNN.c 
git diff
git stash
patch -p0 < ~/Downloads/Simulation1.1.2_c.patch 
patch -p0 < ~/Downloads/RTSim1.1.2_c.patch 
patch -p0 < ~/Downloads/RTDNN1.1.2_c.patch 
git add RT* Simulation.c 
cd ..
git log
ls
rmdir nico-1.1.2/
git status
git remote add origin git@github.com:kth-tmh/nico-toolkit.git
git branch -M main
git push -u origin main
git push --tags --all
git push --tags -a
git push --tags 
date -r lib
git status
git commit --author "Giampiero Salvi <giampi@speech.kth.se>" --date "Wed Jan  8 20:31:37 CET 2020"
git log
git push 
codex
codex
pwd
cd ..
cd nico/
ls
codex
codex
ls
ls lib
cd lib/
ls
make
ls
git log
git push 
ls
make clean
ls
cd ..
git status
rm tools/Excite.o 
git status
ls
ls bin/
find . -type f|while read i;do cat $i|iconv -f latin1 -t utf-8 > tmp; mv tmp $i;done
git diff
git status
git stash
cd ..
rm -rf nico/
git clone git@github.com:kth-tmh/nico-toolkit.git
git clone git@github.com:kth-tmh/nico-toolkit.git nico
cd nico/
ls
find [a-z]* -type f|while read i;do cat $i|iconv -f latin1 -t utf-8 > tmp; mv tmp $i;done
git diff
git add lib/AudioData.c 
git status
git diff
git status
less toy-examples/XOR/xor.rtdnn 
git commit -m 'latin1 -> utf-8'
git push 
git stash
less speech-example/make_simpletimit
git diff
git diff
less lib/Makefile 
git diff
git add lib/Makefile lib/System.c 
git diff
git commit -m 'put in a check for old-style malloc'
git push 
git status
less README.md 
git add README.md 
git commit -m 'add README'
git push 
git status
git add LICENSE 
git commit -m 'add LICENSE' 
git push 
git status
echo '*.o' >> .gitignore
echo '*.a' >> .gitignore
git add .gitignore 
git commit -m add\ .gitignore 
git push 
conda env list
git status
ls toy-examples/pytorch_demo/
ls toy-examples/pytorch_demo/README.md 
less toy-examples/pytorch_demo/README.md 
less toy-examples/pytorch_demo/generated/xor_demo.py 
ls toy-examples/pytorch_demo/README.md 
less toy-examples/pytorch_demo/README.md 
ls toy-examples/pytorch_demo/
ls toy-examples/pytorch_demo/generate.py 
less toy-examples/pytorch_demo/generate.py 
echo __pycache__ >> .gitignore 
git add .gitignore 
git commit -m update\ .gitignore 
git push 
git checkout -b generated-pytorch
git add toy-examples/pytorch_demo/
git commit -m 'codex-generated pytorch conversion'
git push origin generated-pytorch 
claude
ls
git status
ls ~/Playing/librivox_mult/
git add writing/
git commit -m add
vi writing/LRE\ -\ Phonetic\ corpus/old-towards.tex
cd writing/LRE\ -\ Phonetic\ corpus/
pandoc old-towards.tex -f latex -t markdown old-towards.md
pandoc old-towards.tex -f latex -t markdown -o old-towards.md
ls
vi old-towards.tex 
pandoc old-towards.tex -f latex -t markdown -o old-towards.md
pandoc old-towards.tex -f latex -t markdown+tex_math_dollars -o old-towards.md
vi mybib.tex
git add .
git commit -m 'old latex'
mkdir old-towards
git mv old-towards.tex mybib.tex old-towards/
git commit -m mv
touch top-level.md
vi top-level.md 
git add .
git commit -m more
cd ..
cd ..
grep -i formant *
find . -name '*.md'|xargs grep -i formant
find . -name '*.md' -exec  grep -i formant {}
find . -name '*.md' -exec  grep -i formant {} \;
find . -name '*.md' |while read i;do grep -i format "$i";done
find . -name '*.md' |while read i;do grep -i format "$i" && echo $i;done
find . -name '*.md' |while read i;do grep -i formant "$i" && echo $i;done
less ./dysfluent-wfst/CLAUDE.md
ls
cd hungarian-reels/
ls
git add .
git commit -m hu-reels
git diff
git diff
ls
git add .
git commit -m hu-reels
cd ../writing/
git add .
git commit -m update
cd -
ls
git diff
git log
ls writing/Hungarian\ Reels.md 
less ~/Playing/notes/_posts/2026-02-16-mseb.md 
claude
python
less output_01.tsv 
less gemma4-ctc/CLAUDE.md 
git diff
less gemma4-ctc/CLAUDE.md 
git status
git add writing/
git commit -m add
git add writing/
git commit -m add
git add writing/
git commit -m add
git add writing/
git commit -m add
ls ~/Playing/librivox_mult/
cd ~/Playing/librivox_mult/
git status
ls respiro/
ls
git status
ls index/
ls
git log
ls
git add respiro/
git commit -m 'add respiro output'
git status
find index/ -type f
git add index/
git commit -m 'add index files'
git push 
git branch
git checkout main 
git status
ls
git remote show origin 
git remote prune
git remote show origin 
git pull origin main 
git branch
git remote show origin 
git checkout text 
git log
git push origin text 
git pull origin text 
git checkout -b respiro
git push origin respiro 
ls
find . -name '*.py'
git log
git format-patch -1 a06b555fb1cc3161276ba426cfe952a3537fb246
less 0001-Use-Moses-with-semicolon-rejoin-post-processing-for-.patch
less text/the-crocodile/parse_text.ipynb 
pwd
ssh deepflow 
ssh deepflow 
ssh deepflow 
ssh deepwave 
less ~/.ssh/config
ssh b-tower 
ssh b-tower 
cd ~/Playing/
git clone https://github.com/huggingface/transformers
cd transformers/
pwd
cd ~/Playing/work-2026/
claude
cd gemma4-ctc/
git status
ls
rm -rf __pycache__/
git add .
git commit -m update
less convert_fairseq_to_hf_dataset.py 
ls
less CLAUDE.md 
scp sbtaldeep24:waxholm_fairseq/dict.ltr.txt .
less dict.ltr.txt 
claude --resume 11bc846f-2c59-4fa5-9ee4-470880bf945b
ls ~/.claude/projects/-Users-joregan-Playing-work-2026/11bc846f-2c59-4fa5-9ee4-470880bf945b.jsonl 
less ~/.claude/projects/-Users-joregan-Playing-work-2026/11bc846f-2c59-4fa5-9ee4-470880bf945b.jsonl 
less ~/.claude/projects/-Users-joregan-Playing-work-2026/11bc846f-2c59-4fa5-9ee4-470880bf945b.jsonl 
ls $(PWD)
pwd
less aligner.py 
less CLAUDE.md 
git status
less ../pronunciation-data/
ls
git add .
git commit -m 'edition alignment tool'
git status
ls ../mmconv/
ls ../mmconv/vibevoice/
less ../mmconv/vibevoice/hsi_3_0715_209_006_inter.json 
cd ..
less r1 
less r2 
git status
less multi-source-scorer-instructions.md
ls dysfluent-wfst/
less dysfluent-wfst/CLAUDE.md 
ls accents-gmu-native 
less accents-gmu-native 
git branch
git push origin unsorted-new 
mkdir align-html
cd align-html/
mv ~/Downloads/align.py .
mv ~/Downloads/parse_index.py .
mv ~/Downloads/fetch_text.py .
mv ~/Downloads/book_config.yaml .
mv ~/Downloads/requirements.txt .
ls
vi README
git add .
git commit -m generated
less align.py 
less book_config.yaml 
ls ../writing/
ls ../writing/Welcome.md 
ls ../writing/2026-04-05.md 
less ../writing/2026-04-05.md 
cd ..
git add writing/
git commit -m add
ls writing/
cd writing/
ls
ls
ls Apple\ Notes/
cd Apple\ Notes/
ls
cd ..
git status
rm *.gif
ls
rm *.jpg
ls
rm *.png
ls
rm *.svg recording.m4a 
ls
cd  Apple\ Notes/
ls
less ffs.md 
less ./~deichler-code-flask_webgl_app-app_csmp.py.md 
rm ffs.md 
rm tocejag970@icousd.com.md 
cd ..
rm -rf Apple\ Notes/
ls
rm *jpg
rm *png *svg *.m4a
ls
rm *.gif
ls
cd Apple\ Notes/
ls
less 2025-03-08\ So…\ yeah\,\ I\ was\ in\ Estonia\ last\ week….md 
ls *ffs*
less 2024-05-24\ ffs.md 
cat *ffs.md
rm *ffs*
ls
less 2025-04-01\ What\ do\ you\ think\ has\ affected\ your\ self-esteem.md 
less 2024-09-24\ Oh\ God\,\ why\ did\ you\ leave\ keys\ on\ the\ table.md 
ls *toce*
rm 2026-01-05\ tocejag970@icousd.com.md 
ls
less 2024-06-08\ CPT.md 
cd ..
git add Apple\ Notes/
git commit -m add
git rm -r Apple\ Notes/
git commit -m 'discard, not useful'
ls
git diff
git add .
git commit -m update
git diff
git add ../.gitignore 
git commit -m update
git add .
git commit -m update
echo $(PWD)
ls $(PWD)
ls /Users/joregan/Playing/librivox_mult/text/the-crocodile
cd /tmp
cp ~/Downloads/1967_8_1_001-014.pdf .
pdftohtml 1967_8_1_001-014.pdf 
ls
ls 1967_8_1_001-014
ssh deepwave 
cd ~/Playing/gpu-admin/
git pull
vi users.json
git diff
vi users.json
git stash
vi users.json
git add users.json
git commit -m "Fredrik/Anya's master student"
git push 
python admin.py sync-users
less ~/.ssh/config
vi /Users/joregan/Downloads/S0167639326000166.bib 
less ~/.ssh/config
ls ~/Downloads/*mp3
ffplay ~/Downloads/1.mp3 
less ~/.ssh/config
ssh deepflow 
ssh deepflow 
ssh deepflow 
ssh deepflow 
ssh deepflow 
ssh deepflow 
scp sbtaldeep22:dockerfiles/claude-code/dot-claude/script /tmp
claude --resume 34a8d93c-07bd-44cf-9016-eaee595cba87
claude --resume 34a8d93c-07bd-44cf-9016-eaee595cba87
claude 
git clone https://github.com/sprakradet/swedia_test_set
cd ~/Playing/spoken-sentence-transformers/
ls
git log
git diff
git checkout main 
git pull origin main 
git checkout future-work 
codex 
codex resume 019d7346-eec1-7b92-8fb5-20a0ef86ba47
codex resume 019d7346-eec1-7b92-8fb5-20a0ef86ba47
cd ~/Playing/work-2026/
ls
ls spoken-sentence-transformers/notes.md 
less spoken-sentence-transformers/notes.md 
less training-plan.md 
ls *.md
less multi-source-scorer-instructions.md 
less resemblyzer-eval-results.md 
less training-plan.md 
echo $PWD/training-plan.md 
echo $PWD/eval-plan.md 
echo $PWD/spoken-sentence-transformers-odyssey/od2026_latex_template/ 
cd spoken-sentence-transformers-odyssey/
git pull
git diff
ls
less od2026_latex_template/Odyssey2026_Latex_Template.tex 
git diff
git branch
git checkout -b edits
git add od2026_latex_template/Odyssey2026_Latex_Template.tex 
git commit -m p315
