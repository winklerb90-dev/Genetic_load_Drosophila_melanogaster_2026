#!/bin/bash
#========[ + + + + Requirements + + + + ]========#
# does not need to be change --------------------#
#SBATCH --partition=ki-smallcpu
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
#SBATCH -J gerpcol_4
#SBATCH -t 01:00:00
#SBATCH -o output_gerpcol_4.%j.out
#SBATCH -e error_gerpcol_4.%j.err
# -----------------------------------------------#
#================================================#

#=========[ + + + + Reference + + + + ]==========#
# https://genome.ucsc.edu/cgi-bin/hgTrackUi?db=hg19&g=allHg19RS_BW
# formerly on: http://mendel.stanford.edu/SidowLab/downloads/gerp/
# manual can be found at: https://web.archive.org/web/20240520010334/http://mendel.stanford.edu/sidowlab/downloads/GERP/index.html
# gerpcol -h
# For the version of tvkent:
# download the gerp tar.gz file from:
# https://github.com/tvkent/GERPplusplus
# compile it and use that instead (but ran much slower for me)
#================================================#

#=========[ + + + + Description + + + + ]========#
# Calculate Genomic Evolutionary Rate Profiling,
# i.a., gerp scores which show difference between
# observed substitutions and subtitutions expected
# under neutral selection.
# Theory: less substitutions = higher conservation/ constraint
#================================================#

#=========[ + + + + Job Steps + + + + ]==========#
module load lang/Anaconda3/2024.06-1
source activate base
conda activate >>insert_conda_env_name< # make sure packages are compiled before

cd /lustre/project/account_name/data/gerp_rates

# change the file names for each chromosome, e.g., this is for chromosome 4:
gerpcol -a \
        -f ../new_fasta_files/chr4_ref_clean.fasta \
        -t ../newick_format/ucsc_multiz124/one_line_seq.txt \
        -e dm6 \
        -v

# ./gerpcol -a \ # in the case of using the TVKENT github version and place that file inside the dir
