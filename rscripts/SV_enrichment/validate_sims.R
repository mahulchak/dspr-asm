jfunc <- function(x, start, end, size, poplen) {
  idx <- sample(
    x = which(poplen >= start & poplen <= end),
    size = size, replace = FALSE
  )
  return(x[idx])
}


jfunc(x = datC$V4, start = sampleMat[1,1], end = sampleMat[1,2], size = sampleMat[1,3], poplen = datC$V4)
jfuncV <- Vectorize(FUN = jfunc, vectorize.args = c('start', 'end', 'size'))

lens <- replicate(
  n = 1e4, simplify = TRUE,
  expr = unlist(jfuncV(x = datC$V4, start = sampleMat[,1], end = sampleMat[,2], size = sampleMat[,3], poplen = datC$V4))
)

SVstates <- replicate(
  n = 1e4, simplify = TRUE,
  expr = unlist(jfuncV(x = datC$V2, start = sampleMat[,1], end = sampleMat[,2], size = sampleMat[,3], poplen = datC$V4))
)

ps <- apply(X = lens, MARGIN = 2, FUN = function(x, y) wilcox.test(x, y, paired = FALSE, correct = TRUE, exact = TRUE)$p.value, y = datQ$V4)
