% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/setup_mesos.R
\name{setup_mesos}
\alias{setup_mesos}
\title{Simply create qmd-files for mesos reports}
\usage{
setup_mesos(
  files_to_process,
  mesos_var,
  mesos_groups,
  main_files = c("index", "report"),
  read_syntax_pattern = "qs::qread\\\\('",
  read_syntax_replacement = "qs::qread('../",
  qmd_regex = "\\\\.qmd"
)
}
\arguments{
\item{files_to_process}{Character vector of files used as templates for the mesos stubs.}

\item{mesos_var}{String, variable used during rendering with saros::makeme() to obtain the column in the dataset which it will filter on.}

\item{mesos_groups}{Character vector for which stub-qmd files will be made}

\item{main_files}{Character vector of files for which titles should be set as the mesos_group. Optional but recommended.}

\item{read_syntax_pattern, read_syntax_replacement}{Optional strings, any regex pattern to search and replace in the qmd-files. If NULL, will ignore it.}

\item{qmd_regex}{String. Experimental feature for allowing Rmarkdown, not yet tested.}
}
\description{
Simply create qmd-files for mesos reports
}
