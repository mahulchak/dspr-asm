myRCircos.Set.Core.Components <-
function (cyto.info = NULL, chr.exclude = NULL, tracks.inside = 10, 
          tracks.outside = 0) 
{
  if (tracks.inside < 0 || tracks.outside < 0) {
    stop("Track number cannot be smaller than 0.\n")
  }
  cytoBandData <- RCircos.Validate.Cyto.Info(cyto.info, chr.exclude)
  RCircos.Initialize.Plot.Parameters(tracks.inside, tracks.outside)
  #RCircos.Set.Cytoband.Data(cytoBandData)
  mySetCytobandData(cytoBandData)
  RCircos.Set.Base.Plot.Positions()
  message("\nRCircos.Core.Components initialized.\n", "Type ?RCircos.Reset.Plot.Parameters to see", 
          " how to modify the core components.\n\n")
}