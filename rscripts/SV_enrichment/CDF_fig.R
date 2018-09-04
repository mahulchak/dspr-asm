rm(list=ls())
library(ggplot2)
library(RColorBrewer)
library(grid)
library(scales)
library(tiff)
library(png)
library(extrafont)
source('/Users/jje/Dropbox/paper/ggplot_layout.R')
reverselog_trans <- function(base = exp(1)) {
  trans <- function(x) -log(x, base)
  inv <- function(x) base^(-x)
  trans_new(paste0("reverselog-", format(base)), trans, inv, 
            log_breaks(base = base), 
            domain = c(1e-100, Inf))
}

k <- 1; w <- k*12; h <- w/2; max_contig_n <- 1000
k <- 0.8; w <- k*12; h <- w/2

datdir <- '/Users/jje/Google\ Drive\ jje@uci.edu/Dropbox/common_figures/CDF_fig/DSPR/'
datdir <- '/Users/jje/Google\ Drive/Dropbox/common_figures/CDF_fig/DSPR/'

fileparts <- expand.grid(datdir, c(paste('a', c(1:7), sep = ''), 'ab8', paste('b', c(1:4, 6), sep = ''), 'iso1', 'ore'), '.length')
files <- data.frame(
  file = apply(
    X = fileparts,
    MARGIN = 1, FUN = paste, collapse = ''
  ),
  Strain = toupper(fileparts$Var2),
  stringsAsFactors = FALSE
)

lendf <- data.frame(Lengths = vector(mode = 'integer'), Strain = vector(mode = 'character'), 'Type' = vector(mode = 'character'))
for (i in 1:nrow(files)) {
  L <- c(0, sort(scan(files$file[i]), decreasing = TRUE), 0)
  dfi <- data.frame(
    Lengths = L,
    CDF = cumsum(L),
    Strain = files$Strain[i],
    Contig.Number = 0:(length(L)-1)
  )
  # if (length(L) <= max_contig_n) {
  #   dfi <- rbind(
  #     dfi,
  #     data.frame(
  #       Lengths = 0,
  #       CDF = sum(L),
  #       Strain = files$Strain[i],
  #       Type = files$Type[i],
  #       Contig.Number = max_contig_n
  #     )
  #   )
  # }
  print(files[i,])
  lendf <- rbind(lendf, dfi)
}
lendf <- data.frame(lendf, Type = 'PacBio', stringsAsFactors = FALSE)
lendf$Type[lendf$Strain == 'ISO1'] <- 'FlyBase'
lendf$Type <- factor(lendf$Type, levels = c('PacBio', 'FlyBase')[1:2])
lendf$Strain <- factor(lendf$Strain, levels = c(levels(lendf$Strain)[c(14:15, 1:13)]))
lendf <- subset(lendf, Contig.Number <= max_contig_n)

cols <- c('black', 'darkgray', 'black', brewer.pal(9, 'Set1'))
cols <- c('black','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928', '#8dd3c7', '#bebada', '#fb8072')
p <- ggplot(data = subset(x = lendf, Contig.Number <= max_contig_n), aes(x = Contig.Number, y = CDF, lty = Type, col = Strain))
CDFfig <- p +
  theme_bw(base_size = 24) +
  geom_line(data = lendf, size = 1.2) +
#  geom_line(data = subset(x = lendf, Strain != 'ISO1'), size = 1.5) +
#  geom_line(data = subset(x = lendf, Strain == 'ISO1'), size = 1.5) +
#  theme_bw(base_size = 24) +
  ggtitle(label = 'Assembly Contiguity') +
  scale_color_manual(values = cols) +
#  scale_color_manual(name = "Strain", values = cols, labels = rev(spnames)) +
  labs(y = 'Cumulative contig length (bp)', x = expression(Sequence~length~rank~(log[10]~scale))) +
  theme(
    legend.key.width = unit(0.08, "npc"),
    text = element_text(size = 24, family="Georgia"),
    legend.text.align = 0,
    panel.grid.major = element_line(size = 2),
    panel.grid.minor = element_line(size = 2),
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5)
  ) +
#  scale_linetype_manual(name = "Assembly Type", values = c(2,1), labels = c('FlyBase', 'PacBio')) +
  geom_hline(yintercept = c(0, 144.11e6, 139.55e6)[1], color = c('black', cols)[1]) +
  scale_x_log10(breaks = c(1, 3, 10, 30, 100, 300, 1000), limits = c(1, 300)) +
  ylim(0, 150e6)

pdffile <- paste(datdir, 'CDF.pdf', sep = '')
pdffile <- paste('~/Desktop/', 'CDF.pdf', sep = '')
# pdffile <- "/Users/jje/Google Drive jje@uci.edu/A4_CNV/supplementary_figs/supplementary Fig 2.pdf"
cairo_pdf(
  file = pdffile, width = w/1.2, height = 1.3*h
)
print(CDFfig)
dev.off()
