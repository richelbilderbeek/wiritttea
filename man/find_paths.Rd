% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_paths.R
\name{find_paths}
\alias{find_paths}
\title{Finds the full path of files}
\usage{
find_paths(filenames)
}
\arguments{
\item{filenames}{the names of files}
}
\value{
the full path of the filenames if an existing file could be found,
  stops otherwise
}
\description{
Finds the full path of files
}
\examples{
  filenames <- wiritttea::find_paths(
    c("toy_example_1.RDa", "toy_example_2.RDa")
  )
  testit::assert(file.exists(filenames[1]))
  testit::assert(file.exists(filenames[2]))
}
\author{
Richel Bilderbeek
}
