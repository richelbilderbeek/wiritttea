% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_collected_nltts_postrs.R
\name{read_collected_nltts_postrs}
\alias{read_collected_nltts_postrs}
\title{Read all the collected nLTT values of all posteriors}
\usage{
read_collected_nltts_postrs()
}
\value{
a dataframe
}
\description{
Read all the collected nLTT values of all posteriors
}
\examples{
  df <- wiritttea::read_collected_nltts_postrs()
  testit::assert(
    all(names(df) ==
      c(
        "filename", "sti", "ai",
        "pi", "si", "nltt"
      )
    )
  )
}
\author{
Richel Bilderbeek
}
