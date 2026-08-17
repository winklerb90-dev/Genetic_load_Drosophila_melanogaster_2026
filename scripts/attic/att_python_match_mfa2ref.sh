#!/bin/bash
#========[ + + + + Requirements + + + + ]========#
# does not need to be change --------------------#
#SBATCH --partition=ki-parallel
#SBATCH --account=>>insert_account_name<<
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<
#SBATCH -v
# -----------------------------------------------#

# with N = 1 these values should multiply to 40 -#
#SBATCH -N 1
#SBATCH --tasks-per-node 20
#SBATCH -c 2
# -----------------------------------------------#

# adjust below for each script ------------------#
#SBATCH -J python_match_mfa2ref
#SBATCH -t 01:00:00
#SBATCH -o output_python_match_mfa2ref.%j.out
#SBATCH -e error_python_match_mfa2ref.%j.err
# -----------------------------------------------#
#================================================#

#=========[ + + + + Reference + + + + ]==========#
# none
#================================================#

#=========[ + + + + Description + + + + ]========#
# Python script to match the reference D. melanogaster
# sequence with a fasta (from maf) sequence per chrom.
# Upper/lower check and match per nucleotide case (or N).
#================================================#

#=========[ + + + + Job Steps + + + + ]==========#
module load lang/Python/3.12.3-GCCcore-13.3.0

cd /lustre/project/ki-drosmelsel/internship_drosmel_selection/data

grep -v '^>' reference_fasta/ref_dm6_chr4.fa \
| tr -d '\n' \
| tr '[:lower:]' '[:upper:]' \
> ref_chr_4.txt

sed -n '2p' new_fasta_files/chr4_ref_clean.fasta \
| tr '[:lower:]' '[:upper:]' \
> mfa_chr_4.txt

python <<'EOF'
with open("ref_chr_4.txt") as f:
    ref_seq = f.readline().strip()

with open("mfa_chr_4.txt") as f:
    mfa_seq = f.readline().strip()

ref_list = list(ref_seq)

mfa_list = list(mfa_seq)

mfa_iterator = 0

ref_iterator = 0

for i in mfa_list:
    if i == "A" or i == "T" or i == "C" or i == "G":
        mfa_iterator += 1
        ref_iterator += 1
    elif i == "-":
        mfa_iterator += 1
    elif i == "N":
        mfa_list[mfa_iterator] = ref_list[ref_iterator]
        mfa_iterator += 1
        ref_iterator += 1

sequence = "".join(mfa_list)

with open("replacement_sequence_chr4.txt", "w") as out:
    out.write(sequence + "\n")
EOF

rm ref_chr_4.txt mfa_chr_4.txt

mv replacement_sequence_chr4.txt new_fasta_files/
