## ------------------------------------------------------------------------
library(wiritttea)
options(warn = 2)

## ------------------------------------------------------------------------
phylogeny1 <- ape::rcoal(10)
phylogeny2 <- phylogeny1
print(nrbs(phylogeny1 = phylogeny1, phylogeny2 = phylogeny2))

## ------------------------------------------------------------------------
phylogeny1 <- ape::rcoal(10)
phylogeny2 <- ape::rcoal(10)
print(nrbs(phylogeny1 = phylogeny1, phylogeny2 = phylogeny2))

## ------------------------------------------------------------------------
filename <- find_path("toy_example_3.RDa")
df <- collect_file_nrbss(filename)
testit::assert(names(df) == c("sti", "ai", "pi", "si", "nrbs"))
testit::assert(nrow(df) == 80)
knitr::kable(head(df))

## ------------------------------------------------------------------------
filenames <- c(
  find_path("toy_example_1.RDa"),
  find_path("toy_example_2.RDa"),
  find_path("toy_example_3.RDa"),
  find_path("toy_example_4.RDa")
)

df <- collect_files_nrbss(filenames)
testit::assert(names(df) == c("filename", "sti", "ai", "pi", "si", "nrbs"))
knitr::kable(head(df))

