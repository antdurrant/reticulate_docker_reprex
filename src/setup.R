options(warn=2)
# because
# library(reticulate)
# > nltk <- reticulate::import("nltk")
# > Error in main_process_python_info() : 
# >  function 'Rcpp_precious_remove' not provided by package 'Rcpp'
# lead to https://stackoverflow.com/questions/68416435/rcpp-package-doesnt-include-rcpp-precious-remove
# tl;dr: update Rcpp
install.packages("Rcpp")
# not part of shiny-verse image
install.packages("reticulate")
