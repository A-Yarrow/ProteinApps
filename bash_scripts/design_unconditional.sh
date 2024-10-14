#!/bin/bash

AMINO_ACID_RANGE='[350-350]'
NUM_DESIGNS=10
OUTPUT_PREFIX=$HOME/outputs/unconditional

cd $HOME/RFdiffusion

# Initialize Conda for bash shell
source $HOME/anaconda/etc/profile.d/conda.sh

# Now activate the environment
conda activate SE3nv

docker run -it --rm --gpus all \
  -v $HOME/models:$HOME/models \
  -v $HOME/inputs:$HOME/inputs \
  -v /root/RFdiffusion/examples/input_pdbs:/root/RFdiffusion/examples/input_pdbs \
  rfdiffusion \
  inference.output_prefix=${OUTPUT_PREFIX} \
  inference.model_directory_path=$HOME/models \
  inference.input_pdb=/root/RFdiffusion/examples/input_pdbs/1qys.pdb \
  inference.num_designs=${NUM_DESIGNS} \
  'contigmap.contigs='${AMINO_ACID_RANGE}

cd $HOME
