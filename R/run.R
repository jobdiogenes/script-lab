#!/usr/bin/env Rscript

# Author: Job Diogenes Ribeiro Borges
# License: GPLv3
# Version: 0.1
# Repository: < github.com/jobdiogenes/scrip-lab/R >
#
# About this script: this script is a R script to run any R script
# or Rmd script output their result to a PDF file. It also create .tex output
# which could be used in a latex document.

# setup work directory
if (dir.exists("lib") == FALSE) {
   dir.create("lib")
}
if (dir.exists("bin") == FALSE) {
   dir.create("bin")
}
if (dir.exists("data") == FALSE) {
   dir.create("data")
}
if (dir.exists("output") == FALSE) {
   dir.create("output")
}

libpath <- paste(getwd(), "/lib", sep = "")
binpath <- paste(getwd(), "/bin", sep = "")
Sys.setenv(PATH = paste(Sys.getenv("PATH"), binpath, sep = ":"))
Sys.setenv(R_LIBS_USER = libpath)

dir.create(path = Sys.getenv("R_LIBS_USER"),
           showWarnings = FALSE, recursive = TRUE)

.libPaths(c(.libPaths(), Sys.getenv("R_LIBS_USER")))

# set up R packages to be used by stitch
pacs <- c("knitr", "tinytex", "remotes")

# install packages and dependencies if not installed
if (length(setdiff(pacs, rownames(installed.packages()))) > 0) {

   if (file.exists("cran.repo")) {
     repo <- read("cran.repo")
   } else {
     repo <- "https://cran-r.c3sl.ufpr.br/"
   }
   install.packages(setdiff(pacotes, rownames(installed.packages())),
                    lib = Sys.getenv("R_LIBS_USER"),
                    repos = repo)
   tinytex::install_tinytex()
}

# install emaiyii package if not installed
if (length(setdiff(c("emaiyii"), rownames(installed.packages()))) > 0) {
   remotes::install_github("datawookie/emaiyii", lib = Sys.getenv("R_LIBS_USER")) # nolint
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("You must give a .R or .Rmd (R markdown) script to run!", call. = FALSE)
} else {
   if (file.exists(args[1]) == FALSE) {
      stop("The file you gave does not exist!", call. = FALSE)
   }
   basename <- tools::file_path_san_ext(args[1])
   result <- paste0("output/", basename,
                     format(Sys.time(), "%Y-%M-%d %X"), ".pdf")
   knitr::stitch(args[1], output = result,
                lib = Sys.getenv("R_LIBS_USER"),
                quiet = TRUE,
                verbose = FALSE,
                quiet.warnings = TRUE
                )
}
