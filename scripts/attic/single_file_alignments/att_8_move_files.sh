#!/bin/bash
#SBATCH -A >>insert_account_name<<
#SBATCH -J move_files
#SBATCH -p parallel
#SBATCH -N 1
#SBATCH --tasks-per-node 20
#SBATCH -c 2
#SBATCH -C broadwell
#SBATCH -t 00:20:00
#SBATCH -v
#SBATCH -o output_move_files.%j.out
#SBATCH -e error_move_files.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=>>insert_email<<

# Load modules:
# none

# Manual/ Reference:
# none

# Description:
# Move *_filtered.fastq.gz and *.sam.gz files to different dir in case sam file is present

# Run task:
for i in ~/projects/acc_name/path/data/fastq_files/filtered/single/*
do
  prefix="$(echo $i | cut -d '_' -f 1-6 | cut -d '.' -f 1)"
  if test -f $prefix.sam.gz
  then
    mv "$prefix".sam.gz "$prefix"_filtered.fastq.gz ~/projects/acc_name/path/data/sam_files/to_be_moved_back/single/
  fi
done

for j in ~/projects/acc_name/path/data/fastq_files/filtered/paired/*
do
  prefix2="$(echo $j | cut -d '_' -f 1-6 | cut -d '.' -f 1)"
  if test -f "$prefix2"_filtered.sam.gz
  then
    mv "$prefix2"_filtered.sam.gz "$prefix2"_filtered_1.fastq.gz "$prefix2"_filtered_2.fastq.gz ~/projects/acc_name/path/data/sam_files/to_be_moved_back/paired/
  fi
done

