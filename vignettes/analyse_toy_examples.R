## ---- message = FALSE----------------------------------------------------
library(ape)
library(wiritttea)
library(ggplot2)
library(Hmisc)
library(nLTT)
library(phangorn)
options(warn = 2)

## ------------------------------------------------------------------------
dt <- 0.001

## ----create_parameter_files----------------------------------------------
filenames <- paste0("analyse_toy_examples_", seq(1, 4), ".RDa")
wiritttes::create_test_parameter_files(filenames = filenames)

## ------------------------------------------------------------------------
knitr::kable(t(head(read_collected_parameters())))

## ------------------------------------------------------------------------
filename <- filenames[1]
testit::assert(wiritttes::is_valid_file(filename))
wiritttes::add_pbd_output(filename)

## ------------------------------------------------------------------------
colors <- stats::setNames(c("gray", "black"), c("i", "g"))
testit::assert(length(wiritttes::read_file(filename)$pbd_output$igtree.extant$tip.label) > 0)
phytools::plotSimmap(
  wiritttes::read_file(filename)$pbd_output$igtree.extant, 
  colors = colors
)
n_taxa_istree <- length(wiritttes::read_file(filename)$pbd_output$igtree.extant$tip.label)

## ------------------------------------------------------------------------
nltt_values <- get_nltt_values(
  phylogenies = list(wiritttes::read_file(filename)$pbd_output$tree), 
  dt = 0.001
)
qplot(
  t, nltt, data = nltt_values, geom = "blank", ylim = c(0,1),
  main = "Example #1"
) + stat_summary(
  fun.data = "mean_cl_boot", color = "red", geom = "smooth"
)

## ------------------------------------------------------------------------
wiritttes::add_species_trees(filename)  

## ------------------------------------------------------------------------
#plot_species_tree(filename)
#plot_species_tree_nltt(filename, dt = 0.001)

n_taxa_sstree <- length(
  wiritttes::get_species_tree_by_index(
    wiritttes::read_file(filename), 1)$tip.label
  )

## ------------------------------------------------------------------------
wiritttes::add_alignments(filename)  

## ------------------------------------------------------------------------
n_taxa_alignment <- length(
  labels(
    wiritttes::get_alignment_by_index(
      file = wiritttes::read_file(filename), 
      i = 1
    )
  )
)

## ------------------------------------------------------------------------
wiritttes::add_posteriors(filename)

## ------------------------------------------------------------------------
phylogenies <- wiritttes::get_posteriors(wiritttes::read_file(filename))[[1]][[1]]$trees
# To get the densiTree function working, phylogenies must be of class multiphylo
class(phylogenies) <- "multiPhylo"

