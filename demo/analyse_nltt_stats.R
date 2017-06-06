## Abstract
# This vignette shows how analyse the nLTT statistics.

# I use this to check if `rJava` is installed correctly. 
# If not, this will give an error:

options(warn = 2)

library(wiritttes)
library(wiritttea)

file <- wiritttes::read_file(
  wiritttea::find_path("toy_example_1.RDa")
)
p <- wiritttes::get_posterior(file, sti = 1, ai = 1, pi = 1)

is_local_computer <- function()
{
  local_computer_names <- c(
    "fwn-biol-132-102", 
    "pc-157-103", 
    "pc-157-104", 
    "lubuntu")
  return (sum(Sys.info()["nodename"] == local_computer_names) == 1)
}

is_local_computer()

## Setup

# Loading this package

if (is_local_computer()) {
  # Read parameters
  parameters <- wiritttea::read_collected_parameters(
    "~/Peregrine/collect_files_parameters.csv"
  )
  
  # Read nLTT stats
  nltt_stats_raw <- wiritttea::read_collected_nltt_stats("~/Peregrine/collect_files_nltt_stats.csv")

  n_taxa <- wiritttea::read_collected_n_taxa("~/Peregrine/collect_files_n_taxa.csv")

  # No NA's in my dataset please
  nltt_stats <- nltt_stats_raw[!is.na(nltt_stats_raw$nltt_stat), ]
  
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
}

## Show the distribution of nLTT statistics

# Here we have the bumps:

if (is_local_computer()) {
  
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
}

#Rampal wondered if this is caused by DNA sequence length. 
#Here is short:

if (is_local_computer()) {
  
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

}

# Short has bumps.

# Here is long:

if (is_local_computer()) {
  
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

}

# Long has bumps.
#
# I predict it has to do with short trees. 
#
# Here I show the number of taxa in the simulated trees,
# for different speciation initiation rates, first as a histogram:

if (is_local_computer()) {

  ggplot2::ggplot(
      df, 
      ggplot2::aes(n_taxa, fill = siri)
  ) + ggplot2::geom_histogram()
}

# here as a density plot:

if (is_local_computer()) {

  ggplot2::ggplot(
      df, 
      ggplot2::aes(n_taxa, fill = siri)
  ) + ggplot2::geom_density()
}

# Or fancier, in a facet grid, as a histogram:

if (is_local_computer()) {

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
}

# Or even fancier, in a facet grid, as a density plots:

if (is_local_computer()) {

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
}

if (is_local_computer()) {
  
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

}

# Zoom in on the bumps, focus on DNA sequence information:

if (is_local_computer()) {
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

}

# Rescale this to a density of 100:

if (is_local_computer()) {
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

}

# Plot the number of taxa versus error:

if (is_local_computer()) {

  ggplot2::ggplot(
      df_zoom, 
      ggplot2::aes(x = n_taxa, y = nltt_stat)
  ) + ggplot2::geom_point(
  ) + ggplot2::geom_smooth(method = "lm")
  

}

# Plot the number of taxa versus error, seperated by SCR:

if (is_local_computer()) {

  ggplot2::ggplot(
      df_zoom, 
      ggplot2::aes(x = n_taxa, y = nltt_stat, color = scr)
  ) + ggplot2::geom_point(
  ) + ggplot2::geom_smooth(method = "lm")
  

}

# For all data:

if (is_local_computer()) {

  ggplot2::ggplot(
      df, 
      ggplot2::aes(x = n_taxa, y = nltt_stat, color = scr)
  ) + ggplot2::geom_point(
  ) + ggplot2::geom_smooth(method = "lm")
  

}

# Zoom in on mutation rate and DNA alignment length

if (is_local_computer()) {
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
