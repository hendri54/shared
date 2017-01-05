#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH -t 07-00
#SBATCH --mem 16384
#SBATCH -n 1
#SBATCH --mail-type=end  
#SBATCH --mail-user=lhendri@email.unc.edu

matlab -nodesktop -nosplash -singleCompThread -r "project_kure\(\'rs5\'\)"
