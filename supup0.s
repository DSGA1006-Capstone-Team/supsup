#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=20:00:00
#SBATCH --mem=30GB
#SBATCH --job-name=dsga1006-supsup
#SBATCH --mail-type=END
#SBATCH --mail-user=at2507@nyu.edu
#SBATCH --output=slurm_supsup_%j.out
  
# Refer to https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/prince/batch/submitting-jobs-with-sbatch
# for more information about the above options

# Remove all unused system modules
module purge

# Move into the directory that contains our code
SRCDIR=$HOME/supsup

# Activate the conda environment
# source ~/.bashrc
# conda activate dsga3001
source env/bin/activate 

# Execute the script
# python ./lab0-test.py
# python ./experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0|1|2|3" --data="./data" --seeds 1
# And we're done!

python ./experiments/GG/splitcifar100/rn18-supsup.py  --data="./data" --seeds 1