#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --time=20:00:00
#SBATCH --mem=30GB
#SBATCH --job-name=dsga1006-supsup-basis
#SBATCH --mail-type=END
#SBATCH --mail-user=db4045@nyu.edu
#SBATCH --gres=gpu:p40:1
#SBATCH --output=slurm_supsup_basis_task_eval_test_%j.out

# Refer to https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/prince/batch/submitting-jobs-with-sbatch
# for more information about the above options

# Remove all unused system modules
module purge
module load cuda/10.1.105
module load anaconda3/5.3.1

# Move into the directory that contains our code
SRCDIR=$(pwd)

# AT RUNS
/scratch/db4045/capstone_env/bin/python $SRCDIR/basis.py --data="/scratch/db4045/data" --seed=0 --seed-model="/scratch/at2507/runs/at_seed_epoch10_single/SupsupSeed/dhrupad_seed_mask~try=0/final.pt" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup-basis-multitask.yaml --multigpu="0" --task-eval 3 --name dhrupad_basis_multimask --log-dir=/scratch/at2507/runs/dhrupad_seed_epoch10_single/SupsupBasis/
# rm -rf /scratch/at2507/runs/at_seed_epoch10_single/SupsupSeed/

echo "Training Stage"
# AT: using dhrupad's environment for consistency
/scratch/db4045/capstone_env/bin/python $SRCDIR/main.py --data="/scratch/db4045/data" --seed=0 --log-dir=/scratch/at2507/runs/at_seed_epoch10_single/SupsupSeed/ --config $SRCDIR/experiments/seeds/splitcifar100/configs/rn18-supsup_5.yaml --multigpu="0" --epochs 10 --multigpu="0" --sparsity 8 --name at_seed_mask

echo "Inference using Multimask(basis)"
/scratch/db4045/capstone_env/bin/python $SRCDIR/basis.py --data="/scratch/db4045/data" --seed=0 --seed-model="/scratch/at2507/runs/at_seed_epoch10_single/SupsupSeed/dhrupad_seed_mask~try=0/final.pt" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup-basis-multitask.yaml --multigpu="0" --task-eval 3 --name dhrupad_basis_multimask --log-dir=/scratch/at2507/runs/dhrupad_seed_epoch10_single/SupsupBasis/
echo "Inference using SupSup(main)"
/scratch/db4045/capstone_env/bin/python $SRCDIR/main.py --data="/scratch/db4045/data" --seed=0 --resume="/scratch/at2507/runs/at_seed_epoch10_single/SupsupSeed/dhrupad_seed_mask~try=0/final.pt" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup.yaml --multigpu="0" --task-eval 3 --name dhrupad_main_supsup --log-dir=/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupBasis/ --sparsity 8
echo "Inference using Multimask(main)"
/scratch/db4045/capstone_env/bin/python $SRCDIR/main.py --data="/scratch/db4045/data" --seed=0 --resume="/scratch/at2507/runs/at_seed_epoch10_single/SupsupSeed/dhrupad_seed_mask~try=0/final.pt" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup-basis-multitask.yaml --multigpu="0" --task-eval 3 --name dhrupad_main_multimask --log-dir=/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupBasis/ --num_seed_tasks_learned 5 --sparsity 8

# /scratch/db4045/capstone_env/bin/python $SRCDIR/main.py --data="/scratch/db4045/data" --seed=0 --log-dir=/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupSeed/ --config $SRCDIR/experiments/seeds/splitcifar100/configs/rn18-supsup_5.yaml --multigpu="0" --epochs 10 --multigpu="0" --sparsity 8 --name dhrupad_seed_mask
#
# echo "Inference using Multimask(basis)"
# /scratch/db4045/capstone_env/bin/python $SRCDIR/basis.py --data="/scratch/db4045/data" --seed=0 --seed-model="/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupSeed/dhrupad_seed_mask~try=0/final.pt" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup-basis-multitask.yaml --multigpu="0" --task-eval 3 --name dhrupad_basis_multimask --log-dir=/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupBasis/
# echo "Inference using SupSup(main)"
# /scratch/db4045/capstone_env/bin/python $SRCDIR/main.py --data="/scratch/db4045/data" --seed=0 --resume="/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupSeed/dhrupad_seed_mask~try=0/final.pt" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup.yaml --multigpu="0" --task-eval 3 --name dhrupad_main_supsup --log-dir=/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupBasis/ --sparsity 8
# echo "Inference using Multimask(main)"
# /scratch/db4045/capstone_env/bin/python $SRCDIR/main.py --data="/scratch/db4045/data" --seed=0 --resume="/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupSeed/dhrupad_seed_mask~try=0/final.pt" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup-basis-multitask.yaml --multigpu="0" --task-eval 3 --name dhrupad_main_multimask --log-dir=/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupBasis/ --num_seed_tasks_learned 5 --sparsity 8

# test dhrupads code - at comments
#rm -rf /scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupSeed_cpu/
#/scratch/db4045/capstone_env/bin/python $SRCDIR/main_cpu.py --data="/scratch/db4045/data" --seed=0 --log-dir=/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupSeed_cpu/ --config $SRCDIR/experiments/seeds/splitcifar100/configs/rn18-supsup_5.yaml --epochs 10 --sparsity 8 --name dhrupad_seed_mask
#
#/scratch/db4045/capstone_env/bin/python $SRCDIR/basis_cpu.py --data="/scratch/db4045/data" --seed=0 --seed-model="/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupSeed_cpu/dhrupad_seed_mask~try=0/final.pt" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup-basis-multitask.yaml --task-eval 3 --name dhrupad_basis_multimask --log-dir=/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupBasis/
#/scratch/db4045/capstone_env/bin/python $SRCDIR/basis_cpu.py --data="/scratch/db4045/data" --seed=0 --seed-model="/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupSeed_cpu/dhrupad_seed_mask~try=0/final.pt" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup-basis.yaml --task-eval 3 --name dhrupad_basis_singlemask --log-dir=/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupBasis/
#/scratch/db4045/capstone_env/bin/python $SRCDIR/basis_cpu.py --data="/scratch/db4045/data" --seed=0 --seed-model="/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupSeed_cpu/dhrupad_seed_mask~try=0/final.pt" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup.yaml --task-eval 3 --name dhrupad_basis_orig --log-dir=/scratch/db4045/runs/dhrupad_seed_epoch10_single/SupsupBasis/

#/scratch/db4045/capstone_env/bin/python $SRCDIR/basis_cpu.py --data="/scratch/db4045/data" --seed=0 --seed-model="/scratch/db4045/runs/dhrupad_runs/SupsupSeed/rn18-supsup_num_masks_5/id=supsup~seed=0~sparsity=4~try=0/final.py" --config $SRCDIR/experiments/basis/splitcifar100/configs/rn18-supsup-basis-multitask.yaml --task-eval 3 --name dhrupad_basis_multimask --log-dir=/scratch/db4045/runs/dhrupad_test/SupsupBasis/
