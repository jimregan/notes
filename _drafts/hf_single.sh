#!/bin/bash

BASEDIR=$1

if [ ! -d "$BASEDIR" ]
then
	echo "Not a directory: $BASEDIR"
	exit 1
fi
if [ ! -d "$BASEDIR"/logdir ]
then
	echo "No logdir/ in $BASEDIR"
	echo "Are you sure you gave the correct path?"
	exit 1
fi
if [ ! -d "$PWD/.git" ]
then
	echo "$PWD is not a git repository"
	echo "Doing something that isn't totally dumb is up to you"
	exit 1
fi

cp -r "$BASEDIR"/logdir .
git add logdir && git commit -m 'start: adding logs'

ls $BASEDIR/checkpoint_*|awk -F'_' '{print $NF}'|sort -n|while read i
do
	cp $BASEDIR/checkpoint_$i checkpoint.pt &&\
	git add checkpoint.pt &&\
	git commit -m "checkpoint $i"
done

git push origin main
echo "run: 'git lfs prune' to remove everything but the most recent checkpoint"
