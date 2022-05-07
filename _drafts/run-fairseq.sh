
split=$1
cpunum=$2

CUDA_VISIBLE_DEVICES=$cpunum fairseq-train \
    --distributed-world-size 1 \
    /home/joregan/.ljs/data/$split \
    --save-dir /home/joregan/.ljs/runs/$split \
    --tensorboard-logdir /home/joregan/.ljs/runs/$split/runs \
    --fp16 \
    --post-process letter \
    --valid-subset valid \
    --no-epoch-checkpoints \
    --best-checkpoint-metric wer \
    --patience 100 \
    --num-workers 1 \
    --max-update 80000 \
    --sentence-avg \
    --task audio_pretraining \
    --arch wav2vec_ctc \
    --finetune-from-model /home/joregan/.ljs/model/wav2vec_small_960h.pt \
    --w2v-path /home/joregan/.ljs/model/wav2vec_small.pt \
    --labels ltr \
    --apply-mask \
    --mask-selection static \
    --mask-other 0 \
    --mask-length 10 \
    --mask-prob 0.5 \
    --layerdrop 0.1 \
    --mask-channel-selection static \
    --mask-channel-other 0 \
    --mask-channel-length 64 \
    --mask-channel-prob 0.5 \
    --zero-infinity \
    --feature-grad-mult 0.0 \
    --freeze-finetune-updates 10000 \
    --validate-after-updates 10000 \
    --optimizer adam \
    --adam-betas '(0.9, 0.98)' \
    --adam-eps 1e-08 \
    --lr 2e-05 \
    --lr-scheduler tri_stage \
    --warmup-steps 8000 \
    --hold-steps 32000 \
    --decay-steps 40000 \
    --final-lr-scale 0.05 \
    --final-dropout 0.0 \
    --dropout 0.0 \
    --activation-dropout 0.1 \
    --criterion ctc \
    --attention-dropout 0.0 \
    --max-tokens 1280000 \
    --seed 2337 \
    --log-format json \
    --log-interval 500 \
    --ddp-backend no_c10d