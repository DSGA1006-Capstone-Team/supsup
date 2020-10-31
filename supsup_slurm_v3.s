#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --time=20:00:00
#SBATCH --mem=30GB
#SBATCH --job-name=dsga1006-supsup
#SBATCH --mail-type=END
#SBATCH --mail-user=at2507@nyu.edu
#SBATCH --gres=gpu:2
#SBATCH --output=slurm_supsup_%j.out

# Refer to https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/prince/batch/submitting-jobs-with-sbatch
# for more information about the above options

# Remove all unused system modules
module purge
module load cuda/10.1.105

# Move into the directory that contains our code
SRCDIR=$HOME/supsup

# Activate the conda environment
# source ~/.bashrc
# conda activate dsga3001
source env/bin/activate

# Execute the script
conda install pytorch==1.5.1 torchvision==0.6.1 -c pytorch
pip install torch==1.5.0+cu101 torchvision==0.6.0+cu101 -f https://download.pytorch.org/whl/torch_stable.html
# python ./experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0|1|2|3" --data="./data" --seeds 1

# python experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0|1|2|3" --data=/path/to/dataset/parent --seeds 1
# python ./experiments/GG/splitcifar100/rn18-supsup.py  --data="./data" --seeds 1
# python experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0|1|2|3" --data=./data --seeds 1
# python experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0|1" --data=./data --seeds 1
python experiments/SupsupSeed/splitcifar100/rn18-supsup_small.py --data="./data" --seeds 1 --num-masks 3 --gpu-sets="1"
# python experiments/SupsupSeed/splitcifar100/rn18-supsup_small.py --data="./data" --seeds 1 --num-masks 3 --gpu-sets="0|1"
# python experiments/SupsupSeed/splitcifar100/rn18-supsup.py --data="./data" --seeds 1 --num-masks 5 --gpu-sets="0"
# python experiments/SupsupSeed/splitcifar100/rn18-supsup.py --data="./data" --seeds 1 --num-masks 7 --gpu-sets="0"
# python experiments/SupsupSeed/splitcifar100/rn18-supsup.py --data="./data" --seeds 1 --num-masks 10 --gpu-sets="0"
# python experiments/SupsupSeed/splitcifar100/rn18-supsup.py --data="./data" --seeds 1 --num-masks 12 --gpu-sets="0"
# python experiments/SupsupSeed/splitcifar100/rn18-supsup.py --data="./data" --seeds 1 --num-masks 15 --gpu-sets="0"
