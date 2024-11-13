#!/bin/bash

#Set varriables
INPUT_PDB="3gbn.pdb"
TARGET_PDB_PATH="$HOME/test/"
BINDER_LENGTH="70-100"
TARGET_CROP="A12-150/0 A274-326/0 B13-153/0"
#/0 ensures a chain break so that binder is not fused to the target protein
HOTSPOTS="A40,A42,A292,B21,B52,B53,B56"
NUM_DESIGNS=2
TIMESTEPS=50
OUTPUT_PDB_PATH="$HOME/test/binders/"
OUTPUT_PREFIX="$OUTPUT_PDB_PATH${INPUT_PDB%%.*}-binders"

cd "$HOME/RFdiffusion" || exit 1 # Exit if cd fails

# Initialize Conda for bash shell
source "$HOME/anaconda/etc/profile.d/conda.sh"

# Now activate the environment
conda activate SE3nv

docker run -it --rm --gpus all \
  -v $HOME/models:$HOME/models \
  -v $TARGET_PDB_PATH:$TARGET_PDB_PATH \
  -v $OUTPUT_PDB_PATH:$OUTPUT_PDB_PATH \
  -v $OUTPUT_PREFIX:$OUTPUT_PREFIX \
  rfdiffusion \
  inference.output_prefix=${OUTPUT_PREFIX} \
  inference.model_directory_path=/root/models \
  inference.input_pdb="${TARGET_PDB_PATH}${INPUT_PDB}" \
  inference.num_designs=${NUM_DESIGNS} \
  "contigmap.contigs"="[${TARGET_CROP} ${BINDER_LENGTH}]" \
  "ppi.hotspot_res"="[${HOTSPOTS}]" \
  denoiser.noise_scale_ca=0 \
  denoiser.noise_scale_frame=0 \
  +defuser.T=${TIMESTEPS} \

#Return to home directory
cd "$HOME"
#mv "${input_pdb} inputs" 
