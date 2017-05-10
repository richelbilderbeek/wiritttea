## ----echo = FALSE--------------------------------------------------------
# Warnings are errors
options(warn = 2)

## ------------------------------------------------------------------------
library(ape)
library(wiritttea)
options(warn = 2)

## ------------------------------------------------------------------------
filename <- find_path("toy_example_1.RDa")
print(filename)

## ------------------------------------------------------------------------
file <- wiritttes::read_file(filename)

## ------------------------------------------------------------------------
print(names(file))

## ------------------------------------------------------------------------
print(names(file$pbd_output))

## ------------------------------------------------------------------------
incipient_species_tree <- file$pbd_output$igtree.extant
colors <- setNames(c("gray", "black"), c("i", "g"))
phytools::plotSimmap(
  incipient_species_tree, 
  colors = colors
)

## ------------------------------------------------------------------------
colors <- stats::setNames(c("gray", "black"), c("i", "g"))
testit::assert(
  length(
    wiritttes::read_file(filename)$pbd_output$igtree.extant$tip.label
  ) > 0
)
phytools::plotSimmap(
  file$pbd_output$igtree.extant, 
  colors = colors
)

## ------------------------------------------------------------------------
true_tree <- wiritttes::get_species_tree_by_index(file = file, sti = 1)
plot(true_tree)

## ------------------------------------------------------------------------
true_gamma <- ape::gammaStat(true_tree)
print(true_gamma)
if (true_gamma < 0) {
  print("tippy tree")
} else {
  print("stemmy tree")
}  

## ------------------------------------------------------------------------
posterior_trees <- wiritttes::get_posteriors(file)[[1]][[1]]$trees
n_trees <- length(posterior_trees)
print(paste0("There are ", n_trees))

## ------------------------------------------------------------------------
for (i in seq(1:n_trees)) {
  plot(posterior_trees[[i]])
}

## ------------------------------------------------------------------------
gamma_statistics <- rep(0, times = n_trees)
for (i in seq(1:n_trees)) {
  gamma_statistics[i] <- ape::gammaStat(posterior_trees[[i]])
}
hist(gamma_statistics, xlim = c(-1, 1))
abline(v = true_gamma, col = "red")

