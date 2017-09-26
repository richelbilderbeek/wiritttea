# Why are there ESSes with value NaN?
create_filename <- function(base, date) {
  paste0("~/", base, "_", date, ".csv")
}

date_str <- "20170710"
args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) date_str <- args[1]


#alignments_filename <- create_filename("alignments", date_str)
#alignments_dmid_filename <- create_filename("alignments_dmid", date_str)
esses_filename <- create_filename("esses", date_str)
n_taxa_filename <- create_filename("n_taxa", date_str)
#parameters_filename <- create_filename("parameters", date_str)
strees_identical_filename <- create_filename("strees_identical", date_str)

#testit::assert(file.exists(alignments_filename))
#testit::assert(file.exists(alignments_dmid_filename))
testit::assert(file.exists(esses_filename))
testit::assert(file.exists(n_taxa_filename))
#testit::assert(file.exists(parameters_filename))
testit::assert(file.exists(strees_identical_filename))

df_esses <- wiritttea::read_collected_esses(esses_filename)
df_n_taxa <- wiritttea::read_collected_n_taxa(n_taxa_filename)
#df_parameters <- wiritttea::read_collected_parameters(parameters_filename)
df_strees_identical <- wiritttea::read_collected_strees_identical(strees_identical_filename)
