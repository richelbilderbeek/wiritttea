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

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
# From http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
print("Read parameters")
parameters <- wiritttea::read_collected_parameters(parameters_filename)

print("Select all Birth-Death parameters")
bd_parameters <- parameters[ parameters$scr == max(parameters$scr) & parameters$erg > 0.0, ]
head(bd_parameters)

set.seed(10)
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
p
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

some_values <- dplyr::sample_n(df, size = 5)


print("Convert to long form")
df <- reshape2::melt(df, measure.vars = names(df))
head(df)

print("Plot the variables individually")



p1 <- ggplot2::ggplot(
  df[ df$variable == "BirthDeath", ],
  ggplot2::aes(x = value)
) +
  ggplot2::geom_histogram(bins = 1000) +
  ggplot2::labs(
    title = "BirthDeath distribution",
    caption = paste0(filename, ", figure_posterior_distribution_bd_bd")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

p2 <- ggplot2::ggplot(
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

p2

p3 <- ggplot2::ggplot(
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

p3

p4 <- ggplot2::ggplot(
  df[ df$variable == "TreeHeight", ],
  ggplot2::aes(x = value)
) +
  ggplot2::geom_histogram(bins = 1000) +
  ggplot2::labs(
    title = "TreeHeight distribution",
    caption = paste0(filename, ", figure_posterior_distribution_bd_th")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

p4

p5 <- ggplot2::ggplot(
  df,
  ggplot2::aes(x = value)
) +
  ggplot2::geom_histogram(bins = 100) +
  ggplot2::facet_wrap(~variable, ncol = 4, nrow = 1, shrink = TRUE, scales = "free") +
  ggplot2::labs(
    title = "Distributions of estimated BD parameters",
    caption = paste0(filename, ", figure_posterior_distribution_bd_all")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
p5



svg("~/figure_posterior_distribution_bd_bd.svg")
p1
dev.off()
svg("~/figure_posterior_distribution_bd_br2.svg")
p2
dev.off()
svg("~/figure_posterior_distribution_bd_rdr2.svg")
p3
dev.off()
svg("~/figure_posterior_distribution_bd_all.svg")
p4
dev.off()




