library(RCircos)
library(viridis)
#chromInfo <- read.table("filter_new.bed",header = TRUE)
#chromInfo <- read.table("chrom_bands/test.bed",header = TRUE)
chromInfo <- read.table("chrom_bands/bands2stain.newcord.txt",header = TRUE)
#chromInfo <- read.table("chrom_bands/bands1stain.full.newcord.txt")
#read the TEs in
te100k <- read.table("w100.TE.overlap.newcord.txt",header = FALSE)
te150k <- read.table("w150.TE.overlap.newcord.txt",header = FALSE)
te200k <- read.table("w200.TE.overlap.newcord.txt",header = FALSE)
te250k <- read.table("w250.TE.overlap.newcord.txt",header = FALSE)
te300k <- read.table("w300.TE.overlap.newcord.txt",header = FALSE)
te350k <- read.table("w350.TE.overlap.newcord.txt",header = FALSE)
te400k <- read.table("w400.TE.overlap.newcord.txt",header = FALSE)
ticks <- read.table("chrom_bands/chromticks.bed",header = TRUE)
#transform into log scale
b <- 2
te100k$V4<- log(te100k$V4+1,base=b)
te150k$V4<- log(te150k$V4+1,base=b)
te200k$V4<- log(te200k$V4+1,base=b)
te250k$V4<- log(te250k$V4+1,base=b)
te300k$V4<- log(te300k$V4+1,base=b)
te350k$V4<- log(te350k$V4+1,base=b)
te400k$V4<- log(te400k$V4+1,base=b)

#initiate core device
chr.exclude <- NULL
cyto.info <- chromInfo
tracks.inside <- 8
#RCircos.Set.Core.Components(cyto.info,chr.exclude,tracks.inside,tracks.outside)
myRCircos.Set.Core.Components(cyto.info,chr.exclude,tracks.inside,tracks.outside)
rcircos.params <- RCircos.Get.Plot.Parameters()
rcircos.params$track.background <- "white"
rcircos.params$grid.line.color <- "white"
rcircos.params$hist.color <- "darkblue"
rcircos.params$base.per.unit <- 20000
rcircos.params$chrom.paddings <-50 #was 50
rcircos.params$hist.width <- 10
rcircos.params$heatmap.width <- 10 #was 10
rcircos.params$track.padding <- 0.01
rcircos.params$track.height <- 0.10
rcircos.params$chrom.width <- 0.15
#rcircos.params$chr.ideo.pos <- 1.1
#rcircos.params$track.in.start <- 1.1
#rcircos.params$plot.radius < 1.2
rcircos.params$text.size <- 0.8
#RCircos.Reset.Plot.Parameters(rcircos.params) #reset plot parameters
myRCircos.Reset.Plot.Parameters(rcircos.params)
#rcircos.cyto <- RCircos.Get.Plot.Ideogram()
#rcircos.position <- RCircos.Get.Plot.Positions()
#create the track for 20kb windows
out.file <- "TE.log2.pdf"
#pdf(file = out.file,height=8,width=8)
RCircos.Set.Plot.Area()
par(mai=c(0.25, 0.25, 0.25, 0.25))
plot.new()
plot.window(c(-2.5,2.5), c(-2.5, 2.5))
#RCircos.Chromosome.Ideogram.Plot(tick.interval = 1)
#RCircos.Chromosome.Ideogram.Plot()
RCircos.Ideogram.Tick.Plot(tick.interval = 2.5)
myRCircos.Chromosome.Ideogram.Plot()
#RCircos.Heatmap.Plot(te20k,data.col,track.num,side)
data.col <- 4
track.num <- 1
side <- "in"
myheatmap(te100k,data.col,track.num,side)
data.col <- 4
track.num <- 2
side <- "in"
myheatmap(te150k,data.col,track.num,side)
data.col <- 4
track.num <- 3
side <- "in"
myheatmap(te200k,data.col,track.num,side)
data.col <- 4
track.num <- 4
side <- "in"
myheatmap(te250k,data.col,track.num,side)
data.col <- 4
track.num <- 5
side <- "in"
myheatmap(te300k,data.col,track.num,side)
data.col <- 4
track.num <- 6
side <- "in"
myheatmap(te350k,data.col,track.num,side)
data.col <- 4
track.num <- 7
side <- "in"
myheatmap(te400k,data.col,track.num,side)
data.col <- 4
track.num <- 8
side <- "in"
RCircos.Histogram.Plot(ticks,data.col,track.num,side)
#plot the outside tracks
#legend(x=0.1,y=0.9)
#RCircos.Histogram.Plot(te20k,data.col,track.num,side)
#dev.off()
#mymat <- matrix(data=(1:100),nrow = 100,ncol = 1)
#image(x=10*(1:nrow(mymat)),y=10*(1:ncol(mymat)),z=mymat,col = viridis(1000,option = "C"))
#library(SDMTools)
#pnts = cbind(x =c(0.1,0.3,0.3,0.1), y =c(0.5,0.5,0.1,0.1))
#legend.gradient(pnts,cols = viridis(5000,begin = 0,end = 1, option = "D"),c("Low","High"))
