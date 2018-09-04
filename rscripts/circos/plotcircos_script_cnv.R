library(RCircos)
library(viridis)
#chromInfo <- read.table("filter_new.bed",header = TRUE)
chromInfo <- read.table("chrom_bands/bands2stain.newcord.txt",header = TRUE)
#read the CNVs in
cnv100k <- read.table("cnv/w100.cnv.overlap.newcord.txt",header = FALSE)
cnv150k <- read.table("cnv/w150.cnv.overlap.newcord.txt",header = FALSE)
cnv200k <- read.table("cnv/w200.cnv.overlap.newcord.txt",header = FALSE)
cnv250k <- read.table("cnv/w250.cnv.overlap.newcord.txt",header = FALSE)
cnv300k <- read.table("cnv/w300.cnv.overlap.newcord.txt",header = FALSE)
cnv350k <- read.table("cnv/w350.cnv.overlap.newcord.txt",header = FALSE)
cnv400k <- read.table("cnv/w400.cnv.overlap.newcord.txt",header = FALSE)
ticks <- read.table("chrom_bands/chromticks.bed",header = TRUE)
#transform into log scale
b <- 2
cnv100k$V4<- log(cnv100k$V4+1,base=b)
cnv150k$V4<- log(cnv150k$V4+1,base=b)
cnv200k$V4<- log(cnv200k$V4+1,base=b)
cnv250k$V4<- log(cnv250k$V4+1,base=b)
cnv300k$V4<- log(cnv300k$V4+1,base=b)
cnv350k$V4<- log(cnv350k$V4+1,base=b)
cnv400k$V4<- log(cnv400k$V4+1,base=b)
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
myRCircos.Reset.Plot.Parameters(rcircos.params) #reset plot parameters
#rcircos.cyto <- RCircos.Get.Plot.Ideogram()
#rcircos.position <- RCircos.Get.Plot.Positions()
#create the track for 20kb windows
out.file <- "cnv.log2.pdf"
pdf(file = out.file,height=8,width=8)
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
myheatmap(cnv100k,data.col,track.num,side)
data.col <- 4
track.num <- 2
side <- "in"
myheatmap(cnv150k,data.col,track.num,side)
data.col <- 4
track.num <- 3
side <- "in"
myheatmap(cnv200k,data.col,track.num,side)
data.col <- 4
track.num <- 4
side <- "in"
myheatmap(cnv250k,data.col,track.num,side)
data.col <- 4
track.num <- 5
side <- "in"
myheatmap(cnv300k,data.col,track.num,side)
data.col <- 4
track.num <- 6
side <- "in"
myheatmap(cnv350k,data.col,track.num,side)
data.col <- 4
track.num <- 7
side <- "in"
myheatmap(cnv400k,data.col,track.num,side)
data.col <- 4
track.num <- 8
side <- "in"
RCircos.Histogram.Plot(ticks,data.col,track.num,side)
#plot the outside tracks
#legend(x=0.1,y=0.9)
#RCircos.Histogram.Plot(te20k,data.col,track.num,side)
dev.off()
