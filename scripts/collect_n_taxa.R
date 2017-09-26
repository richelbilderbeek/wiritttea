# Analyse the number of taxa
library(wiritttea)
options(warn = 2) # Be strict


# Collects the parameters used in all .RDa files in one file
library(wiritttea)
options(warn = 2)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/n_taxa_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/parameters_stub.csv'")
}

path_data <- args[1]
n_taxa_filename <- args[2]

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) n_taxa_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("n_taxa_filename:", n_taxa_filename))

print("Collecting .RDa files")
my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)

print("Collecting # taxa")
df_n_taxa <- wiritttea::collect_files_n_taxa(filenames = my_filenames)

print("Saving # taxa")
write.csv(df_n_taxa, n_taxa_filename)
