file=$1
date=$(basename $file '.enex')

echo "---" >> _posts/$date-evernote-links.md
echo "toc: false" >> _posts/$date-evernote-links.md
echo "layout: post" >> _posts/$date-evernote-links.md
echo "hidden: true" >> _posts/$date-evernote-links.md
echo "description: Old links" >> _posts/$date-evernote-links.md
echo "title: Evernote web clips, $date" >> _posts/$date-evernote-links.md
echo "categories: [evernote, web clip]" >> _posts/$date-evernote-links.md
echo "---" >> _posts/$date-evernote-links.md
echo >> _posts/$date-evernote-links.md

grep '<source-url' $1 |grep -v 'en-cache' |awk -F'[<>]' '{print $3}' > source-tmp
grep '<title>' $1 |grep -v 'en-cache' |awk -F'[<>]' '{print $3}' > title-tmp

paste source-tmp title-tmp | awk -F'\t' '{print "[" $1 "](" $2 ")\n"}' >> _posts/$date-evernote-links.md