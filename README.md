# Supermasks in Superposition

Mitchell Wortsman<sup>\*</sup>, Vivek Ramanujan<sup>\*</sup>, Rosanne Liu, Aniruddha Kembhavi, Mohammad Rastegari, Jason Yosinski, Ali Farhadi  

Blog post: <a href="https://mitchellnw.github.io/blog/2020/supsup/"> https://mitchellnw.github.io/blog/2020/supsup </a>

<img src="images/teaser_supsup.png">


## Simple one-file notebook example

We have added `mnist.ipynb` as a self-contained example of the GG and GNs scenarios. It runs well without GPUs!

## General directory structure

- `data/` contains all of our dataset declarations. Each dataset object has a `train_loader`, `val_loader`, and an `update_task` method, all used elsewhere in our code. The `update_task` method takes an integer and changes the `train_loader` and `val_loader` variables to the appropriate enumerated task.
- `models/` contains model declarations in associated files (`resnet`, ). If would you like to build your own, use the {`builder.conv1x1`, `builder.conv3x3` etc.} methods so that your model uses the appropriate convolution type declared by the `--conv-type` flag. See an existing model file for details.
    - `small.py` contains small models used in GNu and NNs experiments.
    - `gemresnet.py` contains a smaller version of ResNet-20 used in the GG SplitCIFAR100 experiments.
    - `resnet.py` contains the standard ResNet architecures for our GG SplitImageNet experiments.
    - `modules.py` contains layers used in our experiments. In particular, we use `FastMultitaskMaskConv` for GNu and NNs experiments and `MultitaskMaskConv` for GG experiments.
- `trainers/` contains model trainers for different scenarios.
    - `default.py` is a simple classification setup, used for GG, GNu, and GNs
    - `nns.py` is used for the NNs scenario
    - `reinit.py` is used for the Transfer experiment in Figure 3 (right).
- `experiments/` contains code for running experiments, grouped into `GG/`, `GNu/`, and `NNs/` in accordance with our paper's hierarchy.

## Environment set-up

We include requirements file in `requirements.txt`. Make a new virtual environment in your favorite environment manager (conda, virtualenv) and run `pip install -r requirements.txt`.

## GG Experiments

### Directory Structure

The `experiments/GG/splitcifar100/` folder contains the following experiment scripts:

1. `experiments/GG/splitcifar100/rn18-batche-randw.py` -> Corresponds to _BatchE (GG) - Rand W_ in Figure 3 (right)
2. `experiments/GG/splitcifar100/rn18-separate-heads.py` -> Corresponds to _Separate Heads_ in Figure 3 (right)
3. `experiments/GG/splitcifar100/rn18-separate-heads-randw.py` -> Corresponds to _Separate Heads - Rand W_ in Figure 3 (right)
4. `experiments/GG/splitcifar100/rn18-supsup.py` -> Corresponds to _SupSup_ (our method) in Figure 3 (right)
5. `experiments/GG/splitcifar100/rn18-supsup-transfer.py` -> Corresponds to _SupSup Transfer_ (our method with transfer) in Figure 3 (right)
6. `experiments/GG/splitcifar100/rn18-upperbound.py` -> Corresponds to _Upper Bound_ in Figure 3 (right)


The `splitimagenet/` folder contains one experiment script:

1. `experiments/GG/splitimagenet/rn50-supsup.py` -> Corresponds to all 3 runs of _Sup Sup_ in Figure 3 (left)

The actual settings for these experiments (e.g. hyperparameters) are stored in `experiments/GG/splitcifar100/configs` and `experiments/GG/splitimagenet/configs`

### How to run an experiment

Go to the root directory of this code repository and invoke one of the scripts from above with `--gpu-sets`, `--seeds`, and `--data` flags, e.g.

```
python experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0|1|2|3" --data=/path/to/dataset/parent --seeds 1
```

The `--data` flag is the path to the folder which contains the required dataset, in this case CIFAR100 or ImageNet, which we then split into tasks. CIFAR100 will be automatically downloaded if it's not in `--data`, ImageNet will not. `--seeds` says how many seeds (from 0 to `--seeds - 1` to evaluate on. For all of our reported SplitCIFAR100 experiments we use 5. Our reported experiments for SplitImageNet are with 1 seed (with fixed ImageNet split). The default number of seeds in this repo is 1.

Since we are in the GG scenario, these models can be trained on each task individually. As such these scripts are built to take advantage of parallelism. The `--gpu-sets` command takes comma-separated sets of GPUs separated by `|`. For example, `--gpu-sets="0|1|2|3"` means that each experiment will be run individually on a GPU with ID in [0, 1, 2, 3]. If you want to use multiple GPUs per experiment, say for ResNet-50 on SplitImagenet, you can specify this by using comma-separated lists. For example, `--gpu-sets="0,1|2,3"` means that each task will be trained invidually (in parallel) either on GPUs {0, 1} or {2, 3}. Specifying a lone gpu, `--gpu-sets=0`, means that experiments will be run sequentially on GPU 0.

