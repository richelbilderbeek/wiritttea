#' Table 111: How many parameter estimates are OK?
#' @param esses the ESSes, as returned from read_collected_esses
#' @param filename name of the file the table will be saved to
create_table_111 <- function(
  esses,
  filename
) {

  # How many NA's?
  is_ok <- function(x) {
    !is.na(x)
  }

  `%>%` <- dplyr::`%>%`
  esses_ok <- esses  %>% dplyr::count(is_ok(esses))

  names(esses_ok) <- c("ok", "n")
  esses_ok[ esses_ok$ok == TRUE, 1] <- "OK"
  esses_ok[ esses_ok$ok == FALSE, 1] <- "Fail"
  names(esses_ok) <- c("Parameter estimate status", "Count")

  write.csv(esses_ok, filename)
}