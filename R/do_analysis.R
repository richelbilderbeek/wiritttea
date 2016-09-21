#' Performs the full analysis on all the .RDa files present in a
#' given folder. These .RDa files are in the format
#' created by the 'wirittttes' package
#' @param folder path of the folder containing the RDa files
#' @return nothing
#' @examples
#'   do_analysis()
#' @export
do_analysis <- function(folder)
{


  collect_files_esses()
  collect_files_gammas()
  collect_files_n_alignments()
  collect_files_nltts()
  collect_files_n_posteriors()
  collect_files_nrbss()
  collect_files_n_species_trees()
  collect_files_n_taxa()
  collect_gamma_statistics()
  collect_n_alignments()
  collect_n_posteriors()
  collect_n_species_trees()
  collect_n_taxa()
  collect_parameters()
  collect_posterior_gammas()
  collect_posterior_nllts()
  collect_species_tree_gammas()
  collect_species_tree_nltts()
  collect_species_tree_n_taxa()

}
