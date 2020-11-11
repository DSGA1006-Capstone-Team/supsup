#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --time=20:00:00
#SBATCH --mem=30GB
#SBATCH --job-name=dsga1006-supsup-basis
#SBATCH --mail-type=END
#SBATCH --mail-user=db4045@nyu.edu
#SBATCH --output=slurm_supsup_basis_3_%j.out

# Refer to https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/prince/batch/submitting-jobs-with-sbatch
# for more information about the above options

# Remove all unused system modules
module purge
module load cuda/10.1.105
module load anaconda3/5.3.1

# Move into the directory that contains our code
SRCDIR=$(pwd)

# Activate the conda environment
# source ~/.bashrc
# conda activate dsga3001
# source env/bin/activate

# Execute the script
# conda activate supsup
# conda install -y pytorch==1.5.1 torchvision==0.6.1 -c pytorch
# pip install torch==1.5.0+cu101 torchvision==0.6.0+cu101 -f https://download.pytorch.org/whl/torch_stable.html

/scratch/db4045/capstone_env/bin/python $SRCDIR/experiments/basis/splitcifar100/rn18-supsup-basis.py --data="/scratch/db4045/data" --seeds=1 --num-masks=3 --seed_model_dir="/scratch/db4045/runs/dhrupad_runs/SupsupSeed/rn18-supsup_num_masks_{num_masks}/id=supsup~seed={seed}~sparsity={sparsity}~try=0/" --logdir-prefix="dhrupad_runs"