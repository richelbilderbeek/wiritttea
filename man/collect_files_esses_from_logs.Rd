% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/collect_files_esses.R
\name{collect_files_esses_from_logs}
\alias{collect_files_esses_from_logs}
\title{Collects the ESSes of all phylogenies belonging to the
parameter files in the melted/uncast/long form from
the log files created next to the .RDa data files}
\usage{
collect_files_esses_from_logs(filenames, show_progress = FALSE)
}
\arguments{
\item{filenames}{names of the parameter files}

\item{show_progress}{set to TRUE to show the progress}
}
\value{
A dataframe of ESSes for all files their posterior
}
\description{
Collects the ESSes of all phylogenies belonging to the
parameter files in the melted/uncast/long form from
the log files created next to the .RDa data files
}
\examples{
  filenames <- find_paths(c("toy_example_3.RDa", "toy_example_4.RDa"))
  df <- collect_files_esses(filenames)
  testit::assert(nrow(df) == 16)
}
