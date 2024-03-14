#!/bin/sh
# This assumes you have whisper, mfa, and ffmpeg
# mfa: conda install -c conda-forge montreal-forced-aligner
# you also need models for it:


whisper_tmp=$(mktemp -d -t walign.XXXXXX)
mfa_tmp=$(mktemp -d -t mfaalign.XXXXXX)

USAGE="run-alignment.sh [input] [output]"

# Check if input directory exists
if [ ! -d "$1" ]
then
    echo $USAGE
    exit 1
fi

# Check if output directory exists;
# if not, create it
if [ ! -d "$2" ]
then
    echo "Directory $2 does not exist; creating"
    mkdir "$2"
    if [[ $? -ne 0 ]]
    then
        echo "Could not create $2"
        exit 1
    fi
fi

# check for subdirectories; assume that if the
# parent exists/could be created, the subdirs can too
if [ ! -d "$2/wav" ]
then
    mkdir "$2/wav"
fi
if [ ! -d "$2/tsv" ]
then
    mkdir "$2/tsv"
fi

# Hard coded paths! Boo!
MFA_ACOUSTIC=$HOME/Documents/MFA/pretrained_models/acoustic/english_us_arpa.zip
MFA_DICT=$HOME/Documents/MFA/pretrained_models/dictionary/english_us_arpa.dict
MFA_G2P=$HOME/Documents/MFA/pretrained_models/g2p/english_us_arpa.zip

# at least try to be helpful if they don't exist
if [ ! -e $MFA_ACOUSTIC ]
then
    echo "MFA acoustic model not found"
    echo "mfa model download acoustic english_us_arpa"
fi
if [ ! -e $MFA_DICT ]
then
    echo "MFA dictionary not found"
    echo "mfa model download dictionary english_us_arpa"
fi
if [ ! -e $MFA_G2P ]
then
    echo "MFA g2p model not found"
    echo "mfa model download g2p english_us_arpa"
fi


# transcribes with whisper and resamples audio for MFA
python transcribe-for-mfa.py "$1" $whisper_tmp

# Run MFA
mfa align --g2p_model_path $MFA_G2P $whisper_tmp $MFA_DICT $MFA_ACOUSTIC $mfa_tmp

textgrid_tmp=$(mktemp -d -t textgrid.XXXXXX)
find $mfa_tmp -name '*.TextGrid' -exec mv '{}' $textgrid_tmp ';'

# convert MFA output
python mfa-to-tsv.py $textgrid_tmp "$2/tsv"

# resample the audio
for subdir in "$1"/*
do
    if [ -d "$subdir" ]
    then
        for wavfile in $subdir/*wav
        do
            spk=spk$(echo $wavfile|awk -F'/' '{print $(NF-1)}')
            outwav=$(echo $wavfile|awk -F/ '{print $NF}')
            echo ffmpeg -i $wavfile -c:a pcm_s24le -ar 44100 "$2"/wav/${spk}_$outwav
        done
    fi
done

# tidy up
#rm -rf $whisper_tmp
#rm -rf $mfa_tmp
#rm -rf $textgrid_tmp