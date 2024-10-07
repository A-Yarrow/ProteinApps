#!/bin/bash
PRIVATE_KEY='id_rsa'
PUBLIC_KEY='id_rsa.pub'
INSTALL_FILE='test.sh'

scp ${PRIVATE_KEY} ${PUBLIC_KEY} protein:/root/.ssh
scp ${INSTALL_FILE} protein:/root


