# Create figure 'figure_error_tree_size'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
nltt_stats_filename <- paste0("~/wirittte_data/nltt_stats_", date, ".csv")
n_taxa_filename <- paste0("~/GitHubs/wirittte_data/n_taxa_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) nltt_stats_filename <- args[1]
if (length(args) > 1) n_taxa_filename <- args[2]

print(paste("nltt_stats_filename:", nltt_stats_filename))
print(paste("n_taxa_filename:", n_taxa_filename))

if (!file.exists(n_taxa_filename)) {
  stop("Please run analyse_n_taxa")
}

if (!file.exists(nltt_stats_filename)) {
  stop("Please run analyse_nltt_stats")
}

# Read parameters and nLTT stats
n_taxa <- wiritttea::read_collected_n_taxa(n_taxa_filename)
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename)
head(n_taxa)
head(nltt_stats)
tail(n_taxa)
tail(nltt_stats)

testit::assert(basename("/home/p230198/Peregrine20170710/article_0_3_1_0_1_521.RDa") == "article_0_3_1_0_1_521.RDa")
testit::assert(basename("article_0_3_1_0_1_521.RDa") == "article_0_3_1_0_1_521.RDa")
nltt_stats$filename <- as.vector(nltt_stats$filename)
nltt_stats$filename <- basename(nltt_stats$filename)

# Take the mean of the nLTT stats
library(dplyr)
nltt_stat_means <- nltt_stats %>% group_by(filename, sti, ai, pi) %>%
       summarise(mean = mean(nltt_stat), sd = sd(nltt_stat))
testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "ai", "pi", "mean", "sd")))
head(nltt_stat_means, n = 10)
nrow(nltt_stat_means)

# Connect the mean nLTT stats and n_taxa
testit::assert("filename" %in% names(n_taxa))
testit::assert("filename" %in% names(nltt_stat_means))
df <- merge(x = nltt_stat_means, y = n_taxa, by = "filename", all = TRUE)
names(df)
head(df, n = 10)
tail(df, n = 10)

print("Creating figure")

svg("~/figure_error_tree_size.svg")
ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(x = n_taxa, y = mean)
) + ggplot2::geom_point() +
  ggplot2::geom_smooth() +
  ggplot2::xlab("Number of taxa") +
  ggplot2::ylab("Mean nLTT statistic") +
  ggplot2::labs(
    title = "The effect of number of taxa on mean nLTT statistic",
    caption  = "Figure 'error_tree_size'"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()
