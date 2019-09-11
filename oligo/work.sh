#!/bin/sh
#module load singularity
#singularity exec --nv singularity-container-name.simg  bash_script.sh
#/pylon5/ib5fp9p/wenjuan/bin/image/r_microarray.simg Rscript CEL_normalization_oligo.R


source /home/ccgmtest/miniconda3/bin/activate
conda deactivate
conda activate Oligo
/home/ccgmtest/miniconda3/envs/Oligo/bin/Rscript oligo_CEL_normalization.R
conda deactivate

