##################################################################
### SHARPCLAW: Synteny, Homology And Repeat Pre-curation ~~~~~ ###
###            for Chromosome-Level Assembly Workflows   ~~~~~ ###
### MAIN WORKFLOW SHELL SCRIPT                           ~~~~~ ###
### LAST EDIT: 15/04/25                                  ~~~~~ ###
### AUTHORS: Richard Edwards 2024                        ~~~~~ ###
### CONTACT: rich.edwards@uwa.edu.au                     ~~~~~ ###
##################################################################

SCRIPT=sharpclaw.sh
VERSION="v0.2.0"

# This is the primary script for the SHARPCLAW pre-curation workflow

####################################### ::: HISTORY ::: ############################################
# v0.1.0 : Initial working version, developed for Ocean Genomes OG820.
# v0.2.0 : Updated main manager script to run in shell rather than slurm based on $RUNCMD.

####################################### ::: TO DO ::: ##############################################
# [Y] : Generate and test full working version.
# [Y] : Add robust checks for input files and software.
# [Y] : Consider partitioning stages into subdirectories.
# [ ] : Add email to scripts.

####################################### ::: SETUP ::: #############################################
#i# This can be run as ./sharpclaw.sh <CONFIG>
CONFIG=sharpclaw.config 
if [ ! -z "$1" ]; then
  CONFIG=$1
fi
if [ ! -f "$CONFIG" ]; then
  echo "ERROR! Config file not found: $CONFIG"
  echo "Usage: ./sharpclaw.sh <CONFIG>"
  exit 1
fi
#i# Setup variables and perform file/software checks
source $CONFIG
SRUN="singularity run \$SING"
#i# Log output
echo "[$(date)] $SCRIPT $VERSION Configured" | tee -a $LOG
echo "#---------------" | tee -a $LOG

####################################### ::: WORKFLOW  ::: ##########################################
#i# SharpClaw currently queues a single workflow that is processed sequentially.
#i# Once the core workflow is established, it will be partitioned and wrapped more effectively.
JOB=sh$NEWBASE;
#i# First setup job headers if required
if [ "$RUNCMD" = "sbatch" ]; then
  cat $SCRIPTDIR/jobhead.sh | sed "s/cpus-per-task=16/cpus-per-task=$NCPU/" | sed "s/mem=28G/mem=${MEM}G/" | \
	  sed "s/job-name=sharpclaw/job-name=$JOB/" | tee $JOB.sh
fi
if [ "$RUNCMD" = "qsub" ]; then
  echo "QSub not yet implemented."
  #cat $SCRIPTDIR/jobhead.sh | sed "s/cpus-per-task=16/cpus-per-task=$NCPU/" | sed "s/mem=28G/mem=${MEM}G/" | \
	#  sed "s/job-name=sharpclaw/job-name=$JOB/" | tee $JOB.sh
fi
if [ "$RUNCMD" = "source" ]; then
  echo "#!/bin/bash --login" | tee $JOB.sh
fi

#i# Next, run the main code - set variables with $CONFIG and then execute main script
cat $CONFIG | tee -a $JOB.sh
echo | tee -a $JOB.sh
echo "$SETUPENV" | tee -a $JOB.sh
cat $EXECDIR/sharpclaw.exec | tee -a $JOB.sh

#i# Add any job ending code, if required
if [ "$RUNCMD" = "sbatch" ]; then
  cat $SCRIPTDIR/jobtail.sh | tee -a $JOB.sh  
fi

#i# End script and execute
echo "[$(date)] Running full SHARPCLAW: $JOB.sh" | tee -a $LOG
$RUNCMD $JOB.sh

exit 0


