for i in GSE130391 #GSE20060 GSE30169 
do
    mv $i""_Detection_normalized_expression.txt $i""_Detection_normalization_expression.txt
    perl add_anno.pl GPL3921-25447.txt.gz $i""_Detection_normalization_expression.txt $i""_Detection_normalization_expression.anno.txt
#perl add_anno.pl GPL3921-25447.txt.gz GSE30169_Detection_normalization_expression.txt.gz GSE30169_Detection_normalization_expression.anno.txt
#====1
#less GSE30169_Detection_normalization_expression.anno.txt|head -1 >aa.txt
#less GSE30169_Detection_normalization_expression.anno.txt|grep PCDH >>aa.txt
perl stat.pl $i""_Detection_normalization_expression.anno.txt $i"".stat.txt
less $i"".stat.txt|grep PCDH|sort -k 4 -n -r|cat
done 
#====2
#less GSE20060_Detection_normalization_expression.anno.txt|head -1 >bb.txt
#less GSE20060_Detection_normalization_expression.anno.txt|grep PCDH >>bb.txt 
#perl stat.pl GSE20060_Detection_normalization_expression.anno.txt GSE20060.stat.txt
#less GSE20060.stat.txt|grep PCDH|sort -k 4 -n -r|cat
