##################################################################
### SHARPCLAW: Synteny, Homology And Repeat Pre-curation ~~~~~ ###
###            for Chromosome-Level Assembly Workflows   ~~~~~ ###
### MAIN WORKFLOW SHELL SCRIPT                           ~~~~~ ###
### LAST EDIT: 17/09/24                                  ~~~~~ ###
### AUTHORS: Richard Edwards 2024                        ~~~~~ ###
### CONTACT: rich.edwards@uwa.edu.au                     ~~~~~ ###
##################################################################

SCRIPT=sharpclaw.sh
VERSION="v0.1.0"

# This is the primary script for the SHARPCLAW pre-curation workflow

####################################### ::: HISTORY ::: ############################################
# v0.1.0 : Initial working version, developed for Ocean Genomes OG820.

####################################### ::: TO DO ::: ##############################################
# [ ] : Generate and test full working version.
# [ ] : Add robust checks for input files and software.
# [ ] : Consider partitioning stages into subdirectories.
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
cat $SCRIPTDIR/jobhead.sh | sed "s/cpus-per-task=16/cpus-per-task=$NCPU/" | sed "s/mem=28G/mem=${MEM}G/" | \
	sed "s/job-name=sharpclaw/job-name=$JOB/" | tee $JOB.sh

cat $CONFIG | tee -a $JOB.sh
echo | tee -a $JOB.sh
echo "$SETUPENV" | tee -a $JOB.sh
cat $EXECDIR/sharpclaw.exec | tee -a $JOB.sh
cat $SCRIPTDIR/jobtail.sh | tee -a $JOB.sh  

echo "[$(date)] Running full SHARPCLAW: $JOB.sh" | tee -a $LOG
$RUNCMD $JOB.sh

exit 0


