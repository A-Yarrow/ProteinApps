#!/bin/bash
set -x

#Clone the RFdiffusion git repository
git clone git@github.com:RosettaCommons/RFdiffusion.git $HOME/RFdiffusion

#Check if the RFdiffusion directory exists
if [ -d $HOME/RFdiffusion ]; then
    echo "RFdiffusion directory exists"
    cd RFdiffusion

else
    echo "The RFdiffusion repository was not properly cloned. Exiting the script"
    exit 1
fi

# Initialize Conda for bash shell
source $HOME/anaconda/etc/profile.d/conda.sh

# Create conda environment
conda env create -f $HOME/RFdiffusion/env/SE3nv.yml

# Now activate the environment
conda activate SE3nv

echo "Environment activated: $CONDA_DEFAULT_ENV"

#Fix a bug in the docker file. Does not work with numpy < 2
#https://github.com/RosettaCommons/RFdiffusion/pull/249/commits/30ae39e38e8196564e54674bffc688640ed4e75e
sed -i '43i \  numpy==1.26.4 \\' $HOME/RFdiffusion/docker/Dockerfile

#Docker Build
#Make sure you are in $HOME/RFdiffusion when you run the docker build command
cd $HOME/RFdiffusion
docker build -f $HOME/RFdiffusion/docker/Dockerfile -t rfdiffusion .

mkdir $HOME/inputs $HOME/outputs $HOME/models
bash $HOME/RFdiffusion/scripts/download_models.sh $HOME/models
wget -P $HOME/inputs https://files.rcsb.org/view/5TPN.pdb

#Wait for models to download and test docker container

docker run -it --rm --gpus all \
  -v $HOME/models:$HOME/models \
  -v $HOME/inputs:$HOME/inputs \
  -v $HOME/outputs:$HOME/outputs \
  rfdiffusion \
  inference.output_prefix=$HOME/outputs/motifscaffolding \
  inference.model_directory_path=$HOME/models \
  inference.input_pdb=$HOME/inputs/5TPN.pdb \
  inference.num_designs=3 \
  'contigmap.contigs=[10-40/A163-181/10-40]'

cd $HOME
echo "You Should see new models in $HOME/outputs/motifscaffolding"

#Install ProteinMPNN
#https://github.com/dauparas/ProteinMPNN
#ProteinMPNN Paper: https://www.biorxiv.org/content/10.1101/2022.06.03.494563v1

#Clone the ProteinMPNN git repo
git clone git@github.com:dauparas/ProteinMPNN.git

#Set Environment Variables for ProteinMPNN
export pmpnn="${HOME}/ProteinMPNN/"
export PATH="${HOME}/ProteinMPNN/:$PATH"

#Create a python environment for ProteinMPNN
conda create -n mlfold python=3.9
conda activate mlfold
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia

#Run test and exit if MPNN returns non zero
chmod 775 /root/ProteinMPNN/examples/*.sh
./root/ProteinMPNN/examples/submit_example_1.sh || { echo "MPNN encountered some errors, exiting"; exit 1; }
