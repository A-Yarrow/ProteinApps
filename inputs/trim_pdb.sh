#!/bin/bash

grep -e " A " -e " B " -e "CRYST" 3gbn.pdb | grep -ve "HOH" -e "GOL" -e "EDO" -e "UNL" -e "NAG" -e "CL" -e "ETX" > 3gbn_trimmed.pdb

sed -E 's/([[:alpha:]]{3}) B/\1 C/' 3gbn_trimmed.pdb | sed -E 's/([[:alpha:]]{3}) A ([23][0-9]{2})/\1 B \2/' > 3gbn_trimmed2.pdb

