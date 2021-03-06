% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/collect_files_species_tree_nltts.R
\name{collect_files_stree_nltts}
\alias{collect_files_stree_nltts}
\title{Collects the nLTT statistics of all phylogenies belonging to a
multiple parameter file in the melted/uncast/long form}
\usage{
collect_files_stree_nltts(filenames, dt = 0.001)
}
\arguments{
\item{filenames}{names of the parameter file}

\item{dt}{the resolution of the nLTT plot,
must be in range <0,1>, default is 0.001}
}
\value{
A dataframe
}
\description{
Collects the nLTT statistics of all phylogenies belonging to a
multiple parameter file in the melted/uncast/long form
}
