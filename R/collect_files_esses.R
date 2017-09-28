#' Collects the ESSes of all phylogenies belonging to the
#' .RDa data files in the melted/uncast/long form from the
#' .RDa file itself
#' @param filenames names of the .RDa data files
#' @param show_progress set to TRUE to show the progress
#' @return A dataframe of ESSes for all files their posterior
#' @examples
#'   filenames <- find_paths(c("toy_example_3.RDa", "toy_example_4.RDa"))
#'   df <- collect_files_esses(filenames)
#'   testit::assert(nrow(df) == 16)
#' @seealso collect_files_esses_from_logs
#' @export
collect_files_esses <- function(filenames, show_progress = FALSE) {

  if (length(filenames) == 0) {
    print(paste("filenames: '", filenames, "'", sep = ""))
    stop(
      "there must be at least one filename supplied, "
    )
  }

  # Find the first valid data.frame, to create the target data frame
  first_valid_filename <- NULL
  for (filename in filenames) {
    if (wiritttes::is_valid_file(filename = filename)) {
      first_valid_filename <- filename
      break
    }
  }
  if (is.null(first_valid_filename)) {
    stop("Must supply at least one valid filename")
  }

  # nstpist: Number of Species Trees Per Incipient Species Tree
  nstpist <- 2
  # napst: Number of Alignments per Species Tree
  napst <- wiritttes::extract_napst(wiritttes::read_file(first_valid_filename))
  # nppa: Number of Posteriors per Alignment
  nppa <- wiritttes::extract_nppa(wiritttes::read_file(first_valid_filename))
  # nppf: Number of Posteriors Per File
  nppf <- nstpist * napst * nppa
  n_files <- length(filenames)
  n_rows <- n_files * nppf

  df <- data.frame(
    filename = rep(basename(filenames), each = nppf),
    sti = rep(seq(1, 2), each = napst * nppa, times = n_files),
    ai = rep(seq(1, napst), each = nstpist, times = n_files * nppa),
    pi = rep(seq(1, nppa), times = n_files * nstpist * napst),
    posterior = rep(NA, n_rows),
    likelihood = rep(NA, n_rows),
    prior = rep(NA, n_rows),
    treeLikelihood = rep(NA, n_rows),
    TreeHeight = rep(NA, n_rows),
    BirthDeath = rep(NA, n_rows),
    birthRate2 = rep(NA, n_rows),
    relativeDeathRate2 = rep(NA, n_rows)
  )

  index <- 1
  for (filename in filenames) {
    if (show_progress == TRUE) {
      print(filename)
    }
    tryCatch({
      this_esses <- wiritttea::collect_file_esses(filename)
      df[index:(index + nppf - 1), ] <- this_esses
    }, error = function(cond) {} # nolint
    )
    index <- index + nppf
  }

  testit::assert(names(df) == c(
    "filename",
    "sti",
    "ai",
    "pi",
    "posterior",
     "likelihood",
     "prior",
     "treeLikelihood",
     "TreeHeight",
     "BirthDeath",
     "birthRate2",
     "relativeDeathRate2"
    )
  )
  df
}

#' Collects the ESSes of all phylogenies belonging to the
#' parameter files in the melted/uncast/long form from
#' the log files created next to the .RDa data files
#' @param filenames names of the parameter files
#' @param show_progress set to TRUE to show the progress
#' @return A dataframe of ESSes for all files their posterior
#' @examples
#'   filenames <- find_paths(c("toy_example_3.RDa", "toy_example_4.RDa"))
#'   df <- collect_files_esses(filenames)
#'   testit::assert(nrow(df) == 16)
#' @export
collect_files_esses_from_logs <- function(filenames, show_progress = FALSE) {

  if (length(filenames) == 0) {
    print(paste("filenames: '", filenames, "'", sep = ""))
    stop(
      "there must be at least one filename supplied, "
    )
  }

  # Find the first valid data.frame, to create the target data frame
  first_valid_filename <- NULL
  for (filename in filenames) {
    if (wiritttes::is_valid_file(filename = filename)) {
      first_valid_filename <- filename
      break
    }
  }
  if (is.null(first_valid_filename)) {
    stop("Must supply at least one valid filename")
  }

  # nstpist: Number of Species Trees Per Incipient Species Tree
  nstpist <- 2
  # napst: Number of Alignments per Species Tree
  napst <- wiritttes::extract_napst(wiritttes::read_file(first_valid_filename))
  # nppa: Number of Posteriors per Alignment
  nppa <- wiritttes::extract_nppa(wiritttes::read_file(first_valid_filename))
  # nppf: Number of Posteriors Per File
  nppf <- nstpist * napst * nppa
  n_files <- length(filenames)
  n_rows <- n_files * nppf


  df <- data.frame(
    filename = rep(basename(filenames), each = nppf),
    sti = rep(seq(1, 2), each = napst * nppa, times = n_files),
    ai = rep(seq(1, napst), each = nstpist, times = n_files * nppa),
    pi = rep(seq(1, nppa), times = n_files * nstpist * napst),
    posterior = rep(NA, n_rows),
    likelihood = rep(NA, n_rows),
    prior = rep(NA, n_rows),
    treeLikelihood = rep(NA, n_rows),
    TreeHeight = rep(NA, n_rows),
    BirthDeath = rep(NA, n_rows),
    birthRate2 = rep(NA, n_rows),
    relativeDeathRate2 = rep(NA, n_rows)
  )

  index <- 1
  for (i in seq_along(filenames)) {

    rda_filename <- filenames[i]
    log_filenames <- wiritttea::create_log_filenames(
      rda_filename, nstpist, napst, nppa)

    for (log_filename in log_filenames) {

      tryCatch({
        print(log_filename)
        estimates <- RBeast::parse_beast_log(log_filename)
        this_esses <- RBeast::calc_esses(
          traces = estimates,
          sample_interval = 1000
        )
        print(this_esses)
        df$posterior[index] <- this_esses$posterior
        df$likelihood[index] <- this_esses$likelihood
        df$prior[index] <- this_esses$prior
        df$treeLikelihood[index] <- this_esses$treeLikelihood
        df$TreeHeight[index] <- this_esses$TreeHeight
        df$BirthDeath[index] <- this_esses$BirthDeath
        df$birthRate2[index] <- this_esses$birthRate2
        df$relativeDeathRate2[index] <- this_esses$relativeDeathRate2
      }, error = function(cond) {} # nolint
      )
      index <- index + 1
    }
  }

  testit::assert(names(df) == c(
    "filename",
    "sti",
    "ai",
    "pi",
    "posterior",
    "likelihood",
    "prior",
    "treeLikelihood",
    "TreeHeight",
    "BirthDeath",
    "birthRate2",
    "relativeDeathRate2"
  )
  )
  df
}
