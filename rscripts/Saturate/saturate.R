satapply <- function(X, MARGIN, INDEX, FUN, K = 1:dim(X)[2%/%MARGIN] ) {
  stopifnot(length(FUN) == 1)
  stopifnot(MARGIN == 1 || MARGIN == 2)
  stopifnot(dim(X)[2 %/% MARGIN] != length(INDEX))

}

mat1 <- matrix(1:48, nc = 6)
id1 <- rep(letters[1:4], length.out = 8)

satapply(X = mat1, INDEX = id1, MARGIN = 1, FUN = mean)
