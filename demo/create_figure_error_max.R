# Create 'figure_error_max', showing phylogenies with the top 10 biggest nLTT statistics error
# of all simulations
library(wiritttea)
options(warn = 2) # Be strict
date <- "stub"
raw_data_path <- "~/wirittte_data/"
nltt_stats_filename <- paste0(raw_data_path, "nltt_stats_", date, ".csv")
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

print("Read parameters")
parameters <- wiritttea::read_collected_parameters(parameters_filename)
names(parameters)


print("Add mean duration of speciation to parameters")
parameters$mean_durspec <- PBD::pbd_mean_durspecs(
  eris = parameters$eri,
  scrs = parameters$scr,
  siris = parameters$siri
)

print("Prepare parameters for merge")
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)
parameters <- subset(parameters, select = c(filename, mean_durspec) )

print("Read nLTT stats, with burn-in")
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename,
  burn_in_fraction = 0.0)
head(nltt_stats)

svg("~/figure_error_posterior_nltt_si.svg")
ggplot2::ggplot(
  dplyr::sample_n(na.omit(nltt_stats), size = 100000),
  ggplot2::aes(x = as.numeric(si), y = nltt_stat)) +
  ggplot2::geom_point(alpha = 0.01) +
  ggplot2::geom_smooth(method = "lm") +
  ggplot2::geom_vline(xintercept = 100, linetype = "dotted") +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" si"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    color = "black",
    parse = TRUE) +
  ggplot2::xlab(latex2exp::TeX("posterior state index, $s_i$")) +
  ggplot2::ylab(latex2exp::TeX("nLTT statistic $\\Delta_{nLTT}$")) +
  ggplot2::labs(
    title = "nLTT statistic values in a posterior",
    caption = "figure_error_posterior_nltt_si"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()


svg("~/figure_error_posterior_nltt_si_early.svg")
early_nltt_stats <- stats::na.omit(nltt_stats)
early_nltt_stats <- early_nltt_stats[ as.numeric(early_nltt_stats$si) < 100, ]
ggplot2::ggplot(
  dplyr::sample_n(early_nltt_stats, size = 10000),
  ggplot2::aes(x = as.numeric(si), y = nltt_stat)) +
  ggplot2::geom_point(alpha = 0.01) +
  ggplot2::geom_smooth(method = "lm") +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" si"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    color = "black",
    parse = TRUE) +
  ggplot2::xlab(latex2exp::TeX("posterior state index, $s_i$")) +
  ggplot2::ylab(latex2exp::TeX("nLTT statistic $\\Delta_{nLTT}$")) +
  ggplot2::labs(
    title = "nLTT statistic values in a posterior",
    caption = "figure_error_posterior_nltt_si_early"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

svg("~/figure_error_posterior_nltt_si_late.svg")
late_nltt_stats <- stats::na.omit(nltt_stats)
late_nltt_stats <- late_nltt_stats[ as.numeric(late_nltt_stats$si) >= 100, ]
ggplot2::ggplot(
  dplyr::sample_n(late_nltt_stats, size = 100000),
  ggplot2::aes(x = as.numeric(si), y = nltt_stat)) +
  ggplot2::geom_point(alpha = 0.01) +
  ggplot2::geom_smooth(method = "lm") +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" si"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    color = "black",
    parse = TRUE) +
  ggplot2::xlab(latex2exp::TeX("posterior state index, $s_i$")) +
  ggplot2::ylab(latex2exp::TeX("nLTT statistic $\\Delta_{nLTT}$")) +
  ggplot2::labs(
    title = "nLTT statistic values in a posterior",
    caption = "figure_error_posterior_nltt_si_early"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()



print("Read nLTT stats, without burn-in")
nltt_stats <- wiritttea::read_collected_nltt_stats(
  nltt_stats_filename,
  burn_in_fraction = 0.2)
head(nltt_stats)
tail(nltt_stats)

print("Order by nltt_stat, highest value first")
df <- stats::na.omit(nltt_stats[with(nltt_stats, order(-nltt_stat)), ])
head(df)
filenames <- unique(head(df, 1000)$filename)

file <- wiritttes::read_file(paste0(raw_data_path, date, "/", df$filename[1]))

posterior_stree <- wiritttes::get_posterior_tree(
  file = file,
  sti = as.numeric(df$sti[1]),
  ai = as.numeric(df$ai[1]),
  pi = as.numeric(df$pi[1]),
  si = as.numeric(df$si[1])
)

stree <- wiritttes::get_species_tree_by_index(
  file = file,
  sti = as.numeric(df$sti[1])
)

svg("~/figure_error_posterior_nltt_bad_post_tree.svg")
ape::plot.phylo(main = "posterior tree", posterior_stree, show.tip.label = FALSE)
dev.off()

svg("~/figure_error_posterior_nltt_bad_stree.svg")
ape::plot.phylo(main = "original species tree", stree, show.tip.label = FALSE)
dev.off()

RBeast::remove_burn_in
plot(head(df$si, 100))
head(df)
tail(df)
tail(sort(na.omit(nltt_stats$nltt_stat)), 5)

print("Prepare nLTT stats for merge")
nltt_stats <- subset(nltt_stats, select = c(filename, nltt_stat) )
head(nltt_stats)

print("Connect the nLTT stats and parameters")
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stats))
df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)
names(df)
head(df, n = 10)

