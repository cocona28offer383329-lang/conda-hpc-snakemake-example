#!/bin/bash

#SBATCH --job-name=practical_1
#SBATCH --partition=teach_cpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0:10:00
#SBATCH --mem=2G
#SBATCH --account=sscm040064
#SBATCH --output ./slurm_logs/%j.out


# Move to the directory where the SLURM job was submitted
cd "${SLURM_SUBMIT_DIR}"

echo 'Setting up environment'

# Initialise Conda so it can be used in the batch job
source ~/initConda.sh

# Activate the environment containing the required R packages
conda activate ahds_week9

# Create the directory for job logs
mkdir -p ./slurm_logs/
# Create the directory for analysis results
mkdir -p ../../results
# Create the directory for intermediate data
mkdir -p ../../data/derived/intermediate

# Move to the directory containing the R scripts
cd ../

# Identify the four most common conditions in the dataset
Rscript 0_get_conditions.R

# Start analysing each condition and producing word clouds
echo 'Starting analysis'


{       read
        while IFS=, read -r line;
        do
# Analyse reported side effects for the current condition
                Rscript 1_find_side_effects.R "${line}"
# Generate word clouds for the current condition
                Rscript 2_plot_wordcloud.R "${line}"
        done

}< ../data/derived/top_conditions.csv

# Indicate that the analysis script has reached its end
echo 'Analysis complete'
