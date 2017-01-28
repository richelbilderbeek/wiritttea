library(wiritttea)

df <- collect_species_tree_n_taxa(filename = "/home/richel/GitHubs/wiritttea/inst/extdata/toy_example_1.RDa")
write.csv(df, "tmp.csv")
