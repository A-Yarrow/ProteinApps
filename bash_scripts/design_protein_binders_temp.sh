#!/bin/bash

#Set varriables
INPUT_PDB='3gbn.pdb'
TARGET_PDB_PATH=$HOME/inputs/
BINDER_LENGTH="70-100"
TARGET_CROP="A12-150/0 A274-326/0 B13-153/0"
#/0 ensures a chain break so that binder is not fused to the target protein
HOTSPOTS="A40,A42,A292,B21,B52,B53,B56"
NUM_DESIGNS=10
OUTPUT_PREFIX="$HOME/outputs/${INPUT_PDB%%.*}-binders"

cd "$HOME/RFdiffusion" || exit 1 # Exit if cd fails

# Initialize Conda for bash shell
source "$HOME/anaconda/etc/profile.d/conda.sh"

# Now activate the environment
conda activate SE3nv

docker run -it --rm --gpus all \
  -v $HOME/models:$HOME/models \
  -v $HOME/inputs:$HOME/inputs \
  -v $HOME/outputs:$HOME/outputs \
  rfdiffusion \
  inference.output_prefix=${OUTPUT_PREFIX} \
  inference.model_directory_path=/root/models \
  inference.input_pdb="${TARGET_PDB_PATH}${INPUT_PDB}" \
  inference.num_designs=${NUM_DESIGNS} \
  "contigmap.contigs"="[${TARGET_CROP} ${BINDER_LENGTH}]" \
  "ppi.hotspot_res"="[${HOTSPOTS}]" \
  denoiser.noise_scale_ca=0 \
  denoiser.noise_scale_frame=0 \


#Return to home directory
cd "$HOME"
mv "${input_pdb} inputs" 
