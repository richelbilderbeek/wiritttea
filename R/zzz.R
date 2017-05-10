.onLoad <- function(libname, pkgname){

  # From Wickham, R Packages, 'Top-level code', 'When you do need side-effects'
  # > To connect R to another programming language. For example, if you
  # > use rJava to talk to a .jar file, you need to call rJava::.jpackage().
  # > To make C++ classes available as reference classes in R with Rcpp modules,
  # > you call Rcpp::loadRcppModules().
  # ?Use Rcpp
  # Rcpp::loadRcppModules()

  # Use C++11
  Sys.setenv("PKG_CXXFLAGS" = "-std=c++11")
}