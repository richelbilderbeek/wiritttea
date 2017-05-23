# Analyse if the alignments are created successfully
library(wiritttea)
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170523"

path_data <- "~/GitHubs/wiritttea/inst/extdata"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]

print(paste("path_data:", path_data))

my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)

# my_filenames <- c(
#   "/home/p230198/Peregrine20170509/article_1_3_0_3_0_958.RDa",
#   "/home/p230198/Peregrine20170509/article_1_3_0_3_1_972.RDa",
#   "/home/p230198/Peregrine20170509/article_1_3_0_3_1_976.RDa"
# )
df <- data.frame(filename = basename(my_filenames

for (my_filename in my_filenames) {
  has_alignments <- FALSE
  tryCatch( {
      testit::assert(file.exists(my_filename))
      file <- wiritttes::read_file(my_filename) # Can fail
      has_alignments <- all(wiritttes::has_alignments(file))
    },
    error = function(cond) {} # OK
  )
  print(paste(my_filename, ": ", has_alignments, sep = ""))
}
