#!/bin/bash
# Here, we're making some unconditional designs
# We specify the path for the outputs
# We tell RFdiffusion that designs should be 100-200 residues in length (randomly sampled each design)
# We generate 10 such designs

cd $HOME/RFdiffusion
HYDRA_FULL_ERROR=1
docker run -it --rm --gpus all \
  -v $HOME/models:$HOME/models \
  -v $HOME/inputs:$HOME/inputs \
  -v $HOME/outputs:$HOME/outputs \
  -v /root/RFdiffusion/examples/input_pdbs:/root/RFdiffusion/examples/input_pdbs \
  rfdiffusion \
  inference.output_prefix=$HOME/outputs/unconditional \
  inference.model_directory_path=$HOME/models \
  inference.input_pdb=/root/RFdiffusion/examples/input_pdbs/1qys.pdb \
  inference.num_designs=10 \
  'contigmap.contigs=[150-150]'
