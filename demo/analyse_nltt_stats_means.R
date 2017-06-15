# Analyse the nLTT stats
library(wiritttea)
options(warn = 2) # Be strict
path_data <- "~/GitHubs/wirittte_data/20170710"
nltt_stats_filename <- "~/GitHubs/wirittte_data/nltt_stats_20170710.csv"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) nltt_stats_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("nltt_stats_filename:", nltt_stats_filename))


if (!file.exists(nltt_stats_filename)) {
  stop("Please run nltt_stats")
}

# Read nLTT stats
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename)

names(nltt_stats)

# How many NA's?
library(dplyr)
knitr::kable(nltt_stats  %>% count(is.na(nltt_stat)))


if (1 == 2) {

  # Merge nLTT statistics and parameters
  parameters$filename <- rownames(parameters)
  df <- merge(nltt_stats, parameters, by = "filename")
  df <- merge(n_taxa, df, by = "filename")
  df$scr <- as.factor(df$scr)
  df$mutation_rate <- as.factor(df$mutation_rate)
  df$sequence_length <- as.factor(df$sequence_length)
  df$sirg <- as.factor(df$sirg)
  df$siri <- as.factor(df$siri)
  df$erg <- as.factor(df$erg)
  df$eri <- as.factor(df$eri)

  ## Show the distribution of nLTT statistics

  # Here we have the bumps:

  ggplot2::ggplot(
  ) + ggplot2::facet_grid(siri ~ erg
  ) + ggplot2::geom_density(
    data = df,
    ggplot2::aes(
      x = nltt_stat,
      fill = scr
    )
    , alpha = 0.5
  )

  #Rampal wondered if this is caused by DNA sequence length.
  #Here is short:

  ggplot2::ggplot(
  ) + ggplot2::facet_grid(siri ~ erg
  ) + ggplot2::geom_density(
    data = df[df$sequence_length == 1000, ],
    ggplot2::aes(
      x = nltt_stat,
      fill = scr
    )
    , alpha = 0.5
  )
  # Short has bumps.

  # Here is long:

  ggplot2::ggplot(
  ) + ggplot2::facet_grid(siri ~ erg
  ) + ggplot2::geom_density(
    data = df[df$sequence_length == 10000, ],
    ggplot2::aes(
      x = nltt_stat,
      fill = scr
    )
    , alpha = 0.5
  )

  # Long has bumps.
  #
  # I predict it has to do with short trees.
  #
  # Here I show the number of taxa in the simulated trees,
  # for different speciation initiation rates, first as a histogram:


  ggplot2::ggplot(
      df,
      ggplot2::aes(n_taxa, fill = siri)
  ) + ggplot2::geom_histogram()

  # here as a density plot:
  ggplot2::ggplot(
      df,
      ggplot2::aes(n_taxa, fill = siri)
  ) + ggplot2::geom_density()

  # Or fancier, in a facet grid, as a histogram:

  ggplot2::ggplot(
  ) + ggplot2::facet_grid(siri ~ erg
  ) + ggplot2::geom_histogram(
    data = df,
    ggplot2::aes(
      n_taxa,
      fill = scr
    )
    , alpha = 0.5
  )
  # Or even fancier, in a facet grid, as a density plots:
  ggplot2::ggplot(
  ) + ggplot2::facet_grid(siri ~ erg
  ) + ggplot2::geom_density(
    data = df,
    ggplot2::aes(
      n_taxa,
      fill = scr
    )
    , alpha = 0.5
  )

  ggplot2::ggplot(
  ) + ggplot2::facet_grid(siri ~ erg
  ) + ggplot2::geom_density(
    data = df[df$sequence_length == 10000, ],
    ggplot2::aes(
      x = nltt_stat,
      fill = scr
    )
    , alpha = 0.5
  )

  # Zoom in on the bumps, focus on DNA sequence information:
  df_zoom <- df[df$sirg == 0.5 & df$eri == 0.0 ,]
  ggplot2::ggplot(
  ) + ggplot2::facet_grid(sequence_length ~ mutation_rate
  ) + ggplot2::geom_density(
    data = df_zoom,
    ggplot2::aes(
      x = nltt_stat,
      fill = scr
    )
    , alpha = 0.5
  )

  # Rescale this to a density of 100:
  ggplot2::ggplot(
  ) + ggplot2::facet_grid(sequence_length ~ mutation_rate
  ) + ggplot2::geom_density(
    data = df_zoom,
    ggplot2::aes(
      x = nltt_stat,
      fill = scr
    )
    , alpha = 0.5
  ) + ggplot2::scale_y_continuous(limits = c(0, 100))

    # Plot the number of taxa versus error:

  ggplot2::ggplot(
      df_zoom,
      ggplot2::aes(x = n_taxa, y = nltt_stat)
  ) + ggplot2::geom_point(
  ) + ggplot2::geom_smooth(method = "lm")


  # Plot the number of taxa versus error, seperated by SCR:
  ggplot2::ggplot(
      df_zoom,
      ggplot2::aes(x = n_taxa, y = nltt_stat, color = scr)
  ) + ggplot2::geom_point(
  ) + ggplot2::geom_smooth(method = "lm")


  # For all data:
  ggplot2::ggplot(
      df,
      ggplot2::aes(x = n_taxa, y = nltt_stat, color = scr)
  ) + ggplot2::geom_point(
  ) + ggplot2::geom_smooth(method = "lm")

  # Zoom in on mutation rate and DNA alignment length
  names(df_zoom)
  df_zoom_zoom <- df_zoom[
    df_zoom$mutation_rate == 0.1 & df_zoom$sequence_length == 10000 & df_zoom$scr == 1e+06,
  ]

  ggplot2::ggplot(
      df_zoom_zoom,
      ggplot2::aes(nltt_stat, fill = sti)
  ) + ggplot2::geom_density(alpha = 0.5
  ) + ggplot2::scale_y_continuous(limits = c(0, 100))

  ggplot2::ggplot(
  ) + ggplot2::facet_grid(sti ~ ai
  ) + ggplot2::geom_density(
    data = df_zoom_zoom,
    ggplot2::aes(
      x = nltt_stat,
      fill = pi
    )
    , alpha = 0.5
  ) + ggplot2::scale_y_continuous(limits = c(0, 100))


  ggplot2::ggplot(
      df_zoom_zoom,
      ggplot2::aes(x = n_taxa, y = nltt_stat)
  ) + ggplot2::geom_point(
  ) + ggplot2::geom_smooth(method = "lm")

}