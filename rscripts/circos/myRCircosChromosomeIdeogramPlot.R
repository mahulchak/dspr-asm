myRCircos.Chromosome.Ideogram.Plot <-
function (tick.interval = 0) 
{
  #RCircos.Draw.Chromosome.Ideogram()
  myRCircos.Draw.Chromosome.Ideogram()
  RCircos.Highligh.Chromosome.Ideogram()
  if (tick.interval > 0) {
    RCircos.Ideogram.Tick.Plot(tick.interval)
  }
  RCircos.Label.Chromosome.Names()
}