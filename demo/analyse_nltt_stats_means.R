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
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename, burn_in_fraction = 0.2)

# Add mean duration of speciation to parameters
parameters$mean_durspec <- PBD::pbd_mean_durspecs(
  eris = parameters$eri,
  scrs = parameters$scr,
  siris = parameters$siri
)

# How evenly is the mean duration of speciation spaced?
ggplot2::ggplot(
  data = parameters,
  ggplot2::aes(x = mean_durspec)) +
  ggplot2::geom_histogram(bins = 300) +
  ggplot2::ggtitle("Distribution of mean duration of speciation")

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

# Create x = sirg, y = erg surface plots for z = mean
# for different values of scr
# Nice jitter
ggplot2::ggplot(
  data = stats::na.omit(df),
  ggplot2::aes(x = sirg, y = erg, color = mean)
) + ggplot2::geom_jitter()


ggplot2::ggplot(
  data = stats::na.omit(df),
  ggplot2::aes(x = sirg, y = erg, col = mean)
) + ggplot2::facet_grid(scr ~ .) + ggplot2::geom_jitter()




# Create non-linear model
if (1 == 2) {
  df[is.finite(df$mean), ]
  df_clean <- stats::na.omit(df[is.finite(df$mean) | is.finite(df$erg) | is.finite(df$scr) | is.finite(df$siri), ])
  df_clean$mean[ is.infinite(df_clean$mean) ]
  df_clean$mean[ is.na(df_clean$mean) ]
  model <- nls(
    mean ~ erg + scr + siri, data = df_clean,
    start = c(
      mean = 1.0,
      erg = min(df_clean$erg),
      scr = min(df_clean$scr),
      siri = min(df_clean$siri)
    )
  )
  View(df_clean)
  sum(is.na(stats::na.omit(df)))
  is.nan(df)
  Inf

  par(mfrow=c(2,2))
  plot(model)

  # View influences
  influence.measures(model)

  influential_indices <- influence.measures(model)$is.inf
  non_influential_indices <- !influential_indices

  length(influential_indices)
  length(non_influential_indices)
  sum(influential_indices)
  df_ni <- df[ influential_indices, ]
  nrow(df)
  nrow(df_ni)

  model_2 <- lm(
    mean ~
    erg +
    scr +
    siri, data = stats::na.omit(df_ni))
  names(model_2)
  length(model$fitted.values)
  length(model_2$fitted.values)

  par(mfrow=c(2,2))
  plot(model_2)
}

# Create linear model
if (1 == 2) {

  model <- lm(mean ~ erg + scr + siri, data = df)
  par(mfrow=c(2,2))
  plot(model)

  # View influences
  influence.measures(model)

  influential_indices <- influence.measures(model)$is.inf
  non_influential_indices <- !influential_indices

  length(influential_indices)
  length(non_influential_indices)
  sum(influential_indices)
  df_ni <- df[ influential_indices, ]
  nrow(df)
  nrow(df_ni)

  model_2 <- lm(
    mean ~
    erg +
    scr +
    siri, data = stats::na.omit(df_ni))
  names(model_2)
  length(model$fitted.values)
  length(model_2$fitted.values)

  par(mfrow=c(2,2))
  plot(model_2)
}


