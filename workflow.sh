#!/bin/bash

# Path
IN=/data-shared/vcf_examples/luscinia_vars.vcf.gz
DATA_DIR=data
mkdir -p $DATA_DIR

# Chr1 & ChrZ
zcat $IN | grep -v '^#' | grep -e 'chr1\s' -e 'chrZ\s' > $DATA_DIR/filtered_body.txt

# First six columnsů
cut -f1-6 $DATA_DIR/filtered_body.txt > $DATA_DIR/cols1_6.txt

# DP info (8th column)
cut -f8 $DATA_DIR/filtered_body.txt | egrep -o 'DP=[^;]*' | sed 's/DP=//' > $DATA_DIR/dp_col.txt

# Variant
cut -f8 $DATA_DIR/filtered_body.txt | awk '{if($0 ~ /INDEL/) print "INDEL"; else print "SNP"}' > $DATA_DIR/type_col.txt

# Same length check
echo "Rows count"
wc -l $DATA_DIR/cols1_6.txt $DATA_DIR/dp_col.txt $DATA_DIR/type_col.txt

# Merge
paste $DATA_DIR/cols1_6.txt $DATA_DIR/dp_col.txt $DATA_DIR/type_col.txt > $DATA_DIR/luscinia_final.tsv

# Temp data clean up
rm $DATA_DIR/filtered_body.txt $DATA_DIR/cols1_6.txt $DATA_DIR/dp_col.txt $DATA_DIR/type_col.txt

echo "Ok"
