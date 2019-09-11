#rm(list=ls())
library(GEOquery)
library(lumi)

args=commandArgs(T)
verbose=TRUE
fileName=args[1]

## background correction/RMA normalization
#lumiObj <- lumiB(eset, method='bgAdjust',verbose=TRUE)
#x.lumi <- lumiR.batch(fileName) 

#x.lumi <- lumiR.batch("GSE39340_non_normalized.txt") 
x.lumi <- lumiR.batch(fileName)
pData(phenoData(x.lumi))
## Do all the default preprocessing in one step
lumi.N.Q     <- lumiExpresso(x.lumi) #,normalize.param = list(method='rsn'))
### retrieve normalized data
dataMatrix   <- exprs(lumi.N.Q)
expr0        <- exprs(lumi.N.Q)
featureData0 <- fData(lumi.N.Q)
detect.count <- detectionCall(lumi.N.Q,Th=0.01,type="probe")
detect.rate  <- detect.count/ncol(expr0)
hist(detect.rate)
detectP<- detectionCall(lumi.N.Q,Th=0.01,type="matrix")
#print(detectP)
detectP[detectP=="P"]=T
detectP[detectP=="A"]=F
mode(detectP) <- "logical"
expr0[!detectP] <- NA
expr0[detect.rate>=0.001,]->expr
featureData <- featureData0[detect.rate >= 0.001,]
write.csv(dataMatrix,"normalized_expression.txt")
write.csv(expr,"Detection_normalized_expression.txt")



#boxplot (dataMatrix, ylab = expression (log [2]( intensity )) ,las = 2, outline = FALSE )

#lumiExpresso(lumi.Ds, bg.correct = TRUE, bgcorrect.param = list(method='bgAdjust'), variance.stabilize = TRUE,varianceStabilize.param = list(), normalize = TRUE, normalize.param = list(method='ssn'), QC.evaluation = TRUE,QC.param = list(), verbose = TRUE)->lumi.N.Q
#please refer to the pdf documentation attached in the answer for the details of the function options mentioned above.
#4. detection p filtration and detection rate filtration& imputation
#expr0 <- exprs(lumi.N.Q)
#featureData0 <- fData(lumi.N.Q)
#detect.count <- detectionCall(lumi.N.Q,Th=detection.p,type="probe")
#detect.rate <- detect.count/ncol(expr0)
#detectP<- detectionCall(lumi.N.Q,Th=detection.p,type="matrix")
#detectP[detectP=="P"]=T
#detectP[detectP=="A"]=F
#mode(detectP) <- "logical"
#expr0[!detectP] <- NA
##we plna to use impute.knn to impute NA values, leave those probes detection p rate >= detectionRate
#expr0[detect.rate>=0.01,]->expr
#featureData <- featureData0[detect.rate >= 0.01,]
#if(!require(impute))
#    stop("error loading impute package\n")
#expr.impt <- impute.knn(expr)$data
#now we have done the preprocessing step. for differential expression analysis, I use rankProd, you can also use limma. 
#write.csv(expr.impt,"normalized_expression_impt.txt")

