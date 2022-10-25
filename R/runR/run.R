#!/usr/bin/env Rscript

# Author: Job Diogenes Ribeiro Borges
# License: GPLv3
# Version: 0.2
# Repository: < github.com/jobdiogenes/scrip-lab/R >
#
# About this script: this script is a R script to run any R script
# or Rmd script output their result to a PDF file. It also create .tex output
# which could be used in a latex document.

# check pars
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("You must give a .R or .Rmd (R markdown) script to run!", call. = FALSE)
}

if (file.exists(args[1]) == FALSE) {
  stop("File does not exist! try to use full path as argument", call. = FALSE) #nolint
}

# change Working Directory to script folder
setwd(dirname(args[1]))

# check config
inifile <- paste0( sub(pattern = "(.*)\\..*$", replacement = "\\1", filename(args[1]) ), ".ini") # nolint

if (file.exists(inifile) == FALSE) {
   print("Warning Ini file not found!")
   print("Running without send email or autoinstall packages")
} else {
   source(inifile)
}

# setup work directory
if (dir.exists("lib") == FALSE) {
   dir.create("lib")
}
if (dir.exists("bin") == FALSE) {
   dir.create("bin")
}
if (dir.exists("input") == FALSE) {
   dir.create("input")
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
# pacs <- c("knitr", "tinytex", "remotes", "emayili")
pacs <- c("rmarkdown", "emayili")

if (exists("PROJ_PACKAGES")) {
   append(pacs, PROJ_PACKAGES)
}
if (!exists("CRAN_REPO")) {
   CRAN_REPO <- "https://cran-r.c3sl.ufpr.br/"
}

# install packages and dependencies if not installed
if (length(setdiff(pacs, rownames(installed.packages()))) > 0) {
   install.packages(setdiff(pacs, rownames(installed.packages())),
                    lib = Sys.getenv("R_LIBS_USER"),
                    repos = CRAN_REPO)
}

# install emaiyii package if not installed
if (length(setdiff(c("emaiyii"), rownames(installed.packages()))) > 0) {
   remotes::install_github("datawookie/emaiyii", lib = Sys.getenv("R_LIBS_USER")) # nolint
}
filename <- tools::file_path_san_ext(basename(args[1]))

result <- paste0("output/", filename, format(Sys.time(), "%Y-%M-%d %X"), ".pdf")

to_pdf <- function(dest) {
   knitr::stitch(args[1], output = dest,
                lib = Sys.getenv("R_LIBS_USER"),
                quiet = TRUE,
                verbose = FALSE,
                quiet.warnings = TRUE
                )

}

elapsed <- system.time({to_pdf(result)})

if (exists("MAIL_USER") && exists("MAIL_PASS") && exists("MAIL_HOST")
   && exists("MAIL_PORT")) {
   require("emayili")
   SMTP <- server(
     host = MAIL_HOST,
     port = MAIL_PORT,
     username = Sys.getenv(MAIL_USER),
     password = Sys.getenv(MAIL_PASS)
   )
   email <- envelop(
      to = MAIL_USER,
      from = MAIL_USER,
      subject = paste("Your R script ", args[1],
       "was finished see report result attached"),
      text = paste("Your Script takes to run", elapsed)
   )
   email <- email %>% attachment(result)
   SMTP(email, verbose = TRUE)
}

print(elapsed)