df <- stats::na.omit(df)

my_colors <- hsv(scales::rescale(sort(unique(df$mean_durspec)), to = c(0.0, 5.0 / 6.0)))

print("Creating figures")

cut_x <- 0.05 # nLTT statistic value at which head and teail are seperated

svg("~/figure_error.svg")
ggplot2::ggplot(
  data = df,
  ggplot2::aes(x = nltt_stat, fill = factor(mean_durspec))
) +
  ggplot2::geom_histogram(binwidth = 0.001) +
  ggplot2::scale_fill_manual(values = my_colors) +
  ggplot2::geom_vline(xintercept = cut_x, linetype = "dotted") +
  ggplot2::labs(
    title = "nLTT statistic distribution",
    x = latex2exp::TeX("nLTT statistic $\\Delta_{nLTT}$"),
    y = "Count",
    caption = "figure_error.svg"
  #) +
  ) + ggplot2::guides(fill = FALSE) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()



svg("~/figure_error_head.svg")
ggplot2::ggplot(
  data = df[df$nltt_stat < 0.05, ],
  ggplot2::aes(x = nltt_stat, fill = factor(mean_durspec))
) +
  ggplot2::geom_histogram(binwidth = 0.001) +
  ggplot2::scale_fill_manual(values = my_colors) +
  ggplot2::geom_vline(xintercept = cut_x, linetype = "dotted") +
  ggplot2::coord_cartesian(xlim = c(0.0, cut_x)) +
  ggplot2::labs(
    title = "nLTT statistic distribution",
    x = latex2exp::TeX("nLTT statistic $\\Delta_{nLTT}$"),
    y = "Count",
    caption = "figure_error_head.svg"
  ) + ggplot2::guides(fill = FALSE) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

svg("~/figure_error_tail.svg")
ggplot2::ggplot(
  data = df[df$nltt_stat > 0.05, ],
  ggplot2::aes(x = nltt_stat, fill = factor(mean_durspec))
) +
  ggplot2::geom_histogram(binwidth = 0.001) +
  ggplot2::scale_fill_manual(values = my_colors) +
  ggplot2::geom_vline(xintercept = cut_x, linetype = "dotted") +
  ggplot2::coord_cartesian(xlim = c(cut_x, 0.35)) +
  ggplot2::labs(
    title = "nLTT statistic distribution",
    x = latex2exp::TeX("nLTT statistic $\\Delta_{nLTT}$"),
    y = "Count",
    caption = "figure_error_tail.svg"
  ) + ggplot2::guides(fill = FALSE) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

