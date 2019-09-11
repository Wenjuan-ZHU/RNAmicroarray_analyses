#!/bin/sh

source activate
conda deactivate
conda activate tf
/home/wenjuan/miniconda3/envs/Tf/bin/Rscript CEL_normalization.R

conda deactivate


