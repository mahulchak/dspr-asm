##############
# cutree.R
##############
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) { stop("At least one argument must be supplied input.phy", call.=FALSE)}
#  install.packages("seqinr")
library(seqinr)
taln  <- read.alignment(file = args[1], format = "phylip")
td <- dist.alignment(taln, matrix = "identity", gap=1)
tc <- cutree(hclust(td),h=0.05)
out <- paste(paste(names(tc),collapse=";"),"\t",paste(tc,collapse=";"),"\t",nlevels(as.factor(tc)))
cat(out,file=args[2])
