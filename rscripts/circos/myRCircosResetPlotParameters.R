myRCircos.Reset.Plot.Parameters <-
function (new.params = NULL) 
{
  if (is.null(new.params)) 
    stop("Missing function argument.\n")
  old.params <- RCircos.Get.Plot.Parameters()
  if (new.params$radius.len != old.params$radius.len || new.params$plot.radius != 
      old.params$plot.radius || new.params$chr.ideo.pos != 
      old.params$chr.ideo.pos || new.params$tracks.inside != 
      old.params$tracks.inside || new.params$tracks.outside != 
      old.params$tracks.outside) {
    stop("Please use RCircos.Set.Core.Components() instead.\n")
  }
  if (new.params$chr.ideo.pos != old.params$chr.ideo.pos || 
      new.params$highlight.pos != old.params$highlight.pos || 
      new.params$chr.name.pos != old.params$chr.name.pos) {
    stop("Please use customized ideogram plot methods instead.\n")
  }
  RCircos.Validate.Plot.Parameters(new.params)
  if (new.params$chrom.width != old.params$chrom.width) {
    differ <- new.params$chrom.width - old.params$chrom.width
    new.params$highlight.pos <- old.params$highlight.pos + 
      differ
    new.name.pos <- old.params$chr.name.pos + differ
    if (new.params$chr.name.pos < new.name.pos) 
      new.params$chr.name.pos <- new.name.pos
  }
  if (new.params$track.in.start >= new.params$chr.ideo.pos) 
    new.params$track.in.start <- new.params$chr.ideo.pos - 
    0.05
  new.name.end <- new.params$chr.name.pos + 0.3
  if (new.params$track.out.start < new.name.end) 
    new.params$track.out.start <- new.name.end
  if (new.params$track.padding != old.params$track.padding || 
      new.params$track.height != old.params$track.height) {
    message(paste0("Track height and/or track padding have been ", 
                   "reset\n. Actual total data track plotted may differ.\n"))
  }
  if (old.params$base.per.unit != new.params$base.per.unit && 
      old.params$chrom.paddings == new.params$chrom.paddings) {
    RCircos.Cyto <- RCircos.Get.Plot.Ideogram()
    band.len <- RCircos.Cyto$ChromEnd - RCircos.Cyto$ChromStart
    genome.len <- sum(as.numeric(band.len))
    padding.const <- RCircos.Get.Padding.Constant()
    total.units <- genome.len/new.params$base.per.unit
    new.padding <- round(padding.const * total.units, digits = 0)
    if (new.padding != new.params$base.per.unit) {
      message(paste("\nNote: chrom.padding", new.params$chrom.paddings, 
                    " was reset to", new.padding, "\n"))
      new.params$chrom.paddings <- new.padding
    }
  }
  RCircosEnvironment <- NULL
  RCircosEnvironment <- get("RCircos.Env", envir = globalenv())
  RCircosEnvironment[["RCircos.PlotPar"]] <- NULL
  RCircosEnvironment[["RCircos.PlotPar"]] <- new.params
  if (old.params$base.per.unit != new.params$base.per.unit || 
      old.params$chrom.paddings != new.params$chrom.paddings) {
    RCircos.Cyto <- RCircos.Get.Plot.Ideogram()
    RCircos.Cyto <- RCircos.Cyto[, 1:5]
    RCircosEnvironment[["RCircos.Cytoband"]] <- NULL
    #RCircos.Set.Cytoband.Data(RCircos.Cyto)
    mySetCytobandData(RCircos.Cyto)
    RCircosEnvironment[["RCircos.Base.Position"]] <- NULL
    RCircos.Set.Base.Plot.Positions()
  }
}