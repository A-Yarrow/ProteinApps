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

##################################################################
#!/bin/bash
#INSTALL PROTEINMPNN-FASTRELAX ENVIRONMENT

INPUT_YML="$HOME/dl_binder_design/include/proteinmpnn_fastrelax.yml"
#Add the rosetta conda channel 

#Clone the binder design git rep
git clone https://github.com/nrbennet/dl_binder_design.git


#Check if the dl_binder_design directory exists
if [ -d $HOME/dl_binder_design ]; then
    echo "dl_binder_design directory exists"
    cd $HOME/dl_binder_design

else
    echo "The dl_binder_design repository was not properly cloned. Exiting the script"
    exit 1
fi

#Add rosetta conda channel
echo "channels: 
- https://conda.rosettacommons.org
- defaults" > $HOME/.condarc


#Pytorch 2.0 is not compatable with Python 3.11. Fix the proteinmpnn_fastrelax.yml
sed -i '9c\
  - numpy=1.26.4\
  - pytorch=2.1.0\
  - pytorch-cuda=11.8\
  - torchvision=0.16.0\
  - torchaudio=2.1.0' "$INPUT_YML"


# Initialize Conda for bash shell
source $HOME/anaconda/etc/profile.d/conda.sh

#Create proteinmpnn_binder_design environment
conda env create -f $HOME/dl_binder_design/include/proteinmpnn_fastrelax.yml

#Activate proteinmpnn_binder_design environment
conda activate proteinmpnn_binder_design

#Run FastRelax Test
python $HOME/dl_binder_design/include/importtests/proteinmpnn_importtest.py

#Install ProteinMPNN git repo
cd $HOME/dl_binder_design/mpnn_fr
git clone https://github.com/dauparas/ProteinMPNN.git

#Check if the dl_binder_design directory exists
if [ -d $HOME/dl_binder_design/mpnn_fr/ProteinMPNN ]; then
    echo "ProteinMPNN  directory exists"

else
    echo "The ProteinMPNN repo  was not properly cloned. Exiting the script"
    exit 1
fi

Append path to Silent Tools. 
export PATH="$PATH:/root/dl_binder_design/include/silent_tools"
#export PYTHONPATH="$PYTHONPATH:$HOME/dl_binder_design/include/silent_tools"
Add export at end of .bashrc file
sed -i '$ a #Append path for Silent Tools'
sed -i '$ a export PATH="$PATH:/root/dl_binder_design/include/silent_tools"' $HOME/.bashrc
sed -i '$ a export PATH="$PATH:/root/dl_binder_design/mpnn_fr"' $HOME/.bashrc
sed -i '$ a export PATH="$PATH:/root/dl_binder_design/af2_initial_guess"' $HOME/.bashrc
source $HOME/.bashrc


#INSTALL ALPHAFOLD2

cd $HOME/dl_binder_design

#Edit YAML file to install biopython=1.81 https://github.com/nrbennet/dl_binder_design/issues/72
sed -i 's/biopython$/biopython=1.81'/ $HOME/dl_binder_design/include/af2_binder_design.yml

#Create the AF2 conda environment
conda env create -f $HOME/dl_binder_design/include/af2_binder_design.yml

#Activate the AF2 conda environment
conda activate af2_binder_design

#Run install tests
python $HOME/dl_binder_design/include/importtests/af2_importtest.py

#Install AlphaFold2 Model Weights from DeepMind repo
cd $HOME/dl_binder_design/af2_initial_guess
mkdir -p model_weights/params && cd model_weights/params
wget https://storage.googleapis.com/alphafold/alphafold_params_2022-12-06.tar
tar --extract --verbose --file=alphafold_params_2022-12-06.tar

if [ -f $HOME/dl_binder_design/af2_initial_guess/model_weights/params/params_model_5_multimer_v3.npz ]; then
    echo "alphafold_params_2022-12-06 has been installed"

else 
    echo "The alphafold parameter file was not set up correctly. Exiting the script"
    exit 1

fi

#Allow tensorflow to work more efficiently by using AutoGraph to convert python functions to Tensor Graphs
pip install flax
#Install Snakemake
pip install snakemake
#Test Silent Tools
#silentfrompdbs pdb_test/*.pdb > test.silent
