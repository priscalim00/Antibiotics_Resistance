#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 16g
#SBATCH -n 2
#SBATCH -t 6:00:00
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script utilizes DAS_Tool to consolidate bins generated by multiple binning algorithms

# Input: 1) Bin association .txt files located under data/processed/binning/"$bin_tool"/"$sample"/"$sample"_"$bin_tool"_associations.txt
#        2) Assembly (scaffolds.fasta) located under data/processed/assembly/"$sample"/scaffolds.fasta

# Output: Consolidated bins will be deposited in data/processed/binning/das_tool/"$sample" 

# DAS_Tool is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script,
# uncomment the following line to create the das_tool environment in which DAS_Tool is installed.
# Current version is 1.1.7

# conda create -n das_tool -c bioconda das_tool
eval "$(conda shell.bash hook)"
conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/das_tool

sample=$1

mkdir -p data/processed/binning/das_tool
mkdir -p data/processed/binning/das_tool/"$sample"

concoct_dir=data/processed/binning/concoct
maxbin2_dir=data/processed/binning/maxbin2
metabat2_dir=data/processed/binning/metabat2
assembly_dir=data/processed/assembly
dastool_dir=data/processed/binning/das_tool

DAS_Tool -i "$concoct_dir"/"$sample"/"$sample"_concoct_associations.txt,\
"$maxbin2_dir"/"$sample"/"$sample"_maxbin2_associations.txt,\
"$metabat2_dir"/"$sample"/"$sample"_metabat2_associations.txt \
	-l concoct,maxbin2,metabat2 \
	-c "$assembly_dir"/"$sample"/scaffolds.fasta \
	-o "$dastool_dir"/"$sample" \
	-t 2 --write_bins --debug
