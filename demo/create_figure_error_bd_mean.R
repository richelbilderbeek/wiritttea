# Create 'figure_error_bd_mean'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
nltt_stats_filename <- paste0("~/wirittte_data/nltt_stats_", date, ".csv")
parameters_filename <- paste0("~/GitHubs/wirittte_data/parameters_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) nltt_stats_filename <- args[1]
if (length(args) > 1) parameters_filename <- args[2]

print(paste("nltt_stats_filename:", nltt_stats_filename))
print(paste("parameters_filename:", parameters_filename))

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
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename, burn_in_fraction = 0.2)

print("Take the mean of the nLTT stats")
`%>%` <- dplyr::`%>%`
nltt_stat_means <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
       summarise(mean=mean(nltt_stat), sd=sd(nltt_stat))
testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "ai", "pi", "mean", "sd")))
head(nltt_stat_means, n = 10)
nrow(nltt_stat_means)

# print("Prepare parameters for merge")
# parameters$filename <- row.names(parameters)
# parameters$filename <- as.factor(parameters$filename)

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

print("Creating figure")

svg("~/figure_error_bd_mean.svg")
ggplot2::ggplot(
  data = stats::na.omit(df),
  ggplot2::aes(x = mean)
) +
  ggplot2::geom_histogram(binwidth = 0.001) +
  ggplot2::facet_grid(erg ~ sirg) +
  ggplot2::scale_x_continuous("Mean nLTT statistic") +
  ggplot2::scale_y_continuous("Count") +
  ggplot2::ggtitle("Mean nLTT statistics\nfor different extinction (columns)\nand speciation inition rates (rows)") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()
