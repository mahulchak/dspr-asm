myRCircos.Draw.Chromosome.Ideogram <-
function (ideo.pos = NULL, ideo.width = NULL) 
{
  RCircos.Cyto <- RCircos.Get.Plot.Ideogram()
  RCircos.Pos <- RCircos.Get.Plot.Positions()
  RCircos.Par <- RCircos.Get.Plot.Parameters()
  if (is.null(ideo.pos)) 
    ideo.pos <- RCircos.Par$chr.ideo.pos
  if (is.null(ideo.width)) 
    ideo.width <- RCircos.Par$chrom.width
  outerPos <- ideo.pos + ideo.width
  innerPos <- ideo.pos
  chromosomes <- unique(RCircos.Cyto$Chromosome)
  RCircos.Track.Outline(outerPos, innerPos, num.layers = 1, 
                        chromosomes, track.colors = rep("white", length(chromosomes)))
  whiteBands <- which(RCircos.Cyto$BandColor == "white")
  #print(whiteBands)
  darkBands <- RCircos.Cyto[-whiteBands, ]
  #print(darkBands)
  for (aBand in seq_len(nrow(darkBands))) {
    aColor <- darkBands$BandColor[aBand]
    #print(aColor)
    aStart <- darkBands$StartPoint[aBand]
    aEnd <- darkBands$EndPoint[aBand]
    posX <- c(RCircos.Pos[aStart:aEnd, 1] * outerPos, RCircos.Pos[aEnd:aStart, 
                                                                  1] * innerPos)
    posY <- c(RCircos.Pos[aStart:aEnd, 2] * outerPos, RCircos.Pos[aEnd:aStart, 
                                                                  2] * innerPos)
    polygon(posX, posY, col = aColor, border = NA)
  }
}