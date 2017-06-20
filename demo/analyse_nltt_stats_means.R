# Analyse the nLTT stats
library(wiritttea)
options(warn = 2) # Be strict
path_data <- "~/GitHubs/Peregrine20170710"
nltt_stats_filename <- "~/wirittte_data/nltt_stats_20170710.csv"
parameters_filename <- "~/wirittte_data/parameters_20170710.csv"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) nltt_stats_filename <- args[2]
if (length(args) > 2) parameters_filename <- args[3]

print(paste("path_data:", path_data))
print(paste("nltt_stats_filename:", nltt_stats_filename))

if (!file.exists(parameters_filename)) {
  stop("Please run analyse_parameters")
}

if (!file.exists(nltt_stats_filename)) {
  stop("Please run analyse_nltt_stats")
}

# Read parameters and nLTT stats
parameters <- wiritttea::read_collected_parameters(parameters_filename)
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename)

# Add mean duration of speciation to parameters
parameters$mean_durspec <- rep(NA, nrow(parameters))

for (i in seq_along(parameters$mean_durspec)) {
  tryCatch({
    parameters$mean_durspec[i] <- PBD::pbd_mean_durspec(
    lambda_2 = parameters$scr[i],
    lambda_3 = parameters$siri[i],
    mu_2 = parameters$eri[i]
  )
  }, error = function(cond) {} # nolint
  )
}

# Take the mean of the nLTT stats
library(dplyr)
nltt_stat_means <- nltt_stats %>% group_by(filename, sti, ai, pi) %>%
       summarise(mean=mean(nltt_stat), sd=sd(nltt_stat))
testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "ai", "pi", "mean", "sd")))
head(nltt_stat_means, n = 10)
nrow(nltt_stat_means)

# Prepare parameters for merge
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stat_means))
df <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)
names(df)
head(df, n = 10)

summary(lm(mean ~ sirg + scr + erg, data = df))
anova(lm(mean ~ sirg + scr + erg, data = df))
plot(lm(mean ~ sirg + scr + erg, data = df))

lattice::wireframe(
  mean ~ sirg + scr, data = na.omit(df),
  drape = TRUE,
  colorkey = TRUE
)

#
ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(x = mean_durspec, y = mean)
) + ggplot2::geom_point() +
    ggplot2::xlab("Mean duration of speciation") +
    ggplot2::ylab("Mean nLTT statistic")


# Doing a PCA makes no sense
if (1 == 2) {
  # Drop sd for now
  df_pca <- subset(df, select = c(sirg, scr, erg, mean))
  names(df_pca)
  nrow(df_pca)
  print("SIRGs:"); dplyr::tally(group_by(df_pca, sirg))
  print("SCRs:"); dplyr::tally(group_by(df_pca, scr))
  print("ERGs:"); dplyr::tally(group_by(df_pca, erg))
  pca <- stats::princomp( ~ sirg + scr + erg, data = na.omit(df_pca), cor = TRUE)
  summary(pca)
  stats::biplot(pca, main = "Mean nLTT statistic")
  plot(pca)
  names(df)
}

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