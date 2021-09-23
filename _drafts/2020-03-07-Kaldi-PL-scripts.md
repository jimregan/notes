[ForcedAlign/run.sh](https://github.com/speech-clarin-pl/SpeechToolsWorkers/blob/master/speech_tools/tools/ForcedAlign/run.sh)

```bash
./steps/make_mfcc.sh --nj 1 data
./steps/compute_cmvn_stats.sh data
./local_utils/prepare_dict.sh data dict
./utils/prepare_lang.sh dict "<unk>" tmp lang
./steps/align_fmllr.sh --nj 1 --beam ${beam} --retry-beam ${retry_beam} data lang tri3b_mmi ali
./steps/get_train_ctm.sh data lang ali
./local_utils/get_phoneme_ctm.sh data lang ali

awk '$0="@"$0' ali/phonectm | cat ali/ctm - | sort -r -k3n > $out
```

[ForcedAlign/run\_eaf.sh](https://github.com/speech-clarin-pl/SpeechToolsWorkers/blob/master/speech_tools/tools/ForcedAlign/run_eaf.sh)

```bash
if $phones ; then
    ./local_utils/get_phoneme_ctm.sh --use-segments false data lang ali

    python3 local_utils/ctm2eaf.py --phones-ctm ali/phonectm ali/ctm data/seg2tier ${eaf_in} ${eaf_out}
else
    python3 local_utils/ctm2eaf.py ali/ctm data/seg2tier ${eaf_in} ${eaf_out}
fi
```

[ForcedAlign/run\_segments.sh](https://github.com/speech-clarin-pl/SpeechToolsWorkers/blob/master/speech_tools/tools/ForcedAlign/run_segments.sh)


[SegmentAlign/run.sh](https://github.com/speech-clarin-pl/SpeechToolsWorkers/blob/master/speech_tools/tools/SegmentAlign/run.sh)


[misc/transcribe\_word\_list.sh](https://github.com/speech-clarin-pl/SpeechToolsWorkers/blob/master/speech_tools/tools/misc/transcribe_word_list.sh)


[misc/train\_g2p.sh](https://github.com/speech-clarin-pl/SpeechToolsWorkers/blob/master/speech_tools/tools/misc/train_g2p.sh)


[SpeechActivityDetection/run.sh](https://github.com/speech-clarin-pl/SpeechToolsWorkers/blob/master/speech_tools/tools/SpeechActivityDetection/run.sh)

