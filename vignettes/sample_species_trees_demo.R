## ----echo = FALSE--------------------------------------------------------
# Warnings are errors
options(warn = 2)

## ----fig.width = 7, fig.height = 7---------------------------------------
newick <- "(((A,B),A),A);"
phylogeny <- phytools::read.newick(text = newick)
ape::plot.phylo(phylogeny, edge.width = 3, cex = 2)

## ----fig.width = 7, fig.height = 7---------------------------------------
age <- 4
seed <- 320
set.seed(seed)

sirg <- 0.7 # species initiation rate good species
scr  <- 0.2 # speciation completion rate
siri <- 0.6 # species initiation rate incipient species
erg  <- 1.0 # extinction rate good species
eri  <- 0.6 # extinction rate incipient species

# Work on the pbd_sim output
pbd_sim_output <- PBD::pbd_sim(
  c(sirg, scr, siri, erg, eri),
  age, 
  plotit = TRUE
)
names(pbd_sim_output)
testit::assert(ribir::is_pbd_sim_output(pbd_sim_output))

## ----fig.width = 7, fig.height = 7---------------------------------------
cols <- stats::setNames(c("gray", "black"), c("i", "g"))
phytools::plotSimmap(pbd_sim_output$igtree.extant, colors = cols)
ape::add.scale.bar()

## ------------------------------------------------------------------------
stree_youngest <- pbd_sim_output$stree_youngest 
stree_oldest <- pbd_sim_output$stree_oldest
species_trees <- c(stree_youngest, stree_oldest)
for (species_tree in species_trees) {
  title <- ifelse(
    identical(species_tree, stree_youngest), "youngest", "oldest"
  )
  ape::plot.phylo(species_tree, root.edge = TRUE, main = title)
}

## ------------------------------------------------------------------------
df <- nLTT::get_nltt_values(species_trees, dt = 0.01)
df$id <- plyr::revalue(df$id, c("1" = "youngest", "2" = "oldest"))
names(df)

## ----fig.width = 7, fig.height = 7---------------------------------------
ggplot2::ggplot(
  data = df,
  ggplot2::aes(x = t, y = nltt, colour = id)
) + ggplot2::geom_step(
  direction = "vh", size = 2, alpha = 0.5
) + ggplot2::scale_x_continuous(
  name = "Normalized time", limits = c(0, 1)
) + ggplot2::scale_y_continuous(name = "Normalized number of lineages", 
  limits = c(0, 1)
) + ggplot2::ggtitle("nLTT plots")

## ----fig.width = 7, fig.height = 7---------------------------------------
ggplot2::qplot(t, nltt, data = df, geom = "blank", ylim = c(0, 1), 
  main = "Average nLTT plot of phylogenies") + 
  ggplot2::stat_summary(
    fun.data = "mean_cl_boot", color = "red", geom = "smooth"
  )

