#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --time=20:00:00
#SBATCH --mem=30GB
#SBATCH --job-name=supsup-seed
#SBATCH --mail-type=END
#SBATCH --mail-user=$USER@nyu.edu
#SBATCH --gres=gpu:1
#SBATCH --output=logs/slurm_supsup_seed_gpu_20__v2_%j.out

# Refer to https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/prince/batch/submitting-jobs-with-sbatch
# for more information about the above options

# Remove all unused system modules
module purge
module load cuda/10.2.89
source /home/db4045/.bashrc && source supsup

# Move into the directory that contains our code
SRCDIR=$(pwd)

python $SRCDIR/experiments/SupsupSeed/splitcifar100/rn18-supsup-gpu_v2.py --data="/scratch/db4045/data" --seeds 3 --num-masks 20 --logdir-prefix="dhrupad_runs_supsup_seed" --gpu-sets="0" 
