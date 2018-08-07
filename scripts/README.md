The bedtools command for merging the strain SV files can be found inside the dspr_command.sh file. The other scripts/programs necessary to obtain the VCF file is described below:

<b>varSplitter</b>

This program takes the merged variant table from multiple DSPR founder strains and then splits variants that do not overlap sufficiently into multiple rows. The use is:

```
 varSplitter merged_table.txt > split_table.txt
```
<b>checkOvl</b>

This program takes the varSplitter output and assigns complex (=1) or simple (0) tags to individual rows as an additional column. Rows with overlapping genomic intervals are assigned the complex tag (=1). It also replaces id lists for each row with a single id. The use is :

```
 checkOvl input.txt id_start id_file.txt
```

<b>comSplitter</b>

comSplitter takes the output of checkOvl and splits the complex tag into two complex tags (2 and 1). The rows with the tag =1 from checkOvl get the tag of 2 and the SVs that are within 5 Kb of these events receive a tag of 1. Usage is :

```
 comSplitter input.txt >output.txt
```

<b>merged bed to VCF</b>

The compiled output from comSplitter (which is a special merged bed format) is feed into a Python script that converts this file into a VCF format. An example use is :

```
 cat master_table_d10_100bp.txt python Mahul2VCF.py > SV.vcf
```

<b>burden formatter</b>

burden_formatter prepares the burden test compatible table from three lists: list of the gene names, list of the strains names, and the variant table with the gene names. Its use is :

```
 burden_formatter strain_list.txt gene_list.txt master_format2.newCol.all.txt > burden_table.txt

```
The product is a table that can be read into R and then analyzed.




