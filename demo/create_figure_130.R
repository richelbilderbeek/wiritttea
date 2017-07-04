# Create figure 130
library(wiritttea)
options(warn = 2) # Be strict
path_data <- "~/GitHubs/Peregrine20170710"
nltt_stats_filename <- "~/wirittte_data/nltt_stats_20170710.csv"
parameters_filename <- "~/GitHubs/wirittte_data/parameters_20170710.csv"

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
parameters$mean_durspec <- PBD::pbd_mean_durspecs(
  eris = parameters$eri,
  scrs = parameters$scr,
  siris = parameters$siri
)

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

# Calculate mean BD error
scr_bd <- max(na.omit(df$scr))
mean_bd_error <- mean(na.omit(df[ df$scr == scr_bd, ]$mean))


print("Creating figure 130")

svg("~/figure130.svg")
ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(x = mean_durspec, y = mean)
) + ggplot2::geom_point() +
    ggplot2::xlab("Mean duration of speciation (million years)") +
    ggplot2::ylab("Mean nLTT statistic") +
    ggplot2::geom_hline(yintercept = mean_bd_error, linetype = "dotted") +
    ggplot2::ggtitle("Mean nLTT statistic for different duration of speciations") +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()