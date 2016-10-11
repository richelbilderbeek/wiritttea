## ------------------------------------------------------------------------
library(wiritttea)
options(warn = 2)

## ------------------------------------------------------------------------
nltt_stats_raw <- read_collected_nltt_stats()
#nltt_stats_raw$sti <- plyr::revalue(nltt_stats_raw$sti, c("1"="youngest", "2"="oldest"))
knitr::kable(head(nltt_stats_raw))

## ------------------------------------------------------------------------
nltt_stats <- nltt_stats_raw[!is.na(nltt_stats_raw$nltt_stat), ]

## ------------------------------------------------------------------------
df <- dplyr::summarise(
  dplyr::group_by(nltt_stats, filename, sti, ai, pi),
  idn = is_distributed_normally(nltt_stat)
)

knitr::kable(dplyr::tally(dplyr::group_by(df, idn)))

## ----fig.width = 7, fig.height = 7---------------------------------------
df_parameters <- read_collected_parameters()
df_parameters$filename <- rownames(df_parameters)

df_n_taxa <- read_collected_n_taxa()

df_idn <- dplyr::summarise(
  dplyr::group_by(nltt_stats, filename, sti, ai, pi),
  idn = is_distributed_normally(nltt_stat)
)

df <- merge(df_parameters, df_n_taxa, by = "filename")
df <- merge(df, df_idn, by = "filename")

df$idn <- plyr::mapvalues(df$idn, from = c(TRUE, FALSE, NA), to = c("normal", "not normal", "singular value"))


ggplot2::ggplot(
  data = df, ggplot2::aes(x = df$n_taxa, fill = df$idn)
) + ggplot2::scale_x_log10(
  "Number of taxa"
) + ggplot2::geom_histogram(
  bins = 20
) + ggplot2::ggtitle(
  "nLTT statistic posterior distribution types"
) + ggplot2::guides(
  # Remove legend title
  fill = ggplot2::guide_legend(title = NULL) 
) + ggplot2::scale_y_continuous(
  "Number of posteriors"
)

## ----fig.width = 7, fig.height = 7---------------------------------------
# Collect the posteriors that have a normally distributed
# nLTT statistic
df_normal <- df[df$idn == "normal", ]

# Select of those posteriors the ones with the highest number
# of taxa
normal_max_n_taxa <- df_normal[
  df_normal$n_taxa == max(df_normal$n_taxa), 
]

# Obtain that first posterior its nLTT statistics
normal_max_n_taxa_nltts <- nltt_stats[ 
  nltt_stats$filename == normal_max_n_taxa[1, ]$filename & 
  nltt_stats$sti == normal_max_n_taxa[1, ]$sti & 
  nltt_stats$ai == normal_max_n_taxa[1, ]$ai & 
  nltt_stats$pi == normal_max_n_taxa[1, ]$pi, 
]

# Plot those nLTT statistics
# Histogram: nLTT distribution
# Solid line with fill: nLTT density
# Dashed line: normal distribution
ggplot2::ggplot(
  normal_max_n_taxa_nltts, 
  ggplot2::aes(x=normal_max_n_taxa_nltts$nltt_stat)
) + ggplot2::geom_histogram(
  ggplot2::aes(y=..density..)
) + ggplot2::geom_density(
  alpha=.2, 
  fill="#666666"
) + ggplot2::ggtitle("nLTT statistic distribution that is normally distributed"
) + ggplot2::stat_function(
  fun = dnorm, 
  args = list(
    mean = mean(normal_max_n_taxa_nltts$nltt_stat), 
    sd = sd(normal_max_n_taxa_nltts$nltt_stat)
  ), 
  lty = 2
)

## ----fig.width = 7, fig.height = 7---------------------------------------
# Collect the posteriors that have a normally distributed
# nLTT statistic
df_not_normal <- df[df$idn == "not normal", ]

# Select of those posteriors the ones with the highest number
# of taxa
not_normal_max_n_taxa <- df_not_normal[
  df_not_normal$n_taxa == max(df_not_normal$n_taxa), 
]

not_normal_max_n_taxa_nltts <- nltt_stats[ 
  nltt_stats$filename == not_normal_max_n_taxa[1, ]$filename & 
  nltt_stats$sti == not_normal_max_n_taxa[1, ]$sti & 
  nltt_stats$ai == not_normal_max_n_taxa[1, ]$ai & 
  nltt_stats$pi == not_normal_max_n_taxa[1, ]$pi, 
]

# Histogram: nLTT distribution
# Solid line with fill: nLTT density
# Dashed line: normal distribution
ggplot2::ggplot(
  not_normal_max_n_taxa_nltts, 
  ggplot2::aes(x=not_normal_max_n_taxa_nltts$nltt_stat)
) + ggplot2::geom_histogram(
  ggplot2::aes(y=..density..)
) + ggplot2::geom_density(
  alpha=.2, 
  fill="#666666"
) + ggplot2::ggtitle("nLTT statistic distribution that is not normally distributed"
) + ggplot2::stat_function(
  fun = dnorm, 
  args = list(
    mean = mean(not_normal_max_n_taxa_nltts$nltt_stat), 
    sd = sd(not_normal_max_n_taxa_nltts$nltt_stat)
  ), 
  lty = 2
)

