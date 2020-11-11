from copy import deepcopy
from multiprocessing import Process, Queue
from itertools import product
import sys, os
import numpy as np
import time
import argparse

sys.path.append(os.path.abspath("."))

# note: new algorithm code
def kwargs_to_cmd(kwargs):
    cmd = "/scratch/db4045/capstone_env/bin/python main.py "
    for flag, val in kwargs.items():
        cmd += f"--{flag}={val} "

    return cmd


def run_exp(gpu_num, in_queue):
    while not in_queue.empty():
        try:
            experiment = in_queue.get(timeout=3)
        except:
            return

        before = time.time()

        print(f"==> Starting experiment {kwargs_to_cmd(experiment)}")
        os.system(kwargs_to_cmd(experiment))

        with open("output.txt", "a+") as f:
            f.write(
                f"Finished experiment {experiment} in {str((time.time() - before) / 60.0)}."
            )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--seeds', default=1, type=int)
    parser.add_argument('--data', default='/scratch/db404/data', type=str)
    parser.add_argument('--num-masks', default=20, type=int)
    parser.add_argument('--epochs', default=250, type=int)
    parser.add_argument('--logdir-prefix', type=str, required=True)
    args = parser.parse_args()

    seeds = list(range(args.seeds))
    data = args.data

    config = "experiments/SupsupSeed/splitcifar100/configs/rn18-supsup{}.yaml".format("" if args.num_masks == 20 else "_{}".format(str(args.num_masks)))
    log_dir = "/scratch/{user}/runs/{logdir_prefix}/SupsupSeed/rn18-supsup_num_masks_{num_masks}".format(user=os.environ.get("USER"), num_masks=str(args.num_masks), logdir_prefix=args.logdir_prefix)
    experiments = []
    sparsities = [1, 2, 4, 8, 16, 32] # Higher sparsity values mean more dense subnetworks

    # at change for 1 epoch to check dir
    for sparsity, seed in product(sparsities, seeds):
        kwargs = {
            "config": config,
            "name": f"id=supsup~seed={seed}~sparsity={sparsity}",
            "sparsity": sparsity,
            "seed": seed,
            "log-dir": log_dir,
            "epochs": int(args.epochs),
            "data": data
        }

        experiments.append(kwargs)

    print(experiments)
    queue = Queue()

    for e in experiments:
        queue.put(e)

    processes = []
    p = Process(target=run_exp, args=(0, queue))
    p.start()
    processes.append(p)

    for p in processes:
        p.join()


if __name__ == "__main__":
    main()
