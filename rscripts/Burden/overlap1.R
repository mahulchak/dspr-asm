rm(list = ls())
library(viridis)
library(magrittr)
library(ggplot2)
library(ggridges)
library(scales)
calcOL <- function(x, y, delim = ',') {
  table(unlist(strsplit(
    x = c(as.character(x), as.character(y)),
    split = delim)))
}

format_bp <- function(x, suffixes = c('bp', 'kb', 'Mb', 'Gb'), digits = 2, sep = '') {
  exp3 <- log10(x) %/% 3
  return(paste(round(x/(10^(exp3*3)), digits = digits), suffixes[exp3+1], sep = sep))
}
format_bpbins <- function(x) {
  ans <- c(x[seq_along(x)[-length(x)]], x[seq_along(x)[-1]]) %>%
    format_bp %>%
    matrix(nc = 2) %>%
    apply(
      MARGIN = 1,
      FUN = function(x) paste('(', paste(x, collapse = ', '), ']', sep = '')
    )
  if (x[1] == 0) {
    ans[1] <- x[2] %>% format_bp %>% paste('≤', ., sep = '')
  }
  if (x[length(x)] == Inf) {
    ans[length(ans)] <- x[length(x)-1] %>% format_bp %>% paste('>', ., sep = '')
  }
  return(ans)
}

jrev <- function(x) { percent_format()(1-x) }

summaryn <- function(x) {
  ans <- summary(x)
  ans[7] <- length(x)
  names(ans)[7] <- 'n'
  ans
}

calcBurden <- function(genotypes, delim = ',') {
  combos <- combn(1:ncol(genotypes), 2)
  ans <- vector('list', ncol(combos))
  for (i in 1:ncol(combos)) {
    ans[[i]] <- apply(X = genotypes[,combos[,i]], MARGIN = 1, FUN = function(x) table(calcOL(x[1], x[2], delim = delim)))
    ans[i] <- ifelse(
      test = length(ans[[i]]) > 0,
      yes = ans[i],
      no = rep(x = NA, ncol(genotypes))
    )
  }
  return(ans)
}

basedir <- '/Users/jje/Google Drive/DSPR_pacbio/Manuscript/Figures/Burden'
dat <- read.table(paste(basedir, 'burden_table.08032018.txt', sep = '/'), header = TRUE)
#lengths <- read.table(paste(basedir, 'genes.lengths.txt', sep = '/'), header = TRUE)
#dat <- subset(merge(x = lengths, y = dat), !grepl('5SrRNA', Gene) & length > 1e3 )
dat <- subset(dat, !grepl('5SrRNA', Gene))

#dat <- subset(dat, length > 1e3)

#ans1 <- calcBurden(dat[,3:15], delim = ';')
#save(ans1, file = paste(basedir, 'ans1.RData', sep = '/'))

load(file = paste(basedir, 'ans1.RData', sep = '/'))
ans2 <- sapply(ans1, function(x) sapply(x, sum))
#ans3 <- ans2[rowSums(ans2) > 1,]

cuts <- c(0, 10^seq(2.5, 4.5, by = 0.5), Inf)
cuts <- quantile(x = dat$Length, probs = seq(0,1,0.1))
cuts <- c(0, 2.5e3, 5e3, 1e4, 2e4, 35e3, 5e4, Inf)
#cuts <- c(0, Inf)
lencats <- cut(x = dat$Length, breaks = cuts, include.lowest = TRUE, labels = format_bpbins(cuts))

#tapply(X = ans2, INDEX = lencats, function(x) sum(x > 0)/length(x))
#by(data = ans2, INDICES = lencats, FUN = function(x) c(sum(x > 0)/prod(dim(x))) )

svcount <- by(data = ans2, INDICES = lencats, FUN = function(xx) as.vector(xx[xx>0]))
flatsvcount <- data.frame(
  Length = rep(names(svcount), as.vector(sapply(svcount, length))),
  Count = unlist(svcount),
  stringsAsFactors = FALSE
)
#flatsvcount <- flatsvcount[order(flatsvcount$Count),]
flatsvcount$Length <- with(flatsvcount, factor(x = Length, levels = (levels(lencats))))

svburden <- by(data = ans2, INDICES = lencats, FUN = function(xx) apply(X = xx, MARGIN = 2, function(x) sum(x > 0)/length(x)), simplify = TRUE)

