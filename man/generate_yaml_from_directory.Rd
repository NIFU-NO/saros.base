% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_yaml_from_directory.R
\name{generate_yaml_from_directory}
\alias{generate_yaml_from_directory}
\title{Generate YAML File from Directory Structure}
\usage{
generate_yaml_from_directory(
  input_path = tempdir(),
  output_yaml_path = "_project_structure_en.yaml",
  remove_prefix_numbers = FALSE
)
}
\arguments{
\item{input_path}{String. The path to the directory whose structure needs to be captured.}

\item{output_yaml_path}{String. The path where the YAML file will be saved.}

\item{remove_prefix_numbers}{Boolean. Whether to remove numeric prefixes and any resulting leading non-alphanumeric characters from folder names. Defaults to FALSE.}
}
\value{
No return value, called for side effects
}
\description{
Generate YAML File from Directory Structure
}
\examples{
generate_yaml_from_directory(
  output_yaml_path =
    tempfile("_project_structure_en", fileext = ".yaml")
)
}