# Interesting plot
if (1 == 2) {
  plot3D::scatter3D(
    x = df$mean_durspec, xlab = "Mean duration of speciation",
    y = df$erg, ylab = "Extinction rate",
    z = df$mean, zlab = "Mean nLTT statistic"
  )
  names(df)
  nltt_stat_per_spec_dur <- stats::na.omit(stats::na.omit(df) %>%
      group_by(erg, mean_durspec) %>%
         summarise(mean=mean(mean)))
  plot3D::scatter3D(
    x = nltt_stat_per_spec_dur$mean_durspec, xlab = "Mean duration of speciation",
    y = nltt_stat_per_spec_dur$erg, ylab = "Extinction rate",
    z = nltt_stat_per_spec_dur$mean, zlab = "Mean nLTT statistic"
  )
  s <- akima::interp(
    x = nltt_stat_per_spec_dur$mean_durspec,
    y = nltt_stat_per_spec_dur$erg,
    z = nltt_stat_per_spec_dur$mean,
    nx = 20, ny = 20
  )
  image(s,
    xlab = "Mean duration of speciation",
    ylab = "Extinction rate",
    main = "Mean nLTT statistic"
  )
  contour(s,
    xlab = "Mean duration of speciation",
    ylab = "Extinction rate",
    main = "Mean nLTT statistic",
    add = TRUE
  )
  persp(s,
    xlab = "Mean duration of speciation",
    ylab = "Extinction rate",
    zlab = "Mean nLTT statistic"
  )
  rgl::persp3d(
    x = s$x,
    y = s$y,
    z = s$z,
    col = s$z,
    xlab = "Mean duration of speciation",
    ylab = "Extinction rate",
    zlab = "Mean nLTT statistic"
  )

  rgl::surface3d(s$x,s$y,s$z)

  plotly::plot_ly(
    data = nltt_stat_per_spec_dur,
    x = ~mean_durspec,
    y = ~erg,
    z = ~mean,
    type = "scatter3d",
    mode = "markers"
  )

  # m <- plot3D::mesh(
  #   x = nltt_stat_per_spec_dur$mean_durspec, #xlab = "Mean duration of speciation",
  #   y = nltt_stat_per_spec_dur$erg, #ylab = "Extinction rate",
  #   z = nltt_stat_per_spec_dur$mean #, zlab = "Mean nLTT statistic"
  # )
  # names(m)
  # plot3D::scatter3D(x = m$x, y = m$y, z = m$z)
}

if (1 == 2) {




  plot3D::scatter3D(
    x = df$scr, xlab = "Speciation completion rate",
    #x = df$mean_durspec, xlab = "Mean duration of speciation",
    #y = df$erg, ylab = "Extinction rate",
    #y = df$scr, ylab = "Speciation completion rate",
    y = df$siri, ylab = "Speciation initiation rate",
    z = df$mean, zlab = "Mean nLTT statistic"
  )

  lattice::wireframe(
    mean ~ mean_durspec + erg, data = stats::na.omit(df),
    drape = TRUE,
    colorkey = TRUE
  )

  #
  ggplot2::ggplot(
    data = stats::na.omit(df),
    ggplot2::aes(x = mean_durspec, y = mean)
  ) + ggplot2::geom_point() +
      ggplot2::xlab("Mean duration of speciation") +
      ggplot2::ylab("Mean nLTT statistic")

  mean_durspecs <- count(df, mean_durspec)
  print(mean_durspecs)

  ggplot2::ggplot(
  ) + ggplot2::facet_grid(mean_durspec ~ erg
  ) + ggplot2::geom_density(
    data = na.omit(df),
    ggplot2::aes(
      x = mean,
      fill = scr
    )
    , alpha = 0.5
  )
}

# Investigate mean duration of speciation
if (1 == 2) {


  df <- expand.grid(
    lambda_2 = seq(0.1, 1.0, 0.1),
    lambda_3 = seq(0.1, 1.0, 0.1),
    mu_2 = seq(0.1, 1.0, 0.1)
  )
  df$mean_durspec <- rep(NA, nrow(df))

  for (i in seq_along(df$mean_durspec)) {
    df$mean_durspec[i] <- PBD::pbd_mean_durspec(
      df$lambda_2[i], df$lambda_3[i], df$mu_2[i])
  }

  plotly::plot_ly(
    data = df,
    x = ~lambda_2,
    y = ~lambda_3,
    z = ~mu_2,
    color = ~mean_durspec,
    type = "scatter3d",
    mode = "markers"
  )


  plot3D::scatter3D(x = df$lambda_2, y = df$lambda_3, z = df$mu_2, col = df$mean_durspec)

  lattice::wireframe(
    mean_durspec ~ lambda_2 + lambda_3 + mu_2, data = na.omit(df),
    drape = TRUE,
    colorkey = TRUE
  )

  lattice::wireframe(
    mean ~ mean_durspec + erg, data = na.omit(df),
    drape = TRUE,
    colorkey = TRUE
  )

}

if (1 == 2) {

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
