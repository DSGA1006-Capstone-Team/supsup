#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --time=20:00:00
#SBATCH --mem=30GB
#SBATCH --job-name=dsga1006-supsup-basis
#SBATCH --mail-type=END
#SBATCH --mail-user=db4045@nyu.edu
#SBATCH --gres=gpu:1
#SBATCH --output=slurm_supsup_bn_gpus_%j.out

# Refer to https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/prince/batch/submitting-jobs-with-sbatch
# for more information about the above options

# Remove all unused system modules
module purge
module load cuda/10.1.105
module load anaconda3/5.3.1

# Move into the directory that contains our code
SRCDIR=$(pwd)

rm -rf /scratch/db4045/scratch/*

echo "Training with new BN initializing"
/scratch/db4045/capstone_env/bin/python $SRCDIR/experiments/GG/splitcifar100/debug-load-issue/train.py
echo "Testing with new BN initializing"
/scratch/db4045/capstone_env/bin/python $SRCDIR/experiments/GG/splitcifar100/debug-load-issue/load.py
echo "Testing with new BN initializing all masks"
/scratch/db4045/capstone_env/bin/python $SRCDIR/experiments/GG/splitcifar100/debug-load-issue/load_train_mask_alphas.py
