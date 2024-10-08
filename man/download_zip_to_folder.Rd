% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_zip_to_folder.R
\name{download_zip_to_folder}
\alias{download_zip_to_folder}
\title{Wrapper to Download and Unzip a Github Repository to A Folder}
\usage{
download_zip_to_folder(
  github_zip_url = "https://github.com/NIFU-NO/nifutemplates/archive/refs/heads/main.zip",
  zip_path = tempfile(fileext = ".zip"),
  files = NULL,
  out_path,
  prompt = TRUE,
  overwrite = FALSE,
  open_project = FALSE,
  newSession = TRUE
)
}
\arguments{
\item{github_zip_url}{URL to zip file, as string.}

\item{zip_path}{String, where to store zip-file. Defaults to a temporary location.}

\item{files}{Character vector of files in zip-file to include. See \code{zip::unzip()}.}

\item{out_path}{String, directory to where to store the unzipped files.}

\item{prompt}{Flag, whether to ask user if conflicting files should be overwritten, if any. Defaults to TRUE.}

\item{overwrite}{Flag, whether to overwrite files in out_path. Defaults to FALSE.}

\item{open_project}{Flag or string. If FALSE (default), does nothing. If TRUE (requires \code{rstudioapi}-pkg),
opens an assumed .Rproj-file in out_path after copying, or gives warning if
not found. Alternatively, a string (path) can be provided.
Defaults to file.path(out_path, ".Rproj") if such exists. Set to NULL or FALSE to ignore.}

\item{newSession}{Flag. Whether to open new project in a new RStudio session. Defaults to TRUE.}
}
\value{
Character vector of unzipped files.
}
\description{
Wrapper to Download and Unzip a Github Repository to A Folder
}
\examples{
download_zip_to_folder(
  github_zip_url = "https://github.com/NIFU-NO/nifutemplates/archive/refs/heads/main.zip",
  out_path = tempdir(), overwrite = TRUE
)
}
