#!/bin/bash

task_id=$1
auth_tok=CHANGEME
header="Authorization: Token $auth_tok"

check=$(echo "$task_id"|grep '=')
if [[ "$check" != "" ]]
then
	task_id=$(echo "$task_id"|awk -F'=' '{print $NF}')
fi

wavfile=$(curl http://130.237.3.107:8080/api/tasks/$task_id -H "$header" |jq .|grep 'audio'|grep wav|awk -F'"' '{print "http://130.237.3.107:8080" $4}')
echo $wavfile
outfile=$(basename $wavfile)
curl -H "$header" $wavfile > $outfile
