mySetCytobandData <-
function (cyto.band.info = NULL) 
{
  if (is.null(cyto.band.info)) 
    stop("Missing ideogram data.\n")
  if (is.data.frame(cyto.band.info) == FALSE) 
    stop("Ideogram data must be in data frame or matrix.\n")
  stain2color <- as.character(cyto.band.info$Stain)
  bandColor <- rep(colors()[652], length(stain2color))
  #stains <- c("gneg", "acen", "stalk", "gvar", "gpos", "gpos100", 
  #            "gpos75", "gpos66", "gpos50", "gpos33", "gpos25")
  stains <- c("gneg", "00", "01", "10", "11", "gpos100",
           "gpos75", "gpos66", "gpos50", "gpos33", "gpos25")
  #colorIndex <- c(1, 552, 615, 418, 24, 24, 193, 203, 213, 
  #               223, 233)
  #colorIndex <- c(1, 29, 70, 79, 148, 24, 193, 203, 213, 
  #              223, 233)
  colorIndex <- c(1, 620, 624, 351, 301, 24, 193, 203, 213, 
                  223, 233)
    for (aStain in seq_len(length(stains))) {
    bands <- which(stain2color == stains[aStain])
    if (length(bands) > 0) {
      bandColor[bands] <- colors()[colorIndex[aStain]]
      
    }
  }
  cyto.band.info["BandColor"] <- bandColor
  chromColor <- c(552, 574, 645, 498, 450, 81, 26, 584, 524, 
                  472, 32, 57, 615, 635, 547, 254, 100, 72, 630, 589, 8, 
                  95, 568, 52)
  chrom2color <- as.character(cyto.band.info$Chromosome)
  chromosomes <- unique(chrom2color)
  numOfChrom <- length(chromosomes)
  numOfColor <- length(chromColor)
  if (numOfChrom > numOfColor) {
    recycleTime <- floor(numOfChrom/numOfColor) + 1
    moreColors <- rep(chromColor, recycleTime)
    chromColor <- moreColors[1:numOfChrom]
  }
  for (aChr in seq_len(length(chromosomes))) {
    rows <- which(chrom2color == chromosomes[aChr])
    if (length(rows) > 0) {
      chrom2color[rows] <- colors()[chromColor[aChr]]
    }
  }
  cyto.band.info["ChrColor"] <- chrom2color
  RCircos.Par <- RCircos.Get.Plot.Parameters()
  chromosomeStart <- as.numeric(cyto.band.info$ChromStart)
  chromosomeEnd <- as.numeric(cyto.band.info$ChromEnd)
  chromosomes <- unique(cyto.band.info$Chromosome)
  chrRows <- which(cyto.band.info$Chromosome == chromosomes[1])
  startIndex <- chromosomeStart[chrRows]/RCircos.Par$base.per.unit
  endIndex <- chromosomeEnd[chrRows]/RCircos.Par$base.per.unit
  startIndex[1] <- 1
  lastEnd <- endIndex[length(chrRows)] + RCircos.Par$chrom.paddings
  for (aChr in seq_len(length(chromosomes))[-1]) {
    chrRows <- which(cyto.band.info$Chromosome == chromosomes[aChr])
    theStart <- chromosomeStart[chrRows]/RCircos.Par$base.per.unit
    theEnd <- chromosomeEnd[chrRows]/RCircos.Par$base.per.unit
    theStart <- theStart + lastEnd
    theEnd <- theEnd + lastEnd
    startIndex <- c(startIndex, theStart)
    endIndex <- c(endIndex, theEnd)
    lastEnd <- theEnd[length(chrRows)] + RCircos.Par$chrom.paddings
  }
  cyto.band.info["StartPoint"] <- round(startIndex, digits = 0)
  cyto.band.info["EndPoint"] <- round(endIndex, digits = 0)
  RCircosEnvironment <- NULL
  RCircosEnvironment <- get("RCircos.Env", envir = globalenv())
  RCircosEnvironment[["RCircos.Cytoband"]] <- cyto.band.info
}
