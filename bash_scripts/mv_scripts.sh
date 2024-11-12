#!/bin/bash
PRIVATE_KEY='id_rsa'
PUBLIC_KEY='id_rsa.pub'
INSTALL_FILE='install-test.sh'
RUN_FILE='design_protein_binders.sh'
PDB_TEST='test'
INSTALL_FILE='full_install.sh'

scp ${PRIVATE_KEY} ${PUBLIC_KEY} protein:/root/.ssh
#scp ${INSTALL_FILE} protein:/root
#scp ${RUN_FILE} protein:/root
scp -r ${PDB_TEST} ${INSTALL_FILE}  protein:/root
#scp ${YML_FILE} protein:/root


