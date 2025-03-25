#!/bin/bash --login
#Requested resources:
#SBATCH --account=pawsey0812
#SBATCH --job-name=sharpclaw
#SBATCH --partition=work
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=28G
#SBATCH --export=ALL
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH --mail-type=END
#SBATCH --mail-user=<EMAIL>

####################################### ::: SCRIPT ::: ############################################
date=$(date +%y%m%d)
echo "========================================="
echo "SLURM_JOB_ID = $SLURM_JOB_ID"
echo "SLURM_NODELIST = $SLURM_NODELIST"
echo "SLURM_CPUS_PER_TASK = $SLURM_CPUS_PER_TASK"
echo "DATE: $date"
echo "========================================="
#---------------
THREADS=0
if [ "$THREADS" == "0" ]; then
  THREADS=$SLURM_CPUS_PER_TASK
fi
echo "THREADS: $THREADS"
#---------------
LOG=$(pwd)/${SLURM_JOB_NAME/sh/}.log
echo "#---------------" | tee -a $LOG
echo "[$(date)] $SLURM_JOB_NAME Started" | tee -a $LOG
echo "#---------------" | tee -a $LOG
#---------------
# Run code

