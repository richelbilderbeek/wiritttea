% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/collect_files_alignments_dmid.R
\name{collect_files_alignments_dmid}
\alias{collect_files_alignments_dmid}
\title{Collect the alignments' DMIDs}
\usage{
collect_files_alignments_dmid(filenames)
}
\arguments{
\item{filenames}{names of the RDa files}
}
\value{
a data frame
}
\description{
Collect the alignments' DMIDs
}
\examples{
 filenames <- c(
   find_path("toy_example_1.RDa"),
   find_path("toy_example_3.RDa")
 )
 df <- collect_files_alignments_dmid(filenames)
 testit::assert(all(names(df) == c("filename", "ai", "dmid")))
 testit::assert(nrow(df) == 2 * length(filenames))
}
