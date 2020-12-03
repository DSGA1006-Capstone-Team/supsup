#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
<<<<<<< HEAD
#SBATCH --time=144:00:00
#SBATCH --mem=30GB
#SBATCH --job-name=dsga1006-supsup
#SBATCH --mail-type=END
#SBATCH --mail-user=$USER@nyu.edu
#SBATCH --output=slurm_supsup_%j.out
=======
#SBATCH --time=20:00:00
#SBATCH --mem=30GB
#SBATCH --job-name=dsga1006-supsup
#SBATCH --mail-type=END
#SBATCH --mail-user=at2507@nyu.edu
#SBATCH --gres=gpu:2
#SBATCH --output=logs/slurm_supsup_%j.out
>>>>>>> dhrupad/dev

# Refer to https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/prince/batch/submitting-jobs-with-sbatch
# for more information about the above options

# Remove all unused system modules
module purge
<<<<<<< HEAD
module load cuda/10.1.105
module load anaconda3/5.3.1

# Move into the directory that contains our code
SRCDIR=$(pwd)

/scratch/db4045/capstone_env/bin/python $SRCDIR/experiments/SupsupSeed/splitcifar100/rn18-supsup.py --data="/scratch/db4045/data" --seeds 1 --num-masks 20 --logdir-prefix="dhrupad_runs"
=======

# Move into the directory that contains our code
SRCDIR=$HOME/supsup
cd $SRCDIR

# Activate the conda environment
# source ~/.bashrc
# conda activate dsga3001
source env/bin/activate

# Execute the script
# python ./lab0-test.py
# python ./experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0|1|2|3" --data="./data" --seeds 1

# python experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0|1|2|3" --data=/path/to/dataset/parent --seeds 1
# python ./experiments/GG/splitcifar100/rn18-supsup.py  --data="./data" --seeds 1
# python experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0|1|2|3" --data=./data --seeds 1
python experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0|1" --data=./data --seeds 1
>>>>>>> dhrupad/dev
