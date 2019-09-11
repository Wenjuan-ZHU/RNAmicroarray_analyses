#!/bin/sh
#module load singularity
#singularity exec --nv singularity-container-name.simg  bash_script.sh
#/pylon5/ib5fp9p/wenjuan/bin/image/r_microarray.simg Rscript CEL_normalization_oligo.R


source /home/ccgmtest/miniconda3/bin/activate
conda deactivate
conda activate Tf
/home/ccgmtest/miniconda3/envs/Tf/bin/Rscript affy_CEL_normalization_v2.R
conda deactivate


#perl add_anno.pl GPL3921-25447.txt.gz GSE20060_Detection_normalization_expression.txt.gz GSE20060_Detection_normalization_expression.annotxt

