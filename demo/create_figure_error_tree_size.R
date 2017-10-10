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
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename, burn_in_fraction = 0.2)
head(n_taxa)
head(nltt_stats)
tail(n_taxa)
tail(nltt_stats)

testit::assert(basename("/home/p230198/Peregrine20170710/article_0_3_1_0_1_521.RDa") == "article_0_3_1_0_1_521.RDa")
testit::assert(basename("article_0_3_1_0_1_521.RDa") == "article_0_3_1_0_1_521.RDa")
nltt_stats$filename <- as.vector(nltt_stats$filename)
nltt_stats$filename <- basename(nltt_stats$filename)

# Take the mean of the nLTT stats
`%>%` <- dplyr::`%>%`
nltt_stat_means <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
       dplyr::summarise(mean = mean(nltt_stat), sd = sd(nltt_stat))
testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "ai", "pi", "mean", "sd")))
head(nltt_stat_means, n = 10)
nrow(nltt_stat_means)

# Connect the mean nLTT stats and n_taxa
testit::assert("filename" %in% names(n_taxa))
testit::assert("filename" %in% names(nltt_stat_means))
df_mean <- merge(x = nltt_stat_means, y = n_taxa, by = "filename", all = TRUE)
df <- merge(x = nltt_stats, y = n_taxa, by = "filename", all = TRUE)
n_all <- nrow(df)
df <- stats::na.omit(df)
names(df_mean)
head(df_mean, n = 10)
tail(df_mean, n = 10)

print("Creating figure")

svg("~/figure_error_tree_size.svg")
n <- 2000
cut_x <- 2000
cut_y <- 0.125
set.seed(42)

options(warn = 1) # Be milder for ylim

ggplot2::ggplot(
  data = dplyr::sample_n(df, size = n),
  ggplot2::aes(x = n_taxa, y = nltt_stat)
) + ggplot2::geom_point(alpha = 0.1) +
  ggplot2::geom_smooth(method = "lm", color = "blue", size = 0.5, alpha = 0.25) +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" $n_t$"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    color = "blue",
    parse = TRUE) +
  ggplot2::geom_smooth(method = "loess", color = "red", size = 0.5, alpha = 0.25) +
  ggplot2::ylim(c(0, cut_y)) +
  ggplot2::xlab(latex2exp::TeX("$n_t$")) +
  ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
  ggplot2::labs(
    title = "The effect of number of taxa on nLTT statistic",
    caption  = paste0("(n = ", n, "/", n_all, "), error_tree_size")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

svg("~/figure_error_tree_size_mean.svg")
ggplot2::ggplot(
  data = stats::na.omit(df_mean),
  ggplot2::aes(x = n_taxa, y = mean)
) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm", color = "blue", size = 0.5, alpha = 0.25) +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" $n_t$"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    color = "blue",
    parse = TRUE) +
  ggplot2::geom_smooth(method = "loess", color = "red", size = 0.5, alpha = 0.25) +
  ggplot2::ylim(c(0, cut_y)) +
  ggplot2::xlab(latex2exp::TeX("$n_t$")) +
  ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
  ggplot2::labs(
    title = "The effect of number of taxa on mean nLTT statistic",
    caption  = "Figure 'error_tree_size_mean'"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

