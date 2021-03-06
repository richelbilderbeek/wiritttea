% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/collect_files_parameters.R
\name{collect_files_parameters}
\alias{collect_files_parameters}
\title{Collects the parameters of its input files}
\usage{
collect_files_parameters(filenames)
}
\arguments{
\item{filenames}{names of the parameter files}
}
\value{
a data.frame, one per parameter file. If all filenames are invalid,
  a simpler data.frame is returned
}
\description{
Collects the parameters of its input files
}
\examples{
 filenames <- c(
   find_path("toy_example_1.RDa"),
   find_path("toy_example_2.RDa"),
   find_path("toy_example_3.RDa")
 )
 df <- collect_files_parameters(filenames)
 testit::assert(nrow(df) == 3)
 testit::assert(all(rownames(df) == basename(filenames)))
}
\author{
Richel Bilderbeek
}
