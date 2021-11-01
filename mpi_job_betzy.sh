#!/bin/bash

#SBATCH --account=nn4700k
#SBATCH --job-name=PR3-mol51

#SBATCH --time=80:00:00
##SBATCH --mem-per-cpu=1G
#SBATCH --exclusive

#SBATCH --nodes=4  # for normal job, use 8~256 nodes
#SBATCH --ntasks-per-node=128 # max.128 cores each note

namdconfig=prod  # pass the configuration file in the command line

## Recommended safety settings:
set -o errexit # Make bash exit on any error
set -o nounset # Treat unset variables as errors

## Software modules
module --quiet purge
module load foss/2020a
module list   # List loaded modules, for easier debugging


# use the NAMD built in our own project folder
namdbin=/cluster/projects/nn4700k/NAMD_Git-2020-05-08_Source/Linux-x86_64-g++/namd2

mpirun -bind-to core $namdbin ${namdconfig}.conf > ${namdconfig}.out
