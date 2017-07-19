# Quantification of the error BEAST2 makes on BD trees
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
  stop(
    "File '", parameters_filename, "' not found, ",
    "please run analyse_parameters"
  )
}

if (!file.exists(nltt_stats_filename)) {
  stop("File '", nltt_stats_filename, "' not found, ",
    "please run analyse_nltt_stats")
}

print("Read parameters and nLTT stats")
parameters <- wiritttea::read_collected_parameters(parameters_filename)
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename)

print("Take the mean of the nLTT stats")
library(dplyr)
nltt_stat_means <- nltt_stats %>% group_by(filename, sti, ai, pi) %>%
       summarise(mean=mean(nltt_stat), sd=sd(nltt_stat))
testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "ai", "pi", "mean", "sd")))
head(nltt_stat_means, n = 10)
nrow(nltt_stat_means)

print("Prepare parameters for merge")
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)

print("Connect the mean nLTT stats and parameters")
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stat_means))
df <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)
names(df)
head(df, n = 10)

print("Only keep rows with the highest SCR (as those are a BD model)")
print(paste0("Rows before: ", nrow(df)))
dplyr::count(df, scr)
scr_bd <- max(na.omit(df$scr))
df <- df[ df$scr == scr_bd, ]
print(paste0("Rows after: ", nrow(df)))

print("Creating figure 110")

#svg("~/figure_110.svg")
png("~/figure_110.png")
ggplot2::ggplot(
  data = na.omit(df), na.rm = TRUE,
  ggplot2::aes(x = 1, y = mean)
) +
  ggplot2::geom_boxplot() +
  ggplot2::facet_grid(erg ~ sirg) +
  ggplot2::scale_x_discrete("") +
  ggplot2::scale_y_continuous("Mean nLTT statistic") +
  ggplot2::ggtitle("Mean nLTT statistics\nfor different extinction (columns)\nand speciation inition rates (rows)") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()
