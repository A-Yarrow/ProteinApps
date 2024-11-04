#!/bin/bash
PRIVATE_KEY='id_rsa'
PUBLIC_KEY='id_rsa.pub'
INSTALL_FILE='install-test.sh'
RUN_FILE='design_protein_binders2.sh'
PDB_FILE='/home/yarrow/projects/proteinApps/inputs/3gbn.pdb'

scp ${PRIVATE_KEY} ${PUBLIC_KEY} protein:/root/.ssh
scp ${INSTALL_FILE} protein:/root
scp ${RUN_FILE} protein:/root
scp ${PDB_FILE} protein:/root


