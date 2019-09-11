#!/bin/sh
#module load singularity
#singularity exec --nv singularity-container-name.simg  bash_script.sh
#/pylon5/ib5fp9p/wenjuan/bin/image/r_microarray.simg Rscript CEL_normalization_oligo.R

#https://www.ncbi.nlm.nih.gov/pubmed/?term=GSE16997
#Microarray data analysis: cell subpopulations
#Microarray profiling was undertaken for four cell subpopulations (identified as MaSCenriched, Lum Prog, Mat Lum and Stroma) from three patients. Data analysis used the lumi and limma packages of the Bioconductor open-source software project (http://www.bioconductor.org). Raw intensities were normexp background corrected with offset 161 , quantile normalized2 then log2-transformed. Probes were filtered if not detected in any sample (detection P-value 0.01). A linear model was fitted to the expression data including random effects for the three patients3. Pairwise comparisons were made between the three cell populations other than Stroma using empirical Bayes moderated t-statistics4 . The false discovery rate (FDR) was controlled globally using the Benjamini and Hochberg algorithm.Probes with FDR < 0.05 and fold-change > 2 were judged to be differentially expressed. 

#https://academic.oup.com/carcin/article/34/12/2767/2464136
#Primary data were collected using BeadStudio v3 software package. After quality control, microarray data were log 2 transformed and normalized using the robust spline normalization method, implemented in the lumi package ( 15 ) of the open source software Bioconductor ( 16 ).
#When multiple probes represented the same transcript, we included only the one with the highest detection rate, defined as the percentage of samples in which the probe had a detection P <0.01 (this P value represents the confidence that a given transcript is expressed above the background level defined by negative control probes). Probes that were not annotated were also eliminated from analysis. Finally, in the case of the discovery set, we filtered the remaining probes and kept only those with a detection P <0.01 in at least 90% of samples. In the validation set, we kept all probes for which a detection P <0.01 was obtained for at least one sample; these less stringent criteria reduced the possibility that genes identified in the discovery series be absent from the validation set. Log 2 -transformed and normalized values of the resulting transcripts were then used in Cox proportional hazards modeling

#perl modify_sample.pl GSE102249_non-normalized.txt 

source /home/wenjuan/miniconda3/bin/activate
conda deactivate
conda activate Tf
for i in GSE83453  #GSE102249 GSE83453
do 
    perl modify_sample.pl $i""_non-normalized.txt aa 
    /home/wenjuan/miniconda3/envs/Tf/bin/Rscript limma_normalization.R aa
    mv normalized_expression.txt aa
    perl add_anno.pl GPL10558-50081.txt aa $i""_normalized_expression.txt
done 
rm aa 
conda deactivate

