for i in GSE117261 
do
perl summay.pl $i.probeset.Pvalue.matrix.txt $i.probeset.normalized_expression.txt $i.probeset.normalized_expression.QC.txt > $i.QC.stat.txt
done

