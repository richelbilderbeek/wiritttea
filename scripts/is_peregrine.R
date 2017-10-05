#!/usr/bin/env Rscript

is_peregrine <- function ()
{
  return(Sys.getenv("HOSTNAME") == "peregrine.hpc.rug.nl")
}

