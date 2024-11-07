#!/bin/bash
PRIVATE_KEY='id_rsa'
PUBLIC_KEY='id_rsa.pub'
INSTALL_FILE='install-test.sh'
RUN_FILE='design_protein_binders.sh'
PDB_FILE='/home/yarrow/projects/proteinApps/outputs/protein-binders_0.pdb'
BINDER_INSTALL_FILE='install_dl_binder_design.sh'

scp ${PRIVATE_KEY} ${PUBLIC_KEY} protein:/root/.ssh
#scp ${INSTALL_FILE} protein:/root
#scp ${RUN_FILE} protein:/root
scp ${PDB_FILE} ${BINDER_INSTALL_FILE}  protein:/root
#scp ${YML_FILE} protein:/root


