##############
# Mahul2VCF.py 
##############

##  Anthony D Long, UC Irvine, July 2018

from __future__ import print_function
import os
import subprocess
import sys

#  module load samtools
#  module load enthought_python/7.3.2
#  module load R/3.4.1
#     cutree.R in path
#     install.packages("seqinr") in R
#  symlinks to fasta files for each assembly in "data/"
#  output folder locusseq
#  "clustalo-1.2.4-Ubuntu-x86_64/" directory or path in bin

# get a summary of variation in Mahul's special format
# cp /share/adl/share-folder/master_table_d10_100bp.03222018.txt .
# cat master_table_d10_100bp.03222018.txt | cut -f16 | sort | uniq -c

# some examples of usage
# head -n 20 master_table_d10_100bp_02082018.final.txt | python Mahul2VCF.py
# cat master_table_d10_100bp.03222018.txt python Mahul2VCF.py > SV.0322.vcf
# cat master_table_d10_100bp_03132018.final.txt | grep -P "\tte-INS" | head -n 20 | python Mahul2VCF.py > te-INS_test.txt


def extractFasta(strain, chromosome, start, stop):
	# strain = a1,...,b1,...,ab8,ore,iso1
	# chromsome = a1,...,ab8 = 2L, 2R, 3L, 3R, X
	# chromosome = chr2L, ...
	# start = bp
	# stop = bp
	# raw data at "/share/adl/tdlong/DSPR/PCfly/genomes/" simlinks at /share/adl/tdlong/DSPR/Mahul2VCF/data
	filename = "data/" + strain + ".scaffold.fasta"
	if strain == "iso1":
		shellCommand = "samtools faidx " + filename + " iso1."+chromosome + ":" + start + "-" + stop
	else:
		shellCommand = "samtools faidx " + filename + " " + chromosome + ":" + start + "-" + stop
	proc = subprocess.Popen(shellCommand, stdout=subprocess.PIPE, shell=True)
	fseq = proc.stdout.read()
	return fseq
	

# print a header so we have a real vcf file
print("""##fileformat=VCFv4.0
##fileDate=20180212
##alignmentGenome=Dmelr6
##INFO=<ID=FL,Number=1,Type=String,Description="Flavor of Mahuls event">
##INFO=<ID=NA,Number=1,Type=Integer,Description="Number of Alleles">
##INFO=<ID=XI,Number=1,Type=String,Description="External ID">
##INFO=<ID=CE,Number=1,Type=Integer,Description="Simple Event = 0, Event near complex event = 1, Complex Event = 2">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Haploid Genotype">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	A1	A2	A3	A4	A5	A6	A7	B1	B2	B3	B4	B5	B6	B7	AB8""")

# b5, b7 are missing
mystrains = {"a1":0,"a2":1,"a3":2,"a4":3,"a5":4,"a6":5,"a7":6,"b1":7,"b2":8,"b3":9,"b4":10,"b5":11,"b6":12,"b7":13,"ab8":14}

for line in sys.stdin:

	genos = ['0','0','0','0','0','0','0','0','0','0','0','.','0','.','0']
	line=line.rstrip()
	Line = line.split()
	chr = Line[0].split(".")[1].strip()
	start = Line[1].strip()
	end = Line[2].strip()
	label = chr+'_'+start+'_'+end
	numberDiffs = int(Line[3])
	flavor = Line[7].split(";")[0].strip()
	externalID = Line[11]
	complexEvent = Line[15]
	#  flavors = te-INS, nte-INS, te-DEL, nte-DEL, DEL-rteINS, CNV, INV 

	output=""
	# chr, pos, id
	print("chr"+chr+"\t"+start+"\t.\t",end='')
	refseq = extractFasta("iso1", chr, start, end)
	# ref
	print(''.join(refseq.splitlines()[1:])+"\t",end='')	
	

	if numberDiffs > 1:
		AA={}
		for i in range(numberDiffs):
			tmpstrain = Line[8].split(";")[i].split(".")[0].strip()
			tmpstart = Line[9].split(";")[i].strip()
			tmpstop = Line[10].split(";")[i].strip()
			tmpFasta = extractFasta(tmpstrain, chr, tmpstart, tmpstop)
			output += '>'+tmpstrain+'.'+tmpFasta[1:]
			seq = ''.join(tmpFasta.splitlines()[1:])
			AA[tmpstrain]=seq

		fh = open("locusseq/"+label+".seq","w")
		fh.write(output)
		fh.close()
	

		#./clustalo-1.2.4-Ubuntu-x86_64 -i test2.fa --outfmt=phy -o test2.phy 
		# ./clustalo-1.2.4-Ubuntu-x86_64 -i test.fa --outfmt=phy -o test.phy --percent-id --force	
		shellCommand = "./clustalo-1.2.4-Ubuntu-x86_64 -i locusseq/" + label + ".seq --outfmt=phy -o locusseq/" + label + ".phy --percent-id --force"
		proc = subprocess.Popen(shellCommand, stdout=subprocess.PIPE, shell=True)
		blah = proc.stdout.read()

		#Rscript --vanilla sillyScript.R iris.txt out.txt
		shellCommand2 = "Rscript --vanilla cutree.R locusseq/" + label + ".phy locusseq/" + label + ".lev"
		proc = subprocess.Popen(shellCommand2, stdout=subprocess.PIPE, shell=True)
		blah2 = proc.stdout.read()
		

		fh = open("locusseq/"+label+".lev","r")
		myin = fh.read()
		fh.close()
		

		#ALT	QUAL	FILTER	INFO	FORMAT	A1	A2	A3	A4	A5	A6	A7	B1	B2	B3	B4	B5	B6	B7	AB8
		Myin = myin.split("\t")
		Mynames = Myin[0].split(";")
		Mycut = Myin[1].split(";")
		MyNalleles = int(Myin[2])
		mm = {}
		for i in range(numberDiffs):
			tmpname = Mynames[i].split(".")[0].strip()
			tmpallele = Mycut[i].strip().strip()
			genos[mystrains[tmpname]] = tmpallele
			if tmpallele not in mm:
				mm[tmpallele]=tmpname
		

		if MyNalleles == 1:
			print(AA[mm["1"]]+"\t.\t.\tFL="+flavor+";NA=1;XI="+externalID+";CE="+complexEvent+"\tGT\t",end='')
			print("\t".join(genos))
		else:
			for i in range(1,MyNalleles):
				print(AA[mm[str(i)]]+",  ",end='')				
			print(AA[mm[str(MyNalleles)]]+"\t.\t.\tFL="+flavor+";NA="+str(MyNalleles)+";XI="+externalID+";CE="+complexEvent+"\tGT\t",end='')
			print("\t".join(genos))
	else:
		tmpstrain = Line[8].split(".")[0].strip()
		tmpstart = Line[9].strip()
		tmpstop = Line[10].strip()
		tmpFasta = extractFasta(tmpstrain, chr, tmpstart, tmpstop)
		seq = ''.join(tmpFasta.splitlines()[1:])
		print(seq+"\t.\t.\tFL="+flavor+";NA=1;XI="+externalID+";CE="+complexEvent+"\tGT\t",end='')
		genos[mystrains[tmpstrain]] = "1"
		print("\t".join(genos))
