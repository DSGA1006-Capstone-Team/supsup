import sys, os
sys.path.append(os.path.abspath('.'))
from main import main as run
from args import args

def main():
    args.set = 'RandSplitCIFAR100'

    args.seed = 1996
    args.multigpu = [0]
    args.model = 'GEMResNet18'
    args.conv_type = 'MultitaskMaskConv'
    args.bn_type = 'NonAffineNoStatsBN'
    args.conv_init = 'signed_constant'
    args.epochs = 5
    args.output_size = 5
    args.er_sparsity = True
    args.sparsity = 32

    args.adaptor = "gt"
    args.hard_alphas = True

    args.batch_size = 128
    args.test_batch_size = 128
    args.num_tasks = 3

    args.save = True
    args.optimizer = 'adam'
    args.lr = 0.001
    args.eval_ckpts = []

    args.name = f"id=rn18"

    # TODO: Change these paths!
    #args.data = '/home/mitchnw/data'
    #args.log_dir = "/home/mitchnw/ssd/checkpoints/supsup_test"
    args.data = '/scratch/db4045/data/'
    args.log_dir = "/scratch/db4045/scratch/test_bn_orig"

    run()

if __name__ == '__main__':
    main()
