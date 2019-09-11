library(GEOquery)
#library(oligo)
library(affy)
#CEL文件：对荧光信号图像处理后，提取灰度信息的文件

#getGEOSuppFiles("GSE38792")
#list.files("GSE38792")
#untar("GSE38792/GSE38792_RAW.tar", exdir = "GSE38792/CEL")
list.files("CEL")
celfiles <- list.files("CEL", full = TRUE)
#rawData <- read.celfiles(celfiles) #oligo
rawData <-ReadAffy(filenames=celfiles)
rawData
#=====================Normalization==========================================
#A classic and powerful method for preprocessing Affymetrix gene expression arrays is the RMA method. Experience tells us that RMA essentially always performs well so many people prefer this method; one can argue that it is better to use a method which always does well as opposed to a method which does extremely well on some datasets and poorly on others.
## Background correcting
## Normalizing
## Calculating Expression
normData <- rma(rawData)
normData
exp.RMA <- exprs(normData)
write.csv(exp.RMA,file="normalized_expression.txt")
pdf(file="boxplot.pdf",bg="white")
boxplot(rawData,col="red") ##画箱式图，比较数据分布情况
boxplot(data.frame(exp.RMA),col="blue")
#boxplot(normData,col="blue")
dev.off()

#Performs the Wilcoxon signed rank-based gene expression presence/absence detection algorithm first implemented in the Affymetrix Microarray Suite version 5
#So that small p-values imply presence while large ones imply absence of transcript. The detection call is computed by thresholding the p-value as in:call "P" if p-value < alpha1 call "M" if alpha1 <= p-value="" <="" alpha2="" call="" "a"="" if="">
calls <- mas5calls(rawData,tau = 0.015, alpha1 = 0.04, alpha2 = 0.06) # get PMA calls
#calls <- mas5calls(rawData,tau = 0.015, alpha1 = 0.01, alpha2 = 0.05) # get PMA calls
calls <- exprs(calls)
#absent <- rowSums(calls == 'A') # how may samples are each gene 'absent' in all samples
#absent <- which (absent == ncol(calls)) # which genes are 'absent' in all samples
#rmaFiltered <- normData[-absent,] # filters out the genes 'absent' in all samples
#rmaFiltered
calls[calls=='P']=T
calls[calls=='M']=F
calls[calls=='A']=F
mode(calls) <- "logical"
exp.RMA[!calls] <- NA
write.csv(exp.RMA,file="Detection_normalized_expression.txt")

#write.exprs(exp.rmaFiltered,file="rmaFiltered.txt") ##结果保存
##两种normlization的方法，##一般我们会选择transcript相关的
## 这个芯片平台还需要自己把探针ID赋值给表达矩阵
#featureData(genePS) <- getNetAffx(genePS, "probeset")
#featureData(geneCore) <- getNetAffx(geneCore, "transcript")

pdf(file="hist.pdf",bg="white")
#hist(log2(rawData,breaks=100,col="blue")
#par(mfrow=c(1,2),w=16,h=8)
#hist(log2(intensity(rawData[,4])),breaks=100,col="blue") 
hist(log2(exp.RMA),breaks=100,col="green") ##画RMA方法处理后数据的芯片数据直方图
dev.off()

