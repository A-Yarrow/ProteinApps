pdb="3gbn_trimmed2.pdb"
def renumber_pdb(pdb):
    n = 1
    with open(pdb, 'r') as file:
        for line in file:
            parts = line.split()
            if "ATOM" in parts:
                parts[1] = str(n)
                n += 1
                print(" ".join(parts))

renumber_pdb(pdb)