flatsvburden <- data.frame(
  Length = rep(names(svburden), each = length(svburden[[1]])),
  Burden = as.vector(sapply(
    X = seq_along(svburden),
    FUN = function(y, i) (as.vector(y[[i]])),
    y = svburden)),
  stringsAsFactors = FALSE
)

flatsvburden$Length <- with(flatsvburden, factor(x = Length, levels = levels(lencats)))

svburdensummary <- cbind(cbind(t(sapply(svburden, summary))), cbind(table(lencats)))
colnames(svburdensummary)[7] <- 'n'

cbreaks <- c(0:4, Inf)
flatsvcount$Counts <- flatsvcount$Count
flatsvcount$Counts[flatsvcount$Counts >4] <- 5

flatsvcount2 <- with(flatsvcount, tapply(X = Counts, INDEX = Length, FUN = function(x) table(x)/length(x)))
flatsvcountprop <- data.frame(
  Length = rep(names(flatsvcount2), each = length(flatsvcount2[[1]])),
  Count = as.vector(sapply(
    X = seq_along(flatsvcount2),
    FUN = function(y, i) (as.vector(names(y[[i]]))),
    y = flatsvcount2
  )),
  Proportion = as.vector(sapply(
    X = seq_along(flatsvcount2),
    FUN = function(y, i) (as.vector(y[[i]])),
    y = flatsvcount2
  )),
  stringsAsFactors = FALSE
)
flatsvcountprop$Length <- with(flatsvcountprop, factor(x = Length, levels = levels(lencats)))

p1 <- ggplot(flatsvcountprop, aes(x = Length, y = Proportion, fill = factor(Count))) +
  geom_bar(stat = 'identity', position = 'fill') +
  scale_y_continuous(labels = jrev, trans = 'reverse')+
  scale_fill_viridis(
    alpha = 1,
    discrete = TRUE, option = 'C',
    name = '# SVs\nper gene\nper diploid',
    labels= c(1:4, '≥5')
  ) +
  theme_bw() +
  xlab(label = 'gene span') +
  ylab(label = '# SVs per diploid within SV containing genes') +
#  ggtitle(label = 'SV multiplicity') +
  NULL

p1a <- p1 +
  theme(
    axis.text.x  = element_text(angle=30, vjust=0.5, size = 10),
    axis.title.x = element_text(size = 12)
  )

p1b <- p1 + 
  theme(
    axis.text.x  = element_text(vjust=0.5, size = 10),
    axis.title.x = element_text(size = 12)
  ) + coord_flip()

print(p1a)

cairo_pdf(filename = paste(basedir, 'numsvs.pdf', sep = '/'), width = 8, height = 4)
print(p1a)
dev.off()
svg(filename = paste(basedir, 'numsvs.svg', sep = '/'), width = 8, height = 4)
print(p1a)
dev.off()

cairo_pdf(filename = paste(basedir, 'numsvs_flip.pdf', sep = '/'), width = 8, height = 3)
print(p1b)
dev.off()
svg(filename = paste(basedir, 'numsvs_flip.svg', sep = '/'), width = 8, height = 3)
print(p1b)
dev.off()

p2 <- ggplot(flatsvburden, aes(x = Burden, y = Length, fill = ..x..)) + 
  geom_density_ridges_gradient(scale = 5) +
  scale_fill_viridis(name = '% burden', option = 'C', labels = percent) +
  scale_y_discrete(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0.05), labels = percent) +
  theme_ridges() + ylab(label = 'gene span') +
  xlab(label = '% genes burdened by structural variation per diploid') +
#  ggtitle(label = 'distribution of diploid SV burden') +
  NULL

cairo_pdf(filename = paste(basedir, 'burden.pdf', sep = '/'), width = 8, height = 3)
print(p2)
dev.off()

svg(filename = paste(basedir, 'burden.svg', sep = '/'), width = 8, height = 3)
print(p2)
dev.off()

#table(ans2)/length(ans2)
#table(ans2[ans2 > 0])/sum(ans2 > 0)

alldat <- as.matrix(dat[,3:15])
numsvs <- apply(alldat, 1, function(x) length(table(unlist(strsplit(x, split = ';')))))
