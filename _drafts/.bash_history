ls /Users/joregan/Playing/spoken-sentence-transformers/.pres_tmp/
less recheck.log 
cd -
cd ../8c08e58ba0638cacfea6a84a97fae1f4/
git diff
cd -
cat recheck.log |perl wget-http.pl 
cat recheck.log |perl wget-http.pl  >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405c.nt 
cd -
git add wget-20260405c.nt 
git commit -m recheck
cd -
cat recheck.log |perl wget-http.pl  |grep sizeIn
cat recheck.log |perl wget-http.pl  |grep sizeIn|awk -F'[<>]' '{print $2}'
cat recheck.log |perl wget-http.pl  |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F'/' '{print $NF}'
cat recheck.log |perl wget-http.pl  |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F'/' '{print $NF}' > todel 
less recheck.log 
grep Sc26may26-5.zip ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260*
less tocheck 
rm tocheck 
unzip -l /Users/joregan/Downloads/Sc-20260630T100209Z-3-001.zip 
grep sizeIn toch
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl 
cat inp.log |perl wget-http.pl > tocheck
cat inp.log |perl wget-http.pl >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405.nt 
cd ../8c08e58ba0638cacfea6a84a97fae1f4/
git add wget-20260405.nt 
git commit -m inp
cd -
cat tocheck |grep sizeIn|awk -F'[<>]' '{print $2}' > recheck
. spidering.sh 
spiderfile recheck
less recheck.log 
cat recheck.log |perl wget-http.pl  |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F'/' '{print $NF}' > todel 
cat recheck.log |perl wget-http.pl  >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405c.nt 
cd -
git add wget-20260405c.nt 
git commit -m recheck
cd -
cat recheck.log |perl wget-http.pl  |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F'/' '{print $NF}' > todel 
scp todel sbtaldeep22:.srv/done/
cat todel 
cd -
grep Sc-20260614T195013Z-3-001.zip wget-20260405c.nt 
grep Sc-20260614T195013Z-3-001.zip wget-20260405.nt 
grep Sc-20260614T195013Z-3-001.zip wget-20260405.nt |grep sizeIn
grep Sc-20260614T195013Z-3-001.zip wget-20260405.nt |grep sizeIn >> /tmp/tt
less /tmp/tt
grep Sc-20260614T221421Z-3-001.zip wget-20260405.nt |grep sizeIn >> /tmp/tt
grep Sc-20260614T222408Z-3-001.zip wget-20260405.nt |grep sizeIn >> /tmp/tt
cd -
mv /tmp/tt tocheck 
cat tocheck |grep sizeIn|awk -F'[<>]' '{print $2}' > recheck
less recheck
spiderfile recheck
less recheck.log 
cat recheck.log |perl wget-http.pl  |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F'/' '{print $NF}' > todel 
cat recheck.log |perl wget-http.pl  >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405c.nt 
cd -
git add wget-20260405c.nt 
git commit -m recheck
scp todel sbtaldeep22:.srv/done/
cd -
scp todel sbtaldeep22:.srv/done/
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405.nt 
cd -
git add wget-20260405.nt 
git commit -m inp
cd -
tail tocheck 
cat inp.log |perl wget-http.pl >> tocheck 
cat tocheck |grep sizeIn|awk -F'[<>]' '{print $2}' > recheck
spiderfile recheck
less recheck.log 
cat recheck.log |perl wget-http.pl  >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405c.nt 
cd -
git add wget-20260405c.nt 
git commit -m recheck
cd -
cat recheck.log |perl wget-http.pl  |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F'/' '{print $NF}' > todel 
scp todel sbtaldeep22:.srv/done/
rm tocheck 
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> tocheck 
cat inp.log |perl wget-http.pl >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405.nt 
cd -
git add wget-20260405.nt 
git commit -m inp
cd -
less tocheck 
grep '/source' tocheck 
grep '/source' tocheck |awk -F'[<>]' '{print $NF}'
grep '/source' tocheck |awk -F'[<>]' '{print $3}'
grep '/source' tocheck |awk -F'[<>]' '{print $6}'
grep '/source' tocheck |awk -F'[<>]' '{print $6}' > recheck
spiderfile recheck
scp recheck sbtaldeep22:.srv/wg/inp
mv recheck.log inp.log 
cat inp.log |perl wget-http.pl >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405.nt 
cd -
git add wget-20260405.nt 
git commit -m inp
cd -
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405.nt 
cd -
git add wget-20260405.nt 
git commit -m inp
cd -
vi regs 
vi regs 
git add id_mapping 
git commit -m more
git add regs 
git commit -m more
vi id_mapping 
git add id_mapping 
git commit -m more
cat id_mapping |sort|uniq > aaa
mv aaa id_mapping 
git diff id_mapping
git add id_mapping 
git commit -m 'sort|uniq'
less spidering.sh 
less id_mapping 
vi id_mapping 
spiderfile recheck
less recheck.log 
cat recheck.log |perl wget-http.pl  |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F'/' '{print $NF}' > todel 
cat recheck.log |perl wget-http.pl  >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405c.nt 
cd -
git add wget-20260405c.nt 
git commit -m recheck
cd -
rm tocheck 
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405.nt 
cd -
git add wget-20260405.nt 
git commit -m inp
cd -
cat inp.log |perl wget-http.pl >> tocheck 
less tocheck 
scp todel sbtaldeep22:.srv/done/
less inp.log 
scp sbtaldeep22:.srv/wg/inp.log .
cat inp.log |perl wget-http.pl >> tocheck 
cat inp.log |perl wget-http.pl >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405.nt 
cd -
git add wget-20260405.nt 
git commit -m inp
cd -
vi id_mapping 
git add id_mapping 
git commit -m inp
grep Sc-20260422T050813Z-3-001_7.zip tocheck 
grep 20260501T172432Z-3-001_11 tocheck 
grep Sc-20260614T222947Z-3-001 tocheck 
grep Sc-20260615T064359Z-3-001 tocheck 
grep Sc5jun26_3.zip tocheck 
grep Sc-20260614T222947Z-3-001.zip tocheck 
cd -
grep Sc-20260511T092547Z-3-001 wget-20260405c.nt 
du -sh
df -h
cd -
tail regs 
grep '/source' tocheck |awk -F'[<>]' '{print $6}' > recheck
spiderfile recheck
cat recheck.log |perl wget-http.pl  >> ../8c08e58ba0638cacfea6a84a97fae1f4/wget-20260405c.nt 
cd -
git add wget-20260405c.nt 
git commit -m recheck
cd -
cat recheck.log |perl wget-http.pl  |grep sizeIn|awk -F'[<>]' '{print $2}'|awk -F'/' '{print $NF}' > todel 
scp todel sbtaldeep22:.srv/done/
vi id_mapping 
vi id_mapping 
vi id_mapping 
git add id_
git add id_mapping 
git commit -m more
cat id_mapping |sort|uniq > aaa
mv aaa id_mapping 
git diff
git id_mapping
git diff id_mapping
git add id_mapping 
git commit -m 'sort|uniq'
git add id_ytd 
git commit -m add
cat id_ytd id_mapping |sort|uniq > aaa
mv aaa id_mapping 
git rm id_ytd 
git diff id_mapping
git add id_mapping 
git commit -m 'sort|uniq'
vi id_mapping 
vi id_mapping 
tail regs
vi id_mapping 
git add id_mapping 
git commit -m more
cat id_mapping ~/Playing/instascr/all_gdl_ids |sort|uniq > /tmp/sun
mv /tmp/sun id_mapping 
git diff
git diff id_mapping
git add id_mapping 
git commit -m 'sort|uniq'
du -h
df -h
vi id_mapping 
vi id_mapping 
vi regs 
vi regs 
vi id_mapping 
vi id_mapping 
vi id_mapping 
tail regs
vi id_mapping 
vi id_mapping 
less regs 
wc -l regs 
tail -n 150 regs|head
pwd
vi regs 
git add regs 
git commit -m more
git add id_mapping 
git commit -m more
cat id_mapping /tmp/newids |sort|uniq > aabb
mv aabb id_mapping 
git diff
git diff id_mapping
vi id_mapping 
git diff
vi id_mapping 
vi id_mapping 
git diff id_mapping
git add id_mapping 
git commit -m more
vi id_mapping 
less regs 
cat id_mapping /tmp/newids |sort|uniq > aabb
mv aabb id_mapping 
git diff
git diff id_mapping
vi id_mapping 
git diff id_mapping
git add id_mapping 
git commit -m more
tail regs
vi id_mapping 
vi regs 
tail regs
cat id_mapping /tmp/newids |sort|uniq > aabb
mv aabb id_mapping 
git diff
git diff id_mapping
git add id_mapping 
git commit -m more
less ~/Playing/rd_phonetic/2442101120000147521_480p.json 
cat ~/Playing/rd_phonetic/2442101120000147521_480p.json |jq .
cat ~/Playing/rd_phonetic/2442101120000147521_480p.json |jq .|less
du -sh .
du -sh ./*
ls tmp
cd tmp/
ls
ls
ls -al
less adinp.log 
less todo-new.log 
cat todo-new.log | perl ../wget-http.pl 
cat todo-new.log | perl ../wget-http.pl |less
ls
ls inp3.log 
less inp3.log 
find web.archive.org -type f
ls
du -sh *
ls shr/
unzip -l shr/sc6sep22.zip 
pwd
cd sb/
ls
less inp 
cd ../shr/
ls
unzip -l sc6sep22.zip 
pwd
ls
touch 2022-09-03-00-49-13-657.jpg
touch 2022-09-03-00-49-14-113.jpg
touch 2022-09-03-00-49-14-136.jpg
touch 2022-09-03-00-49-14-583.jpg
touch 2022-09-03-00-49-14-614.jpg
touch 2022-09-03-00-49-14-968.jpg
touch 2022-09-03-00-52-39-382.jpg
touch 2022-09-03-00-52-39-141.jpg
ls
ls *jpg | zip sc6sep22.zip -@
unzip -l sc6sep22.zip 
unzip -l sc6sep22.zip |grep 2022-09-03-00-52-39-141.jpg
unzip -l sc6sep22.zip |grep 2022-09-03
ls
rm *jpg
rm /private/tmp/ss/2022-09-03-00-49-14-583.jpg /private/tmp/ss/2022-09-03-00-49-14-136.jpg /private/tmp/ss/2022-09-03-00-49-14-113.jpg /private/tmp/ss/2022-09-03-00-49-13-657.jpg /private/tmp/ss/2022-09-03-00-49-13-207.jpg /private/tmp/ss/2022-09-03-00-49-12-025.jpg 
rm /private/tmp/ss/2022-08-30-22-29-07-157.jpg /private/tmp/ss/2022-08-30-22-29-07-532.jpg /private/tmp/ss/2022-08-30-22-29-07-641.jpg 
rm /private/tmp/ss/2022-08-31-09-14-08-976.jpg 
rm /private/tmp/ss/2022-08-31-14-21-43-464.jpg /private/tmp/ss/2022-08-31-14-21-43-440.jpg /private/tmp/ss/2022-08-31-14-21-26-496.jpg /private/tmp/ss/2022-08-31-14-21-24-830.jpg /private/tmp/ss/2022-08-31-14-21-22-643.jpg /private/tmp/ss/2022-08-31-14-21-22-619.jpg 
rm /private/tmp/ss/2022-08-31-14-21-45-058.jpg /private/tmp/ss/2022-08-31-14-21-43-726.jpg /private/tmp/ss/2022-08-31-14-21-43-725.jpg 
rm /private/tmp/ss/2022-08-31-14-22-43-175.jpg /private/tmp/ss/2022-08-31-14-22-39-464.jpg 
rm /private/tmp/ss/2022-08-31-14-26-21-130.jpg /private/tmp/ss/2022-08-31-14-26-18-230.jpg /private/tmp/ss/2022-08-31-14-26-13-093.jpg 
find /tmp/ss/ -size 0
find /tmp/ss/ -size 0 -delete
rm /private/tmp/ss/2022-08-31-14-30-16-008.jpg /private/tmp/ss/2022-08-31-14-30-15-379.jpg /private/tmp/ss/2022-08-31-14-29-59-808.jpg 
rm /private/tmp/ss/2022-08-31-15-47-48-953.jpg 
rm /private/tmp/ss/2022-08-31-14-30-16-008.jpg /private/tmp/ss/2022-08-31-15-58-58-324.jpg 
rm /private/tmp/ss/2022-08-31-19-37-02-915.jpg /private/tmp/ss/2022-08-31-19-37-01-673.jpg 
rm /private/tmp/ss/2022-08-31-19-36-36-823.jpg 
rm /private/tmp/ss/2022-08-31-20-04-06-565.jpg  /private/tmp/ss/2022-08-31-20-04-06-565.jpg 
rm /private/tmp/ss/2022-08-31-20-02-41-678.jpg 
rm /private/tmp/ss/2022-09-01-07-36-03-911.jpg /private/tmp/ss/2022-09-01-07-36-04-233.jpg 
rm /private/tmp/ss/2022-09-01-07-37-03-498.jpg 
rm /private/tmp/ss/2022-09-01-08-40-46-282.jpg /private/tmp/ss/2022-09-01-08-40-46-720.jpg 
rm /private/tmp/ss/2022-09-01-08-45-12-871.jpg 
rm /private/tmp/ss/2022-09-01-10-12-08-839.jpg /private/tmp/ss/2022-09-01-10-12-08-417.jpg /private/tmp/ss/2022-09-01-10-12-07-886.jpg /private/tmp/ss/2022-09-01-10-12-07-247.jpg 
rm /private/tmp/ss/2022-09-01-20-25-05-336.jpg /private/tmp/ss/2022-09-01-20-46-07-270.jpg 
rm /private/tmp/ss/2022-09-02-07-27-54-336.jpg /private/tmp/ss/2022-09-02-07-27-54-399.jpg /private/tmp/ss/2022-09-02-07-27-54-464.jpg /private/tmp/ss/2022-09-02-07-27-54-497.jpg /private/tmp/ss/2022-09-02-07-27-54-516.jpg /private/tmp/ss/2022-09-02-07-27-54-519.jpg 
rm /private/tmp/ss/2022-09-02-07-27-54-307.jpg /private/tmp/ss/2022-09-02-07-27-54-319.jpg 
rm /private/tmp/ss/2022-09-02-07-27-51-795.jpg /private/tmp/ss/2022-09-02-07-27-51-980.jpg /private/tmp/ss/2022-09-02-07-27-52-036.jpg /private/tmp/ss/2022-09-02-07-27-54-293.jpg 
rm /private/tmp/ss/2022-09-02-07-27-59-482.jpg /private/tmp/ss/2022-09-02-07-27-58-945.jpg /private/tmp/ss/2022-09-02-07-27-57-858.jpg /private/tmp/ss/2022-09-02-07-27-55-685.jpg /private/tmp/ss/2022-09-02-07-27-55-280.jpg /private/tmp/ss/2022-09-02-07-27-55-016.jpg 
rm /private/tmp/ss/2022-09-02-07-28-05-029.jpg 
rm /private/tmp/ss/2022-09-02-07-28-04-039.jpg 
rm /private/tmp/ss/2022-09-02-07-29-42-895.jpg /private/tmp/ss/2022-09-02-07-29-42-912.jpg 
rm /private/tmp/ss/2022-09-02-07-29-44-045.jpg /private/tmp/ss/2022-09-02-07-29-43-487.jpg /private/tmp/ss/2022-09-02-07-29-43-456.jpg /private/tmp/ss/2022-09-02-07-29-43-309.jpg 
rm /private/tmp/ss/2022-09-02-07-30-35-476.jpg /private/tmp/ss/2022-09-02-07-30-35-720.jpg 
rm /private/tmp/ss/2022-09-02-09-51-12-555.jpg 
rm /private/tmp/ss/2022-09-02-10-09-39-318.jpg 
rm /private/tmp/ss/2022-09-02-13-11-09-029.jpg /private/tmp/ss/2022-09-02-13-11-15-419.jpg /private/tmp/ss/2022-09-02-13-11-15-655.jpg /private/tmp/ss/2022-09-02-13-11-07-352.jpg 
rm /private/tmp/ss/2022-09-02-13-17-26-944.jpg /private/tmp/ss/2022-09-02-13-17-27-527.jpg /private/tmp/ss/2022-09-02-13-17-28-150.jpg 
rm /private/tmp/ss/2022-09-02-13-17-32-694.jpg /private/tmp/ss/2022-09-02-13-17-32-543.jpg 
rm /private/tmp/ss/2022-09-02-14-02-35-564.jpg /private/tmp/ss/2022-09-02-14-02-35-534.jpg /private/tmp/ss/2022-09-02-14-02-34-941.jpg /private/tmp/ss/2022-09-02-14-39-14-807.jpg 
rm /private/tmp/ss/2022-09-05-10-09-19-822.jpg /private/tmp/ss/2022-09-05-10-09-19-702.jpg 
rm /private/tmp/ss/2022-09-05-10-14-26-205.jpg /private/tmp/ss/2022-09-05-10-14-30-656.jpg 
rm /private/tmp/ss/2022-09-06-12-54-28-947.jpg /private/tmp/ss/2022-09-06-12-54-29-776.jpg /private/tmp/ss/2022-09-06-12-54-31-283.jpg /private/tmp/ss/2022-09-06-12-54-32-048.jpg /private/tmp/ss/2022-09-06-12-54-33-903.jpg /private/tmp/ss/2022-09-06-12-54-35-019.jpg /private/tmp/ss/2022-09-06-12-54-35-568.jpg /private/tmp/ss/2022-09-06-12-54-37-099.jpg /private/tmp/ss/2022-09-06-12-54-37-817.jpg /private/tmp/ss/2022-09-06-12-54-40-039.jpg /private/tmp/ss/2022-09-06-12-54-46-508.jpg /private/tmp/ss/2022-09-06-12-54-46-987.jpg /private/tmp/ss/2022-09-06-12-54-48-508.jpg /private/tmp/ss/2022-09-06-12-54-48-836.jpg /private/tmp/ss/2022-09-06-12-54-49-449.jpg /private/tmp/ss/2022-09-06-12-54-49-931.jpg /private/tmp/ss/2022-09-06-12-54-50-582.jpg /private/tmp/ss/2022-09-06-12-54-51-135.jpg /private/tmp/ss/2022-09-06-12-54-51-982.jpg /private/tmp/ss/2022-09-06-12-54-52-782.jpg /private/tmp/ss/2022-09-06-12-54-57-529.jpg /private/tmp/ss/2022-09-06-12-54-58-217.jpg /private/tmp/ss/2022-09-06-12-54-58-735.jpg /private/tmp/ss/2022-09-06-12-54-59-649.jpg /private/tmp/ss/2022-09-06-12-54-59-987.jpg /private/tmp/ss/2022-09-06-12-55-00-352.jpg /private/tmp/ss/2022-09-06-12-55-00-827.jpg /private/tmp/ss/2022-09-06-12-55-01-096.jpg /private/tmp/ss/2022-09-06-12-55-01-564.jpg /private/tmp/ss/2022-09-06-12-55-02-007.jpg /private/tmp/ss/2022-09-06-12-55-02-937.jpg /private/tmp/ss/2022-09-06-12-55-03-643.jpg /private/tmp/ss/2022-09-06-12-55-04-045.jpg /private/tmp/ss/2022-09-06-12-55-04-861.jpg /private/tmp/ss/2022-09-06-12-55-06-738.jpg /private/tmp/ss/2022-09-06-12-55-07-528.jpg /private/tmp/ss/2022-09-06-12-55-07-663.jpg /private/tmp/ss/2022-09-06-12-55-08-356.jpg /private/tmp/ss/2022-09-06-12-55-08-981.jpg /private/tmp/ss/2022-09-06-12-55-09-464.jpg /private/tmp/ss/2022-09-06-12-55-09-577.jpg /private/tmp/ss/2022-09-06-12-55-10-007.jpg /private/tmp/ss/2022-09-06-12-55-10-259.jpg /private/tmp/ss/2022-09-06-12-55-11-250.jpg /private/tmp/ss/2022-09-06-12-55-11-670.jpg /private/tmp/ss/2022-09-06-12-55-12-671.jpg /private/tmp/ss/2022-09-06-14-30-05-771.jpg /private/tmp/ss/2022-09-06-14-30-06-077.jpg /private/tmp/ss/2022-09-06-14-30-06-102.jpg /private/tmp/ss/2022-09-06-14-30-06-571.jpg /private/tmp/ss/2022-09-06-14-30-07-430.jpg /private/tmp/ss/2022-09-06-14-30-09-156.jpg /private/tmp/ss/2022-09-06-14-30-09-955.jpg /private/tmp/ss/2022-09-06-14-30-10-413.jpg /private/tmp/ss/2022-09-06-14-30-11-097.jpg /private/tmp/ss/2022-09-06-14-30-11-706.jpg /private/tmp/ss/2022-09-06-14-30-15-367.jpg /private/tmp/ss/2022-09-06-14-30-16-481.jpg /private/tmp/ss/2022-09-06-14-30-17-833.jpg 
rm /private/tmp/ss/2022-09-06-12-54-28-585.jpg 
rm /private/tmp/ss/2022-09-06-10-32-28-522.jpg /private/tmp/ss/2022-09-06-10-32-28-942.jpg 
ls
touch 2022-09-06-10-18-58-404.jpg
rm /private/tmp/ss/2022-09-06-10-32-28-234.jpg /private/tmp/ss/2022-09-06-10-18-58-404.jpg 
rm /private/tmp/ss/2022-09-06-10-17-03-186.jpg /private/tmp/ss/2022-09-06-10-16-50-395.jpg 
rm /private/tmp/ss/2022-09-06-10-16-39-457.jpg /private/tmp/ss/2022-09-06-10-16-45-265.jpg 
rm /private/tmp/ss/2022-09-06-08-10-59-682.jpg 
rm /private/tmp/ss/2022-09-06-07-54-59-340.jpg /private/tmp/ss/2022-09-06-07-55-07-397.jpg /private/tmp/ss/2022-09-06-07-55-07-433.jpg 
rm /private/tmp/ss/2022-09-06-07-51-26-043.jpg 
rm 
rm /private/tmp/ss/2022-09-06-07-37-27-320.jpg /private/tmp/ss/2022-09-06-07-37-27-698.jpg 
rm /private/tmp/ss/2022-09-06-07-37-25-071.jpg /private/tmp/ss/2022-09-06-07-37-25-644.jpg /private/tmp/ss/2022-09-06-07-37-26-573.jpg 
rm /private/tmp/ss/2022-09-06-07-37-10-375.jpg /private/tmp/ss/2022-09-06-07-37-11-752.jpg 
rm /private/tmp/ss/2022-09-06-07-37-16-762.jpg /private/tmp/ss/2022-09-06-07-37-16-600.jpg /private/tmp/ss/2022-09-06-07-37-16-487.jpg /private/tmp/ss/2022-09-06-07-37-15-626.jpg /private/tmp/ss/2022-09-06-07-37-14-331.jpg 
rm /private/tmp/ss/2022-09-05-10-18-32-617.jpg /private/tmp/ss/2022-09-05-10-18-33-227.jpg /private/tmp/ss/2022-09-05-10-18-36-253.jpg /private/tmp/ss/2022-09-05-10-18-41-927.jpg /private/tmp/ss/2022-09-05-10-18-41-969.jpg /private/tmp/ss/2022-09-05-10-18-42-458.jpg 
rm /private/tmp/ss/2022-09-05-10-18-06-568.jpg /private/tmp/ss/2022-09-05-10-18-06-642.jpg /private/tmp/ss/2022-09-05-10-18-18-698.jpg /private/tmp/ss/2022-09-05-10-18-18-952.jpg /private/tmp/ss/2022-09-05-10-18-32-060.jpg /private/tmp/ss/2022-09-05-10-18-32-605.jpg 
rm /private/tmp/ss/2022-09-05-09-02-43-576.jpg 
rm /private/tmp/ss/2022-09-05-08-36-35-711.jpg /private/tmp/ss/2022-09-05-08-36-36-745.jpg 
rm /private/tmp/ss/2022-09-05-08-36-35-711.jpg /private/tmp/ss/2022-09-05-08-42-04-028.jpg /private/tmp/ss/2022-09-05-08-42-03-627.jpg 
rm /private/tmp/ss/2022-09-05-08-36-35-709.jpg 
rm /private/tmp/ss/2022-09-03-21-22-19-292.jpg /private/tmp/ss/2022-09-03-20-52-19-665.jpg /private/tmp/ss/2022-09-03-20-52-19-662.jpg /private/tmp/ss/2022-09-03-20-52-19-580.jpg /private/tmp/ss/2022-09-03-20-41-41-876.jpg /private/tmp/ss/2022-09-03-20-41-40-957.jpg 
rm /private/tmp/ss/2022-09-03-14-41-23-088.jpg 
rm /private/tmp/ss/2022-09-03-17-46-30-541.jpg /private/tmp/ss/2022-09-03-17-46-30-438.jpg 
rm /private/tmp/ss/2022-09-03-08-46-02-234.jpg 
rm /private/tmp/ss/2022-09-03-08-27-56-225.jpg /private/tmp/ss/2022-09-03-08-27-56-197.jpg 
rm /private/tmp/ss/2022-09-03-07-42-29-891.jpg /private/tmp/ss/2022-09-03-07-42-29-893.jpg /private/tmp/ss/2022-09-03-07-42-29-891.jpg /private/tmp/ss/2022-09-03-07-42-29-893.jpg 
rm /private/tmp/ss/2022-09-03-08-27-56-167.jpg 
rm /private/tmp/ss/2022-09-03-00-53-04-275.jpg /private/tmp/ss/2022-09-03-00-53-04-642.jpg 
ls
touch 2022-09-03-00-49-14-968.jpg
touch 2022-09-03-00-49-14-614.jpg
ls *jpg | zip sc6sep22.zip -@
ls
rm *jpg
rm /private/tmp/ss/2022-09-03-00-49-14-614.jpg /private/tmp/ss/2022-09-03-00-49-14-968.jpg 
rm /private/tmp/ss/2022-09-03-00-49-14-994.jpg 
rm /private/tmp/ss/2022-09-02-17-15-05-284.jpg 
rm /private/tmp/ss/2022-09-02-17-14-39-437.jpg /private/tmp/ss/2022-09-02-17-14-37-328.jpg 
rm /private/tmp/ss/2022-09-02-17-14-39-437.jpg /private/tmp/ss/2022-09-02-14-39-21-827.jpg /private/tmp/ss/2022-09-02-14-39-42-761.jpg /private/tmp/ss/2022-09-02-14-39-47-796.jpg /private/tmp/ss/2022-09-02-14-39-48-816.jpg /private/tmp/ss/2022-09-02-14-39-48-832.jpg /private/tmp/ss/2022-09-02-14-39-48-891.jpg 
rm 
rm /private/tmp/ss/2022-09-02-13-14-54-201.jpg 
rm /private/tmp/ss/2022-09-02-11-07-33-822.jpg 
rm /private/tmp/ss/2022-09-02-08-34-03-956.jpg 
rm /private/tmp/ss/2022-09-02-07-39-37-959.jpg 
rm /private/tmp/ss/2022-09-02-07-29-46-510.jpg 
rm /private/tmp/ss/2022-09-02-07-29-10-763.jpg /private/tmp/ss/2022-09-02-07-28-56-756.jpg /private/tmp/ss/2022-09-02-07-28-49-471.jpg 
rm /private/tmp/ss/2022-09-02-07-28-07-979.jpg 
rm /private/tmp/ss/2022-09-01-07-49-04-777.jpg /private/tmp/ss/2022-09-01-07-49-03-410.jpg /private/tmp/ss/2022-09-01-07-49-02-827.jpg /private/tmp/ss/2022-09-01-07-49-02-099.jpg /private/tmp/ss/2022-09-01-07-49-00-018.jpg /private/tmp/ss/2022-09-01-07-48-59-648.jpg 
rm /private/tmp/ss/2022-09-01-07-55-13-207.jpg 
rm /private/tmp/ss/2022-09-01-07-49-07-985.jpg /private/tmp/ss/2022-09-01-07-49-07-716.jpg 
rm /private/tmp/ss/2022-08-31-20-04-23-847.jpg 
rm /private/tmp/ss/2022-08-31-19-33-02-542.jpg /private/tmp/ss/2022-08-31-19-33-02-422.jpg 
touch 2022-08-31-16-39-33-381.jpg
ls *jpg | zip sc6sep22.zip -@
ls
rm 2022-08-31-16-39-33-381.jpg 
unzip -l sc6sep22.zip |grep 2022-08-31-16-39-33-381.jpg
rm 2022-08-31-16-39-33-381.jpg
rm /private/tmp/ss/2022-08-31-16-14-23-463.jpg 
rm /private/tmp/ss/2022-08-31-16-14-15-569.jpg /private/tmp/ss/2022-08-31-16-14-15-448.jpg /private/tmp/ss/2022-08-31-16-14-05-120.jpg 
rm /private/tmp/ss/2022-08-31-16-11-28-388.jpg 
rm /private/tmp/ss/2022-08-31-15-26-22-576.jpg 
rm /private/tmp/ss/2022-08-29-18-00-50-366.jpg /private/tmp/ss/2022-08-29-18-00-50-113.jpg 
rm /private/tmp/ss/2022-08-29-19-01-11-135.jpg 
rm /private/tmp/ss/2022-08-29-19-01-11-481.jpg 
rm /private/tmp/ss/2022-08-30-21-21-04-276.jpg /private/tmp/ss/2022-08-30-21-21-03-901.jpg /private/tmp/ss/2022-08-30-21-21-03-624.jpg /private/tmp/ss/2022-08-30-21-20-51-804.jpg /private/tmp/ss/2022-08-30-21-20-51-548.jpg 
rm /private/tmp/ss/2022-08-31-14-25-55-810.jpg /private/tmp/ss/2022-08-31-14-25-54-289.jpg /private/tmp/ss/2022-08-31-14-25-20-286.jpg 
rm /private/tmp/ss/2022-08-31-14-25-01-077.jpg 
rm /private/tmp/ss/2022-08-31-14-30-42-509.jpg 
rm /private/tmp/ss/2022-08-31-14-34-05-714.jpg 
rm /private/tmp/ss/2022-08-31-14-38-18-727.jpg /private/tmp/ss/2022-08-31-14-38-39-371.jpg 
rm /private/tmp/ss/2022-08-31-14-41-16-413.jpg 
rm /private/tmp/ss/2022-08-31-14-48-45-349.jpg 
rm /private/tmp/ss/2022-08-31-14-58-33-025.jpg /private/tmp/ss/2022-08-31-14-58-32-464.jpg 
rm /private/tmp/ss/2022-08-31-15-01-04-261.jpg /private/tmp/ss/2022-08-31-15-01-03-986.jpg /private/tmp/ss/2022-08-31-15-01-02-579.jpg 
rm /private/tmp/ss/2022-08-31-15-02-30-494.jpg 
rm /private/tmp/ss/2022-08-31-15-04-05-948.jpg /private/tmp/ss/2022-08-31-15-04-06-081.jpg 
rm /private/tmp/ss/2022-08-31-15-09-24-982.jpg /private/tmp/ss/2022-08-31-15-09-23-653.jpg 
rm /private/tmp/ss/2022-08-31-15-20-34-961.jpg 
rm /private/tmp/ss/2022-08-31-20-04-22-506.jpg /private/tmp/ss/2022-08-31-20-04-23-127.jpg 
rm /private/tmp/ss/2022-09-06-10-13-36-259.jpg 
rm /private/tmp/ss/2022-09-06-10-11-58-686.jpg 
rm /private/tmp/ss/2022-09-06-10-07-52-216.jpg /private/tmp/ss/2022-09-06-10-07-51-946.jpg 
rm /private/tmp/ss/2022-09-06-08-31-38-854.jpg 
rm /private/tmp/ss/2022-09-06-07-54-03-703.jpg /private/tmp/ss/2022-09-06-07-54-04-164.jpg /private/tmp/ss/2022-09-06-07-54-12-543.jpg /private/tmp/ss/2022-09-06-07-54-14-565.jpg /private/tmp/ss/2022-09-06-07-54-20-765.jpg 
rm /private/tmp/ss/2022-09-06-07-53-33-560.jpg 
rm /private/tmp/ss/2022-09-06-07-52-42-899.jpg /private/tmp/ss/2022-09-06-07-52-30-036.jpg /private/tmp/ss/2022-09-06-07-52-43-819.jpg 
rm /private/tmp/ss/2022-09-06-07-40-11-175.jpg 
rm /private/tmp/ss/2022-09-06-07-37-21-645.jpg /private/tmp/ss/2022-09-06-07-37-20-774.jpg /private/tmp/ss/2022-09-06-07-37-22-504.jpg 
rm /private/tmp/ss/2022-09-06-07-37-18-255.jpg /private/tmp/ss/2022-09-06-07-37-18-605.jpg /private/tmp/ss/2022-09-06-07-37-19-226.jpg /private/tmp/ss/2022-09-06-07-37-20-102.jpg /private/tmp/ss/2022-09-06-07-37-20-131.jpg /private/tmp/ss/2022-09-06-07-37-20-375.jpg 
rm /private/tmp/ss/2022-09-05-17-49-19-280.jpg /private/tmp/ss/2022-09-05-17-49-19-265.jpg 
mv /private/tmp/ss .
ls
tail reg
cd ../..
tail reg
tail regs
less ~/.ssh/config
tail regs 
vi id_mapping 
git add id_mapping 
git commit -m more
cat id_mapping /tmp/newids |sort|uniq > aabb
mv aabb id_mapping 
git diff
git diff id_mapping
vi id_mapping 
git add id_mapping 
git commit -m more
git push
cat ~/Playing/UD/UD_Irish-IDT/ga_idt-ud-*|awk '{print $1}'|grep '_'
cat ~/Playing/UD/UD_Irish-IDT/ga_idt-ud-*|awk caidé
cat ~/Playing/UD/UD_Irish-IDT/ga_idt-ud-*|grep caidé
less ~/Playing/UD/UD_Irish-IDT/ga_idt-ud-train.conllu 
less ~/Playing/UD/UD_Irish-IDT/ga_idt-ud-train.conllu 
grep anadedvukaj id_mapping 
vi id_mapping 
vi id_mapping 
git add id_mapping 
git commit -m more
cat id_mapping /tmp/newids |sort|uniq > aabb
mv aabb id_mapping 
git diff
git diff id_mapping
vi id_mapping 
git diff id_mapping
git add id_mapping 
git commit -m 'sort|uniq'
cat id_mapping |awk -F'\t' '{print $2}'|sort|uniq -c
cat id_mapping |awk -F'\t' '{print $2}'|sort|uniq -c|grep ' 2 '
grep 19800681808 id_mapping 
grep 21046845985 id_mapping 
grep 25636969152 id_mapping 
grep 25636969152 id_mapping 
grep 411827659 id_mapping 
grep 74171778530 id_mapping 
grep 70167393310 id_mapping 
grep 69793096620 id_mapping 
grep 6830695597 id_mapping 
grep 48772111008 id_mapping 
grep 411827659 id_mapping 
vi id_mapping 
git add id_mapping 
git commit -m more
vi id_mapping 
vi id_mapping 
tail regs 
grep em_llouise2 id_mapping 
grep emlouisec id_mapping 
vi id_mapping 
