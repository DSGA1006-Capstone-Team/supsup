#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --time=150:00:00
#SBATCH --mem=30GB
#SBATCH --job-name=dsga1006-supsup
#SBATCH --mail-type=END
#SBATCH --mail-user=$USER@nyu.edu
#SBATCH --output=slurm_supsup_%j.out

# Refer to https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/prince/batch/submitting-jobs-with-sbatch
# for more information about the above options

# Remove all unused system modules
module purge
module load cuda/10.1.105
module load anaconda3/5.3.1

# Move into the directory that contains our code
SRCDIR=$(pwd)

/scratch/db4045/capstone_env/bin/python $SRCDIR/experiments/SupsupSeed/splitcifar100/rn18-supsup.py --data="/scratch/db4045/data" --seeds 1 --num-masks 15 --logdir-prefix="dhrupad_runs"
