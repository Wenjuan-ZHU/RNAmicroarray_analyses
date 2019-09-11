#rm(list=ls())
#library(lumi)
library(limma)
#x <- read.ilmn("x <- read.ilmn(
args=commandArgs(T)
verbose=TRUE
fileName=args[1]

x <- read.ilmn(fileName,probeid="ID_REF",expr="Sample",other.columns="Detection Pval")
#x <- read.ilmn(fileName,probeid="ID_REF",expr="intensity",other.columns="Detection Pval")
#read.ilmn(files="GSE16997_raw.txt",expr="Sample",probeid="ID_REF",other.columns="Detection Pval")
dim(x)

expressed <- rowSums(x$other$Detection < 0.01) >= 3  
norm.data <- x[expressed,]
dim(norm.data)

y <- neqc(x,detection.p="Detection Pval") ##背景矫正并且分位数标准化
expdata <- y$E
#neqc
#Normexp uses the same normal-exponential convolution model as the robust multiarray analysis (RMA) background correction, and we refer to this as the RMA model in our article.
write.csv(expdata,"normalized_expression.txt")
boxplot (expdata, ylab = expression (log [2]( intensity )) ,las = 2, outline = FALSE )


