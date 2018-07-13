#bedtools merge -i sv.a1.a2.txt -c 2,4,5,6,7,8,9,10 -o count,collapse,collapse,collapse,collapse,collapse,collapse,collapse -delim ";"|less

#bedtools merge -d 10 -i sv.all.clean.txt -c 2,1,2,3,4,5,6,7,8,9,10,11 -o count,collapse,collapse,collapse,collapse,collapse,collapse,collapse,collapse,collapse,collapse,collapse -delim ";" >master_table_d10.txt
# awk '{if($4==1) print $0}' master_table_d10.txt > master_table_d10_singleton.txt
# awk '{if($4 != 1) print $0}' master_table_d10.txt > master_table_d10_no_singleton.txt
#awk '{if($4 == 2) print $0}' master_table_d10_no_singleton.txt >master_table_d10_doubleton.txt
#awk '{if($4 != 2) print $0}' master_table_d10_no_singleton.txt >master_table_d10_no_doubleton.txt
