library(wiritttea)
options(warn = 1)

args <- commandArgs(trailingOnly = TRUE)

if (1 == 2) {
  args <- c("/home/richel/wirittte_data", "stub")
}

if (length(args) < 1) {
  stop("Please add the source superfolder as a first argument, e.g. '~/wirittte_data'")
}
if (length(args) < 2) {
  stop("Please add the date as a second argument, e.g. '20170711'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source superfolder and a source subfolder, ",
    "e.g. '~/wirittte_data/stub 20170711'")
}

source_superfolder <- args[1]
date <- args[2]

# Variable initialization
print(paste0("source_superfolder: ", source_superfolder))
print(paste0("date: ", date))

# Checking inputs
if (dir.exists(source_superfolder)) {
  print("OK: source super folder is a folder")
} else {
  stop("ERROR: source super folder is not a folder")
}

# Checking if all files exist
nltt_stats_filename <- paste0(source_superfolder, "/nltt_stats_", date, ".csv")
parameters_filename <- paste0(source_superfolder, "/parameters_", date, ".csv")
alignments_filename <- paste0(source_superfolder, "/alignments_", date, ".csv")
operators_filename <- paste0(source_superfolder, "/operators_", date, ".csv")

if (!file.exists(parameters_filename)) {
  stop(
    "File '", parameters_filename, "' not found, ",
    "please run collect_parameters"
  )
}

if (!file.exists(nltt_stats_filename)) {
  stop("File '", nltt_stats_filename, "' not found, ",
    "please run collect_nltt_stats")
}

if (!file.exists(alignments_filename)) {
  stop("File '", alignments_filename, "' not found, ",
    "please run collect_alignments")
}

if (!file.exists(operators_filename)) {
  stop("File '", operators_filename, "' not found, ",
    "please run collect_operators")
}

print("Reading files")
parameters <- wiritttea::read_collected_parameters(parameters_filename)
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename, burn_in_fraction = 0.2)
operators <- wiritttea::read_collected_operators(operators_filename)
alignments <- wiritttea::read_collected_alignments(alignments_filename)

print("Create figures")
wiritttea::create_figure_error(
  parameters = parameters,
  nltt_stats = nltt_stats,
  svg_filenames = paste0(source_superfolder, "/figure_error_", date, c("","_head", "_tail"), ".svg")
)

wiritttea::create_figure_acceptance_mcmc_operators(
  operators = operators,
  filename = paste0(source_superfolder, "/figure_acceptance_mcmc_operators_", date, ".svg")
)

wiritttea::create_figure_alignment_qualities(
  alignments = alignments,
  filename = paste0(source_superfolder, "/figure_alignment_qualities_", date, ".svg")
)

wiritttea::create_figure_error_alignment_length(
  parameters = parameters,
  nltt_stats = nltt_stats,
  filename = paste0(source_superfolder, "/figure_error_alignment_length_", date, ".svg")
)

wiritttea::create_figure_error_alignment_length_mean(
  parameters = parameters,
  nltt_stats = nltt_stats,
  filename = paste0(source_superfolder, "/figure_error_alignment_length_mean_", date, ".svg")
)

wiritttea::create_figure_error_alignment_length_median(
  parameters = parameters,
  nltt_stats = nltt_stats,
  filename = paste0(source_superfolder, "/figure_error_alignment_length_median_", date, ".svg")
)
