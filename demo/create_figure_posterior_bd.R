# Create 'figure_posterior_distributions_bd'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
parameters_filename <- paste0("~/GitHubs/wirittte_data/parameters_", date, ".csv")
raw_data_path <- paste0("~/wirittte_data/", date, "/")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) parameters_filename <- args[1]

print(paste("parameters_filename:", parameters_filename))

if (!file.exists(parameters_filename)) {
  stop("File '", parameters_filename, "' not found, ",
    "please run analyse_parameters")
}

print("Read parameters")
parameters <- wiritttea::read_collected_parameters(parameters_filename)

print("Select all Birth-Death parameters")
bd_parameters <- parameters[ parameters$scr == max(parameters$scr) & parameters$erg > 0.0, ]
head(bd_parameters)

posterior <- NA
filename <- NA

while (length(posterior) < 2) {

  print("Pick random filename")
  filename_short <- rownames(dplyr::sample_n(bd_parameters, size = 1))
  print(paste0("Picked '", filename_short, "'"))
  filename <- paste0(raw_data_path, filename_short)
  testit::assert(file.exists(filename))

  print("Get posterior of that filename (if fails, try again)")
  tryCatch( {
    posterior <- wiritttes::get_posterior(
      wiritttes::read_file(filename), sti = 1, ai = 1, pi = 1)
    },
      error = function(cond) {}
  )
}

print(paste0("File '", filename, "' has a good posterior"))
p <- parameters[ rownames(parameters) == basename(filename), ]

# If a range goes from [0, crownTreeHeight], multiply it by
# 'tree_scale' to let it go from [0, crown_age]
tree_scale <- p$age / median(posterior$estimates$TreeHeight)

# BirthDeath
# * Unknown meaning
# * Called 'rho' in BEAST2

#  birthRate2:
# * called 'r' in BEAST2
# * birth rate - death rate
real_birthRate2 <- (p$sirg - p$erg) * tree_scale

# Crown age, called 'TreeHeight' in BEAST2
real_TreeHeight <- p$age


# relativeDeathRate2:
# * mu / lambda
# * birth rate/death rate ratio
# * as mu < lambda, has range [0,1]
# * called 'a' in BEAST2
real_relativeDeathRate2 <- p$erg / p$sirg


# realtiveDeathRate = GL: mu / lambda

print("Extract values to be plotted: 'BirthDeath', 'birthRate2', 'relativeDeathRate2'")
df <- dplyr::select(posterior$estimates, c("BirthDeath", "birthRate2", "relativeDeathRate2", "TreeHeight"))

print("Convert to long form")
df <- reshape2::melt(df, measure.vars = names(df))
head(df)

print("Plot the variables individually")

svg("~/figure_posterior_distribution_bd_bd.svg")
ggplot2::ggplot(
  df[ df$variable == "BirthDeath", ],
  ggplot2::aes(x = value)
) +
  ggplot2::geom_histogram(bins = 1000) +
  ggplot2::labs(
    title = "BirthDeath distribution",
    caption = paste0(filename, ", figure_posterior_distribution_bd_bd")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()


svg("~/figure_posterior_distribution_bd_br2.svg")
ggplot2::ggplot(
  df[ df$variable == "birthRate2", ],
  ggplot2::aes(x = value)
) +
  ggplot2::geom_histogram(bins = 100) +
  ggplot2::geom_vline(xintercept = real_birthRate2, linetype = "dotted") +
  ggplot2::labs(
    title = "birthRate2 distribution",
    caption = paste0(filename, ", figure_posterior_distribution_bd_br2")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

svg("~/figure_posterior_distribution_bd_rdr2.svg")
ggplot2::ggplot(
  df[ df$variable == "relativeDeathRate2", ],
  ggplot2::aes(x = value)
) +
  ggplot2::geom_histogram(bins = 100) +
  ggplot2::geom_vline(xintercept = real_relativeDeathRate2, linetype = "dotted") +
  ggplot2::labs(
    title = "relativeDeathRate2 distribution",
    caption = paste0(filename, ", figure_posterior_distribution_bd_rdr2")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

print("Plot all the variables")
svg("~/figure_posterior_distribution_bd_all.svg")
ggplot2::ggplot(
  df,
  ggplot2::aes(x = value)
) +
  ggplot2::geom_histogram(bins = 100) +
  ggplot2::facet_wrap(~variable, ncol = 4, nrow = 1, shrink = TRUE, scales = "free") +
  ggplot2::labs(
    title = "Distributions of estimated BD parameters",
    caption = paste0(filename, ", figure_posterior_distribution_bd")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()