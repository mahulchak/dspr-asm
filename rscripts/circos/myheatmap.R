myheatmap <- function (heatmap.data = NULL, data.col = NULL, track.num = NULL, 
          side = c("in", "out"), min.value = NULL, max.value = NULL, 
          inside.pos = NULL, outside.pos = NULL, genomic.columns = 3, 
          is.sorted = TRUE) 
{
  if (is.null(heatmap.data)) 
    stop("Genomic data missing in RCircos.Heatmap.Plot().\n")
  if (is.null(genomic.columns)) 
    stop("Missing number of columns for genomic position.\n")
  if (is.null(data.col) || data.col <= genomic.columns) 
    stop("Data column must be ", genomic.columns + 1, " or bigger.\n")
  boundary <- RCircos.Get.Plot.Boundary(track.num, side, inside.pos, 
                                        outside.pos, FALSE)
  outerPos <- boundary[1]
  innerPos <- boundary[2]
  RCircos.Cyto <- RCircos.Get.Plot.Ideogram()
  RCircos.Pos <- RCircos.Get.Plot.Positions()
  RCircos.Par <- RCircos.Get.Plot.Parameters()
  colorMap <- RCircos.Get.Heatmap.Color.Scale(RCircos.Par$heatmap.color)
  if (is.null(min.value) || is.null(max.value)) {
    columns <- (genomic.columns + 1):ncol(heatmap.data)
    min.value <- min(as.matrix(heatmap.data[, columns]))
    #print(min.value)
    max.value <- max(as.matrix(heatmap.data[, columns]))
    #print(max.value)
  }
  colorLevel <- seq(min.value, max.value, length = length(colorMap))
  #adding my own color through viridis
  mycolor <- viridis(length(colorMap),begin=0,end=1,option = "C")
  #mycolorCode <- data.frame(mycolor,row.names = colorLevel)
  #print(mycolor)
  #print(colorLevel)
  #print(mycolorCode)
  heatmap.data <- RCircos.Get.Single.Point.Positions(heatmap.data, 
                                                     genomic.columns)
  plotLocations <- RCircos.Get.Start.End.Locations(heatmap.data, 
                                                   RCircos.Par$heatmap.width)
  chromosomes <- unique(as.character(RCircos.Cyto$Chromosome))
  outlineColors <- rep("white", length(chromosomes))
  RCircos.Track.Outline(outerPos, innerPos, num.layers = 1, 
                        chrom.list = chromosomes, track.colors = outlineColors)
  heatmapValues <- as.numeric(heatmap.data[, data.col])
  for (aPoint in 1:length(heatmapValues)) {
    theLevel <- which(colorLevel >= heatmapValues[aPoint])
    #cellColor <- colorMap[min(theLevel)]
    #print(min(theLevel))
    #print(mycolor[min(theLevel)])
    cellColor <- mycolor[min(theLevel)]
    theStart <- plotLocations[aPoint, 1]
    theEnd <- plotLocations[aPoint, 2]
    polygonX <- c(RCircos.Pos[theStart:theEnd, 1] * outerPos, 
                  RCircos.Pos[theEnd:theStart, 1] * innerPos)
    polygonY <- c(RCircos.Pos[theStart:theEnd, 2] * outerPos, 
                  RCircos.Pos[theEnd:theStart, 2] * innerPos)
    polygon(polygonX, polygonY, col = cellColor, border = NA)
  }
}
