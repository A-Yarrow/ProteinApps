#!/bin/bash

cd $HOME/dl_binder_design
sed -i 's/biopython$/biopython=1.79'/ $HOME/dl_binder_design/include/af2_binder_design.yml
conda env create -f $HOME/dl_binder_design/include/af2_binder_design.yml
python importtests/af2_importtest.py

