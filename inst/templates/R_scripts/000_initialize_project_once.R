################################################################################
##### Ensure you have for your own computer/profile (once) setup your ##########
################################################################################
# - Github account
# - Have access to a Github Enterprise account (if needed)
# - Have stored your Github credentials in your .renviron file at your My documents folder



################################################################################
## Setup once per project (only one user does this others will fork if needed)
################################################################################
usethis::use_git(message = "0.0.1")
gert::git_add(".")
gert::git_commit(message = "0.0.3")
usethis::use_github(private = TRUE)
usethis::use_github_action("setup-r")
usethis::use_github_action("setup-r-dependencies")
