library(RCircos)
library(viridis)
library(ggplot2)
te100k <- read.table("w100.TE.overlap.newcord.txt",header = FALSE)
te150k <- read.table("w150.TE.overlap.newcord.txt",header = FALSE)
te200k <- read.table("w200.TE.overlap.newcord.txt",header = FALSE)
te250k <- read.table("w250.TE.overlap.newcord.txt",header = FALSE)
te300k <- read.table("w300.TE.overlap.newcord.txt",header = FALSE)
te350k <- read.table("w350.TE.overlap.newcord.txt",header = FALSE)
te400k <- read.table("w400.TE.overlap.newcord.txt",header = FALSE)
mydat <- data.frame(c(te100k$V4,te150k$V4,te200k$V4,te250k$V4,te300k$V4,te350k$V4,te400k$V4))
newdat <- unique(mydat$c.te100k.V4..te150k.V4..te200k.V4..te250k.V4..te300k.V4..te350k.V4..)
lineN <- c(1:length(newdat))
myNewDat <- data.frame(cbind(lineN,newdat))
myNewDat$log <- log(myNewDat$newdat+1,base = 2)
ggplot(data = myNewDat,aes(x=myNewDat$lineN,y=myNewDat$log)) + 
  geom_tile(aes(col=myNewDat$log)) + 
  scale_color_gradientn(colours = viridis(length(myNewDat$log),begin = 0,end = 1,option = "C")) + 
  theme(legend.title = element_text(size=18))

#do the same as above with CNV data

cnv100k <- read.table("cnv/w100.cnv.overlap.newcord.txt",header = FALSE)
cnv150k <- read.table("cnv/w150.cnv.overlap.newcord.txt",header = FALSE)
cnv200k <- read.table("cnv/w200.cnv.overlap.newcord.txt",header = FALSE)
cnv250k <- read.table("cnv/w250.cnv.overlap.newcord.txt",header = FALSE)
cnv300k <- read.table("cnv/w300.cnv.overlap.newcord.txt",header = FALSE)
cnv350k <- read.table("cnv/w350.cnv.overlap.newcord.txt",header = FALSE)
cnv400k <- read.table("cnv/w400.cnv.overlap.newcord.txt",header = FALSE)

newdat <- unique(c(cnv100k$V4,cnv150k$V4,cnv200k$V4,cnv250k$V4,cnv300k$V4,cnv350k$V4,cnv400k$V4))
lineN <- c(1:length(newdat))
myNewDat <- data.frame(cbind(lineN,newdat))
myNewDat$log <- log(myNewDat$newdat+1,base = 2)
ggplot(data = myNewDat,aes(x=myNewDat$lineN,y=myNewDat$log)) + 
  geom_tile(aes(col=myNewDat$log)) + 
  scale_color_gradientn(colours = viridis(length(myNewDat$log),begin = 0,end = 1,option = "C")) + 
   theme(legend.title = element_text(size=18))