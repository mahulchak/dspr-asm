library(ggplot2)
library('RColorBrewer')

dat <- data.frame(
  totalMb = c(1.4, 3, 5),
  type = c('nonSV', 'SV', 'SV'),
  visibility = c('nonSV', 'hidden', 'visible')
)

dat$visibility <- with(dat, factor(visibility, levels(visibility)[c(3:1)]))

p <- ggplot() +
  geom_bar(
    data = dat,
    aes(y = totalMb, x = type, fill = visibility),
    stat = "identity",
    position = 'stack'
  ) +
  theme_bw() + 
  theme(text = element_text(size = 36)) +
  scale_fill_manual("Visibility", values = brewer.pal(12, 'Paired')[c(1,6,2)]) +
  ylab('total (Mb)') + xlab('variant type') +
  scale_x_discrete(labels=c("nonSV" = "non-SV", "SV" = "SV"))
cairo_pdf(filename = '~/Desktop/hidden.pdf', width = 8, height = 8)
print(p)
dev.off()