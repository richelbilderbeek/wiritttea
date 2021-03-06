% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_collected_postr_liks.R
\name{read_collected_pstr_liks}
\alias{read_collected_pstr_liks}
\title{Read all the collected tree likelihoods of all posteriors}
\usage{
read_collected_pstr_liks(
    filename = wiritttea::find_path(
      "collect_files_posterior_likelihoods.csv")
  )
}
\arguments{
\item{filename}{name of the file with all the collected
posteriors' likelihoods}
}
\value{
a dataframe
}
\description{
Read all the collected tree likelihoods of all posteriors
}
\examples{
  df <- wiritttea::read_collected_pstr_liks()
  testit::assert(
    all(
      names(df) ==
      c(
        "filename", "sti", "ai",
        "pi", "si", "likelihood"
      )
    )
  )
}
\author{
Richel Bilderbeek
}
