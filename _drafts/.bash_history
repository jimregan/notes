ssh sbtaldeep22
ssh sbtaldeep21
ssh sbtaldeep24
ssh sbtaldeep23
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cd -
cd ../6fbb1e6aa0389a4d2db5c7a8989e45ec/
git add wget-http-20230808-1.nt 
git commit -m inp
cd -
cat inp.log |perl wget-http.pl > tocheck
tail -f recheck.log 
cat recheck.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1c.nt
cd -
git add wget-http-20230808-1c.nt 
git commit -m recheck
cd -
cat recheck.log |perl wget-http.pl |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F/ '{print $NF}'|sort|uniq > todel
scp todel sbtaldeep22:.srv/done/
tail -f recheck.log 
tail recheck
tail ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1c.nt
tail -f recheck.log 
scp sbtaldeep22:.srv/done/respid  .
cat respid |while read i;do grep $i ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-202*c.nt;done
cat respid |while read i;do grep $i ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-202*.nt;done
cat respid |while read i;do grep $i ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-202*.nt;done|grep sizeInB > tocheck
tail -f recheck.log 
wc -l recheck
tail -f recheck.log 
tail -f recheck.log 
cat recheck.log |perl wget-http.pl |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F/ '{print $NF}'|sort|uniq > todel
cat recheck.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1c.nt
cd -
git add wget-http-20230808-1c.nt 
git commit -m recheck
cd -
scp todel sbtaldeep22:.srv/done/
caffeinate 
scp sbtaldeep22:.srv/wg/inpb.log .
cat inpb.log |perl wget-http.pl > tocheck
cat inpb.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cd -
git add wget-http-20230808-1.nt 
git commit -m inpb
tail -f recheck.log 
cd -
tail -f recheck.log 
scp /Users/joregan/Downloads/Sc-20230906T183925Z-001.zip sbtaldeep22:.srv/m9jul23/
rm /Users/joregan/Downloads/Sc-20230906T183925Z-001.zip 
scp /Users/joregan/Downloads/Ss-20230906T184010Z-001.zip  sbtaldeep22:.srv/m9jul23/
rm /Users/joregan/Downloads/Ss-20230906T184010Z-001.zip  
scp  /Users/joregan/Downloads/Sc-20230907T091420Z-001.zip /Users/joregan/Downloads/Ss-20230907T091547Z-001.zip sbtaldeep22:.srv/m9jul23/
rm  /Users/joregan/Downloads/Sc-20230907T091420Z-001.zip /Users/joregan/Downloads/Ss-20230907T091547Z-001.zip 
scp sbtaldeep22:.srv/wg/inpb.log .
scp /Users/joregan/Downloads/Sc[89]* sbtaldeep22:.srv/m9jul23/
rm /Users/joregan/Downloads/Sc[89]* 
scp /Users/joregan/Downloads/Ss-20230910T121925Z-001.zip  sbtaldeep22:.srv/m9jul23/
tail recheck.log 
tail recheck
tail ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1c.nt
cat recheck.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1c.nt
cd -
git add wget-http-20230808-1c.nt 
git commit -m recheck
cd -
scp todel sbtaldeep22:.srv/done/
tail -f recheck.log 
tail recheck
tail inpb.log 
tail ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
tail tocheck
scp sbtaldeep22:.srv/wg/inpb.log .
cat inpb.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cd -
git add wget-http-20230808-1.nt 
git commit -m inpb
cd -
cat inpb.log |perl wget-http.pl > tocheck
tail -f recheck.log 
vi nn
tail -f recheck.log 
scp todel sbtaldeep22:.srv/done/
tail -f recheck.log 
cat recheck.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1c.nt
cd -
git add wget-http-20230808-1c.nt 
git commit -m recheck
cd -
cat recheck.log |perl wget-http.pl |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F/ '{print $NF}'|sort|uniq > todel
scp todel sbtaldeep22:.srv/done/
cd -
ls
cd -
cat inpb.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cat inpb.log |perl wget-http.pl > tocheck
cd -
git add wget-http-20230808-1.nt 
git commit -m inpb
cd -
ls
git diff
git add fash-rdf-links 
git status|less
git commit -m upd
git push
tail -n 49 fash-rdf-links |less
grep /3141143245349676164/  ../6fbb1e6aa0389a4d2db5c7a8989e45ec/unsorted-triples-202*
cp fash-rdf-links ../6fbb1e6aa0389a4d2db5c7a8989e45ec/unsorted-triples-20230911.nt
cd -
git add unsorted-triples-20230911.nt 
git commit -m add
#cp ~/Playing/cfimg/fash-rdf-links cf_unsorted-triples-20230911.nt 
ls -al ~/Playing/cfimg/fash-rdf-links 
cp ~/Playing/cfimg/fash-rdf-links cf_unsorted-triples-20230826.nt 
git add cf_unsorted-triples-20230826.nt 
git commit -m add
less cf_unsorted-triples-20230826.nt 
ls
ls
cd -
cat inpb.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cd -
git add wget-http-20230808-1.nt 
git commit -m inpb
cd -
cd -
rm tocheck 
cd -
le
ls
scp sbtaldeep22:.srv/wg/inpb.log .
cat inpb.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cat inpb.log |perl wget-http.pl > tocheck
cd -
git add wget-http-20230808-1.nt 
git commit -m inpb
tail -f recheck.log 
cd -
tail -f recheck.log 
cd -
git status
git push
cd -
tail -f recheck.log 
cd -
git diff
git add wget-http-20230808-1.nt 
git commit -m cfimg
cd -
tail -f recheck.log 
cat recheck.log |perl wget-http.pl |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F/ '{print $NF}'|sort|uniq > todel
cat recheck.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1c.nt
cd -
git add wget-http-20230808-1c.nt 
git commit -m recheck
cd -
scp todel sbtaldeep22:.srv/done/
tail -f recheck.log 
cat recheck.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1c.nt
cd -
git add wget-http-20230808-1c.nt 
git commit -m recheck
cd -
cat recheck.log |perl wget-http.pl |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F/ '{print $NF}'|sort|uniq > todel
scp todel sbtaldeep22:.srv/done/
less recheck.log 
rm rec
ls
scp sbtaldeep22:.srv/wg/inp.log .
cat inpb.log |perl wget-http.pl > tocheck
less tocheck
less tocheck
grep ng31_18 recheck
cat inp.log |perl wget-http.pl > tocheck
cat inp.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cd -
git add wget-http-20230808-1.nt 
git commit -m inp
tail -f recheck.log 
cd -
tail -f recheck.log 
tail -f recheck.log 
cat recheck.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1c.nt
cd -
git add wget-http-20230808-1c.nt 
git commit -m recheck
cd -
cat recheck.log |perl wget-http.pl |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F/ '{print $NF}'|sort|uniq > todel
scp todel sbtaldeep22:.srv/done/
ls
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cat inp.log |perl wget-http.pl >> tocheck
cd -
git add wget-http-20230808-1.nt 
git commit -m inp
cd -
cd -
git add wget-http-20230808-1.nt 
git commit -m cfimg
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> tocheck
rm tocheck 
rm inp.log 
cd -
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> tocheck
cat inp.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cd -
git add wget-http-20230808-1.nt 
git commit -m inp
cd -
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cat inp.log |perl wget-http.pl >> tocheck
cd -
git add wget-http-20230808-1.nt 
git commit -m inp
cd -
cd -
git add wget-http-20230808-1.nt 
git commit -m cfimg
cd -
cd -
git add wget-http-20230808-1.nt 
git commit -m cfimg
vi cf_identical-files-20230913-1.nt 
cat cf_identical-files-20230913-1.nt |grep -v '^$'|grep -v web.arch
vi cf_identical-files-20230913-1.nt 
git add cf_identical-files-20230913-1.nt 
git commit -m cfimg
tail wget-http-20230808-1.nt 
cd -
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> tocheck
cat inp.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cd -
git add wget-http-20230808-1.nt 
git commit -m inp
cd -
cd -
git add wget-http-20230808-1.nt 
git commit -m cfimg
git diff
git add cf_identical-files-20230913-1.nt 
git commit -m cfimg
git diff
git add wget-http-20230808-1.nt 
git commit -m cfimg
less cf_unsorted-triples-20230826.nt 
vi /Users/joregan/Playing/cfimg/inp
vi /Users/joregan/Playing/cfimg/inp
cat cf_identical-files-20230913-1.nt |grep -v '^$'|grep -v web.arch
tail -f recheck.log 
cd -
tail -f recheck.log 
scp sbtaldeep22:.srv/wg/inpa.log .
cat inpa.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1.nt 
cd -
git add wget-http-20230808-1.nt 
git commit -m inpa
cd -
cat inpa.log |perl wget-http.pl > tocheck
cat recheck.log |perl wget-http.pl |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F/ '{print $NF}'|sort|uniq > todel
cat recheck.log |perl wget-http.pl >> ../6fbb1e6aa0389a4d2db5c7a8989e45ec/wget-http-20230808-1c.nt
cd -
git add wget-http-20230808-1c.nt 
git commit -m recheck
cd -
scp todel sbtaldeep22:.srv/done/
scp /Users/joregan/Downloads/Ss-20230914T101310Z-001.zip sbtaldeep22:.srv/m14sep23/
rm /Users/joregan/Downloads/Ss-20230914T101310Z-001.zip 
conda activate nst-tts
ls /Users/joregan/Playing/rd_phonetic
git add swe-lexicon.ipynb
git commit -m 'restart, tweak'
less lexicon.txt 
less lexicon.txt 
grep '^DET' lexicon.txt 
grep '^DET' lexicon.txt |less
grep '^INTE' lexicon.txt |less
grep '^EN' lexicon.txt |less
grep '^JA' lexicon.txt |less
grep '^NEJ' lexicon.txt |less
less lexicon.txt 
grep Ä lexicon.txt 
grep Ä lexicon.txt 
grep '^ÄR' lexicon.txt 
grep '^ÄR' lexicon.txt 
less lexicon.txt 
git add swe-align.ipynb
git commit -m add
ls ~/Playing/kbw2v
echo ~/Playing/kbw2v
echo ~/Playing/rd_phonetic
echo ~/Playing/rd_phonetic/2442204240010034621_480p.json 
less ~/Playing/rd_phonetic/2442204240010034621_480p.json 
less ~/Playing/rd_phonetic/2442204240010034621_480p.json 
git add swe-align.ipynb
git commit -m add
git add swe-align.ipynb
git commit -m add
git add swe-align.ipynb
git commit -m add
git add swe-align.ipynb
git commit -m add
git add swe-align.ipynb
git add swe-align.ipynb
git commit -m add
git add swe-align.ipynb
git commit -m add
git add swe-align.ipynb
git commit -m add
git add swe-align.ipynb
git commit -m add
git add swe-align.ipynb
git commit -m add
git add swe-align.ipynb
git commit -m add
git diff
git diff
git add swe-align.ipynb
git commit -m crap
git add swe-align.ipynb
git commit -m crap
git add swe-align.ipynb
git commit -m crap
git add swe-align.ipynb
git commit -m crap
git add swe-align.ipynb
git commit -m crap
git add swe-align.ipynb
git commit -m crap
git add swe-align.ipynb
git add swe-lexicon.ipynb
git commit -m crap
git add swe-align.ipynb
git commit -m crap
git diff
git add swe-align.ipynb
git commit -m redo
git add swe-align.ipynb
git commit -m redo
git add swe-align.ipynb
git commit -m redo
git add swe-align.ipynb
git commit -m redo
git add swe-align.ipynb
git commit -m redo
git add swe-align.ipynb
git commit -m redo
git add swe-align.ipynb
git commit -m 'almost working'
git add swe-align.ipynb
git commit -m 'almost working'
git add swe-align.ipynb
git commit -m works
git add swe-align.ipynb
git commit -m works
less /tmp/2442204240010034621.tsv 
git add swe-align.ipynb
git commit -m works
mkdir ~/Playing/rd_tpalign
echo ~/Playing/rd_tpalign
git diff
git add swe-align.ipynb
git commit -m works
ls ~/Playing/rd_tpalign
ls -al ~/Playing/rd_tpalign
less ~/Playing/rd_tpalign/2442207180020073921_480p.tsv 
git add tabs
git commit -m add
cp ../_posts/2023-08-31-misc-links.md ../_posts/2023-10-07-misc-links.md
vi ../_posts/2023-10-07-misc-links.md
git add ../_posts/2023-10-07-misc-links.md
vi tabs
vi ../_posts/2023-10-07-misc-links.md
git add ../_posts/2023-10-07-misc-links.md
vi tabs
git add tabs
git commit -m cvt
vi ../_posts/2023-10-07-misc-links.md
git add ../_posts/2023-10-07-misc-links.md
git rm tabs
git commit -m cvt
git diff
git add swe-align.ipynb
git commit -m more
git log swe-align.ipynb
#cp swe-align.ipynb ../_notebooks/2023-10-04-swedish-asr-alignment.ipynb
git mv swe-align.ipynb ../_notebooks/2023-10-04-swedish-asr-alignment.ipynb
git commit -m mv
git add ../_notebooks/2023-10-04-swedish-asr-alignment.ipynb
git commit -m MD
git branch
git push origin next-notes 
git checkout -b next-notes-actually-notes
git push origin next-notes-actually-notes 
git checkout next-notes
git branch -D next-notes-actually-notes 
git checkout master 
git pull origin master 
git checkout next-notes
git merge master
git push origin next-notes 
git checkout master 
git pull origin master 
git branch -D next-notes 
git checkout -b swe-aligner
cp ../_notebooks/2023-10-04-swedish-asr-alignment.ipynb swe-aligner.ipynb
cp ../_notebooks/2023-10-04-swedish-asr-alignment.ipynb swe-align.ipynb
rm swe-aligner.ipynb 
git add swe-align.ipynb
git commit -m 'in progress'
git add swe-align.ipynb
git commit -m todos
vi ../_posts/2023-10-07-misc-links.md 
git add ../_posts/2023-10-07-misc-links.md 
git commit -m more
git add swe-align.ipynb
git commit -m 'todo: Add mismatched start time case; add a class to represent CTM merge input'
git diff
git add swe-align.ipynb
git commit -m 'keep ctm-style bits in simple merge'
git add swe-align.ipynb
git commit -m 'keep ctm-style bits in word chunk'
vi ../_posts/2023-10-07-misc-links.md 
vi ../_posts/2023-10-07-misc-links.md 
git add ../_posts/2023-10-07-misc-links.md 
git commit -m more
vi ../_posts/2023-10-07-misc-links.md 
git add ../_posts/2023-10-07-misc-links.md 
git commit -m code
grep -i RIKSANTIKVARIEÄMBETET /Users/joregan/Playing/rd_tpalign/*
cat  /Users/joregan/Playing/rd_tpalign/*|awk '{print $5 " " $6}'
cat  /Users/joregan/Playing/rd_tpalign/*|awk '{print NF-2 " " NF-1}' 
cat  /Users/joregan/Playing/rd_tpalign/*|awk '{print $NF-2 " " $NF-1}' 
cat  /Users/joregan/Playing/rd_tpalign/*|awk '{print $NF-2 " " $(NF-1)}' 
cat  /Users/joregan/Playing/rd_tpalign/*|sed -e 's/UNALIGNED /UNALIGNED_/'|awk '{print $(NF-2) " " $(NF-1)}' 
cat  /Users/joregan/Playing/rd_tpalign/*|sed -e 's/UNALIGNED /UNALIGNED_/'|awk '{print $(NF-1) " " $(NF)}' 
cat  /Users/joregan/Playing/rd_tpalign/*|sed -e 's/UNALIGNED /UNALIGNED_/'|awk '{print $(NF-1) " " $(NF)}'  > /tmp/all-raw
cat /tmp/all-raw |sort|uniq -c > /tmp/all-sort-uniq
python
tconda activate nst-tts
tail -f /tmp/all-sort-uniq 
less /tmp/all-raw 
less /tmp/all-sort-uniq 
cat /tmp/all-sort-uniq |sort -nr
cat /tmp/all-sort-uniq |sort -nr|less
grep ' 1 ' /tmp/all-sort-uniq 
grep ' 1 ' /tmp/all-sort-uniq |grep -v UNALIGN
grep ' 1 ' /tmp/all-sort-uniq |grep -v UNALIGN|awk '{print $2}'|sort|uniq -c
grep ' 1 ' /tmp/all-sort-uniq |grep -v UNALIGN|awk '{print $2}'|sort|uniq -c > /tmp/by-number-of-pronunciations
cat /tmp/by-number-of-pronunciations|sort -nr
cat /tmp/by-number-of-pronunciations|sort -nr|less
grep RESERVATION /tmp/all-sort-uniq 
grep RESERVATION /tmp/all-sort-uniq |less
git add swe-compare.ipynb 
git commit -m add
git add swe-compare.ipynb 
git commit -m add
git diff
git add swe-align.ipynb 
git commit -m 'change output'
git add swe-align.ipynb 
git commit -m 'clear cell output'
vi /tmp/foooff
cat /tmp/foooff |awk 'BEGIN{c=0}{c+=$1}END{print c}'
cat /tmp/foooff |sort -nr
cat /tmp/foooff |sort -nr|less
wc -l /Users/joregan/Playing/rd_tpalign/*tsv
cat /Users/joregan/Playing/rd_tpalign/*tsv|wc -l
cat /Users/joregan/Playing/rd_tpalign/*tsv|grep -v UNALIGNED|wc -l
git diff
git add swe-align.ipynb 
git diff
git add swe-compare.ipynb 
git commit -m changes
git add swe-align.ipynb 
git commit -m 'start of mapping creations'
git diff
git add swe-align.ipynb 
git commit -m 'fix json path'
git add swe-align.ipynb 
git commit -m 'fix json path'
less /Users/joregan/Playing/rdapi/api_output/H7C320191002MjU3 
mkdir /Users/joregan/Playing/rd_tpalign2/
ls /Users/joregan/Playing/rd_tpalign2/
ls /Users/joregan/Playing/rd_tpalign2/2442204190009175521_480p.tsv 
less /Users/joregan/Playing/rd_tpalign2/2442204190009175521_480p.tsv 
git add swe-align.ipynb 
git commit -m 'working(?)'
git add waxholm-kludge.ipynb 
git commit -m 'add'
ffmpeg -i ~/Downloads/Royal\ Institute\ of\ Technology.m4a /tmp/fones.wav
rm /Users/joregan/Desktop/Screenshot\ 2023-10-30\ at\ 13.23.53.png /Users/joregan/Desktop/Screenshot\ 2023-10-30\ at\ 19.59.50.png /Users/joregan/Desktop/Screenshot\ 2023-10-30\ at\ 20.00.30.png /Users/joregan/Desktop/Screenshot\ 2023-10-31\ at\ 11.28.40.png 
scp /Users/joregan/Downloads/Sc-20231031T134824Z-001.zip /Users/joregan/Downloads/Ss-20231031T134836Z-001.zip sbtaldeep22:.srv/m16oct23/
rm /Users/joregan/Downloads/Sc-20231031T134824Z-001.zip /Users/joregan/Downloads/Ss-20231031T134836Z-001.zip 
