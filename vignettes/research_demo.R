## ------------------------------------------------------------------------
library(wiritttea)
library(ape)
options(warn = 2)

## ------------------------------------------------------------------------
filenames <- paste0("research_demo_", 1:4, ".RDa")

## ------------------------------------------------------------------------
wiritttes::create_test_parameter_files(filenames = filenames)

## ------------------------------------------------------------------------
knitr::kable(collect_files_parameters(filenames = filenames))

## ------------------------------------------------------------------------
for (filename in filenames) {
  wiritttes::add_pbd_output(filename)  
}

## ----fig.width = 7, fig.height = 7---------------------------------------
colors <- stats::setNames(c("gray", "black"), c("i", "g"))

for (filename in filenames) {
  testit::assert(wiritttes::is_valid_file(filename))
  testit::assert(
    length(
      wiritttes::read_file(filename)$pbd_output$igtree.extant$tip.label
    ) > 0
  )
  print(filename)
  phytools::plotSimmap(
    wiritttes::read_file(filename)$pbd_output$igtree.extant, 
    colors = colors
  )
}

## ------------------------------------------------------------------------
for (filename in filenames) {
  wiritttes::add_species_trees(filename)  
}

## ------------------------------------------------------------------------
for (filename in filenames) {
  wiritttes::add_alignments(filename)  
}

## ----fig.width = 7, fig.height = 7---------------------------------------
for (filename in filenames) {
  print(filename)
}

## ----add_posteriors------------------------------------------------------
for (filename in filenames) {
  wiritttes::add_posteriors(filename)
}

## ----fig.width = 7, fig.height = 7---------------------------------------
if (1 == 2) {
  plot_posterior_nltts(filenames[1])
  plot_posterior_nltts(filenames[2])
}

## ----fig.width = 7, fig.height = 7---------------------------------------
if (1 == 2) {
  plot_posterior_nltts(filenames[3])
  plot_posterior_nltts(filenames[4])
}

## ------------------------------------------------------------------------
nltt_stats <- wiritttea::collect_files_nltt_stats(filenames = filenames)
nltt_stats$sti <- plyr::revalue(
  nltt_stats$sti, c("1"="youngest", "2"="oldest"))
knitr::kable(head(nltt_stats))

## ----fig.width = 7, fig.height = 7---------------------------------------
ggplot2::ggplot(
  data = nltt_stats,
  ggplot2::aes(
    x = nltt_stats$filename,
    y = nltt_stats$nltt_stat
  )
) + ggplot2::geom_boxplot(
) + ggplot2::scale_x_discrete(
  name = "Filename"
) + ggplot2::scale_y_continuous(
  name = "nLTT statistic"
) + ggplot2::ggtitle("Distribution of nLTT statistics")


## ----fig.width = 7, fig.height = 7---------------------------------------
ggplot2::ggplot(
  data = nltt_stats,
  ggplot2::aes(
    x = nltt_stats$filename,
    y = nltt_stats$nltt_stat,
    color = nltt_stats$sti
  )
) + ggplot2::geom_boxplot(
) + ggplot2::scale_x_discrete(
  name = "Filename"
) + ggplot2::scale_y_continuous(
  name = "nLTT statistic"
) + ggplot2::ggtitle("Distribution of nLTT statistics")


## ----fig.width = 7, fig.height = 7---------------------------------------
phylogenies_11 <- wiritttes::get_posterior(
  file = wiritttes::read_file(filenames[1]), sti = 1, ai = 1, pi = 1)$trees
phylogenies_12 <- wiritttes::get_posterior(
  file = wiritttes::read_file(filenames[1]), sti = 2, ai = 1, pi = 1)$trees
phylogenies_21 <- wiritttes::get_posterior(
  file = wiritttes::read_file(filenames[2]), sti = 1, ai = 1, pi = 1)$trees
phylogenies_22 <- wiritttes::get_posterior(
  file = wiritttes::read_file(filenames[2]), sti = 2, ai = 1, pi = 1)$trees

class(phylogenies_11) <- "multiPhylo"
class(phylogenies_12) <- "multiPhylo"
class(phylogenies_21) <- "multiPhylo"
class(phylogenies_22) <- "multiPhylo"

phangorn::densiTree(
  phylogenies_11, 
  type = "cladogram", 
  alpha = 1
)

phangorn::densiTree(
  phylogenies_12, 
  type = "cladogram", 
  alpha = 1
)

phangorn::densiTree(
  phylogenies_21, 
  type = "cladogram", 
  alpha = 1
)

phangorn::densiTree(
  phylogenies_22, 
  type = "cladogram", 
  alpha = 1
)

## ------------------------------------------------------------------------
file.remove(filenames)

