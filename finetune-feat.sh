#!/bin/bash
datasets="esol freesolv lipo qm7 bbbp bace "
datasets="bbbp bace "
epoch=100
batch_size=32
source activate chem
for dataset in $datasets; do
        for num in $(seq 1 3); do
        {
          if [ $dataset = "bbbp" ] || [ $dataset = "bace" ]; then
            type="classification"
          else
            type="regression"
          fi
          python main.py finetune \
                        --separate_test_path "exampledata/finetune/gem/$dataset-gem-test.csv" \
                        --separate_val_path "exampledata/finetune/gem/$dataset-gem-val.csv" \
                        --separate_val_features_path "exampledata/finetune/gem/2d-descriptor/$dataset-features-valid.npz" \
                        --separate_test_features_path "exampledata/finetune/gem/2d-descriptor/$dataset-features-test.npz" \
                        --features_path "exampledata/finetune/gem/2d-descriptor/$dataset-features-train.npz" \
                        --data_path exampledata/finetune/gem/$dataset-gem-train.csv \
                        --seed $num\
                        --checkpoint_path grover/model/grover_large.pt \
                        --dataset_type $type \
                        --split_type scaffold_balanced \
                        --ensemble_size 1 \
                        --num_folds 1 \
                        --no_features_scaling \
                        --ffn_hidden_size 200 \
                        --batch_size $batch_size \
                        --epochs $epoch \
                        --init_lr 0.00015 > "./$dataset-featurize-result$num.txt"
        }
        done
done
