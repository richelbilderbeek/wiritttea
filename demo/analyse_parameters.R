# Analyse the parametes
library(wiritttea)
options(warn = 2)

path_data <- "~/Peregrine20170509"
parameters_filename <- "~/parameters.csv"
args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) parameters_filename <- args[2]

# Collect all parameters in a single file if absent, slow
if (!file.exists(parameters_filename)) {
  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
  write.csv(wiritttea::collect_files_parameters(filenames = my_filenames), parameters_filename)
}

# Read the collected parameters
df_parameters <- wiritttea::read_collected_parameters(parameters_filename)

# Profiling
if (1==2){
  rprof_tmp_output <- "~/tmp_rprof"
  Rprof(rprof_tmp_output)
  wiritttea::collect_files_parameters(filenames = sub_filenames)
  Rprof(NULL)
  summaryRprof(rprof_tmp_output)
}
