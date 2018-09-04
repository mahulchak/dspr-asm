library(ggplot2)
library('RColorBrewer')

dat <- data.frame(
  number = c(16, 16),
  type = c('no SV', 'SV')
)

p <- ggplot() +
  geom_bar(
    data = dat,
    aes(y = number, x = type, fill = type),
    stat = "identity",
    position = 'stack'
  ) +
  theme_bw() + 
  theme(text = element_text(size = 36)) +
  scale_fill_manual("Visibility", values = brewer.pal(12, 'Paired')[c(2,4)]) +
  ylab('number of genes') + xlab('candidate SV status') +
  scale_x_discrete(labels=c("nonSV" = "non-SV", "SV" = "SV"))
cairo_pdf(filename = '~/Desktop/enrichment_bar.pdf', width = 8, height = 8)
print(p)
dev.off()

svg(filename = '~/Desktop/enrichment_bar.svg', width = 8, height = 8)
print(p)
dev.off()

