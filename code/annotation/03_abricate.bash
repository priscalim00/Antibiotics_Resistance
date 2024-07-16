#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH --cpus-per-task 4
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script uses Abricate default settings to annotate AMR genes within draft genomes obtained from dRep.
# Abricate is only able to identify acquired resistance genes and not point mutations

# Input: Dereplicated bins located in data/draft_genomes/"$pid"/dereplicated/dereplicated_genomes
# Output:

# Abricate is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script, 
# uncomment the following line to create the abricate environment in which Abricate is installed
# conda create -n abricate -c conda-forge -c bioconda -c defaults abricate

# Current version is  1.0.1

module load anaconda/2021.11
conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/abricate

pid=$1

genome_dir=data/draft_genomes/"$pid"/dereplicated/dereplicated_genomes
abricate_dir=data/draft_genomes/"$pid"/abricate

mkdir -p "$abricate_dir"

abricate "$genome_dir"/*.fa > "$abricate_dir"/"$pid"_abricate.txt 
abricate --summary "$abricate_dir"/"$pid"_abricate.txt > "$abricate_dir"/"$pid"_abricate_summary.txt
