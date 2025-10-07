#!/bin/bash

#SBATCH --account=nn8012k
#SBATCH --job-name=H22-H54

#SBATCH --time=90:00:00
##SBATCH --mem-per-cpu=1G
#SBATCH --exclusive

#SBATCH --nodes=4  # for normal job, use 8~256 nodes
#SBATCH --ntasks-per-node=128 # max.128 cores each note

run1=/cluster/projects/nn4700k/Parveen/simulations/hne-mol22/with_crystal/namd
run2=/cluster/projects/nn4700k/Parveen/simulations/hne-mol54/with_crystal/namd
namdconfig=prod  # pass the configuration file in the command line

## Recommended safety settings:
set -o errexit # Make bash exit on any error
set -o nounset # Treat unset variables as errors

## Software modules
module --quiet purge
module load foss/2020a
module list   # List loaded modules, for easier debugging

scontrol show hostname $SLURM_JOB_NODELIST | perl -ne 'chomb; print "$_"x1'> myhosts
sed -n '1,2p' myhosts > hosts1
sed -n '3,4p' myhosts > hosts2
#exit

# use the NAMD built in our own project folder
namdbin=/cluster/projects/nn4700k/NAMD_Git-2020-05-08_Source/Linux-x86_64-g++/namd2

##mpirun -bind-to core $namdbin ${namdconfig}.conf > ${namdconfig}.out

### launch 2 program runs
mpirun -np 256 -hostfile hosts1 --map-by node $namdbin $run1/${namdconfig}.conf > $run1/${namdconfig}.out &
pid1=$!
mpirun -np 256 -hostfile hosts2 --map-by node $namdbin $run2/${namdconfig}.conf > $run2/${namdconfig}.out &
pid2=$!

### wait for the termination of both programs runs
wait $pid1 $pid2

mv slurm* output/
mv myhosts output/
mv hosts* output/
