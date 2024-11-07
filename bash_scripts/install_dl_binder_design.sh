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