### Where are the results stored?

Results are automatically stored after each run in the `runs/<experiment-name>` folder, where `<experiment-name>` is the name of the script file (sans `.py` extension). The actual numbers corresponding to our plot are stored in `runs/<experiment-name>/results.csv` where each row has a self-explanatory `Name` column describing what the result is.


## GNu/NNs Experiments

The `experiments/GNu/MNISTPerm` contains the MNISTPerm experiments.

E.g. `experiments/GNu/MNISTPerm/LeNet-250-tasks` and `experiments/GNu/MNISTPerm/FC-250-tasks` correspond to Figure 4 (left) and (right) respectively and `experiments/GNu/MNISTPerm/LeNet-2500-tasks` correspond to the GNu experiments in Figure 5.

The `experiments/GNu/MNISTRotate` contains the MNISTRotate experiments in Figure 6, and the `experiments/GNu/SplitMNIST` contains the HopSupSup experiment.

The `experiments/NNs` contains the NNs experiments, which appear on Figure 5.

For example, an experiment can be run with
```bash
python experiments/GNu/MNISTPerm/LeNet-2500-tasks/supsup_h.py
```
where `args.data` should point to a directory containing the dataset and checkpoints/results will be logged at `args.log_dir`.
These can be changed in the python file. The ablations can be reproduced by e.g. changing output size.




### Amber's Notes for 1006 Replication:

#### Logging into HPC

Use the [Prince](https://sites.google.com/a/nyu.edu/nyu-hpc/systems/prince) cluster.

Once your account is active, you can log in to HPC by following [these instructions](https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/hpc-access).

When you've successfully logged into Prince, you will need to connect to your GitHub account.
This is best done via secure shell (SSH).
The [Connecting to GitHub with SSH](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh) document should help you get this set up.

After connecting your Prince account to GitHub, clone this project repository to Prince by using the `git clone ...` command.

```
ssh at2507@gw.hpc.nyu.edu
ssh at2507@prince.hpc.nyu.edu
ls -al ~/.ssh
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

rm -rf supsup
git clone git@github.com:DSGA1006-Capstone-Team/supsup.git
source env/bin/activate
pip install -r requirements.txt

sbatch supsup_slurm.s
sbatch supsup_slurm_v2.s
sbatch supsup_slurm_v3.s
squeue -u $USER
git add slurm_lab0_<JOB_ID>.out
git commit -m "adding log file"
git push origin master


pip install tensorboard

python ./experiments/GG/splitcifar100/rn18-supsup.py --gpu-sets="0" --data="./data" --seeds 1

python ./experiments/GG/splitcifar100/rn18-supsup.py  --data="./data" --seeds 1
```

#### Local Installation:
```
create conda new env
pip install -r requirements.txt
conda install pytorch==1.5.1 torchvision==0.6.1 -c pytorch
```

- tried to run jupyter notebook on prince via https://wikis.nyu.edu/display/NYUHPC/Running+Jupyter+on+Prince but it's not working


#### Helpful Prince Resources:

- https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/prince/batch/gpu-jobs
- https://sites.google.com/a/nyu.edu/nyu-hpc/systems/prince
- https://sites.google.com/a/nyu.edu/nyu-hpc/documentation/prince/batch/slurm-best-practices#TOC-Is-my-job-scalable-How-efficiently-I-use-multiple-CPUs-GPUs
- https://docs.computecanada.ca/wiki/Using_GPUs_with_Slurm

## Running jobs for Seed Masks:

The experiment and associated config files for the seed SupSup models are in `experiments/SupsupSeed/splitcifar100/configs/`. To run the driver for a 3 basis mask seed model run the following:

```
python ./experiments/SupsupSeed/splitcifar100/rn18-supsup.py --data="./data" --seeds 1 --num-masks 3 --gpu-sets="0" --logdir-prefix amber_test
```


## AT Prince Runs Log

Starting log for 11/3/2020 due to failing jobs:

- 6:50 PM ET: **Submitted batch job 13511043:** python experiments/SupsupSeed/splitcifar100/rn18-supsup.py --data="./data" --seeds 1 --num-masks 3 --gpu-sets="0"
- 6:57 PM ET: **Submitted batch job 13512046** num-masks 5
- 6:58 PM ET: **Submitted batch job 13512051** num-masks 7
- 6:59 PM ET: **Submitted batch job 13512053** num-masks 10
- 7:00 PM ET: **Submitted batch job 13512055** num-masks 12
- 7:00 PM ET: **Submitted batch job 13512057** num-masks 15


![Prince Log](/images/prince_0.png)
=======
- https://docs.computecanada.ca/wiki/Using_GPUs_with_Slurm 
