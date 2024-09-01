### This script will convert images in the docx-chapters to proper mschart ones.
### It uses the saros.base::post_render_docx_img_replacer(), which loops across saros.base::replace_docx_imgs_with_mscharts()

### The path to where the main report chapter docx files are located
report_path <- fs::path(Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR"),
                        "Rapporter", "Barnehageleder", "2022H")
### Vector of the mesos groups, taken from the folders in report_path/mesos
mesos_groups <- list.dirs(fs::path(report_path, "mesos"),
                          full.names = FALSE, recursive = FALSE)
### Vector of absolute paths to the above-mentioned mesos folders
mesos_paths <- fs::path(report_path, "mesos", mesos_groups)

### First find path for where the folders to the charts will be found
### Assume that the relative paths within this folder resemble that of report_path
chart_paths <- fs::path(Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR"),
                        "..",
                        "Rapporter", "Barnehageleder", "2022H")
chapters <- dir(chart_paths, pattern = ".qmd", full.names = FALSE,
                recursive = FALSE, include.dirs = FALSE, no.. = TRUE)

chart_paths <- fs::path(chart_paths, chapters)

tryCatch(saros.base::post_render_docx_img_replacer(path = report_path),
         error = function(e) cli::cli_warn(e))

# tryCatch(saros.base::create__headers_file(site_path = Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR"),
#                             mesos_paths = mesos_paths,
#                             mesos_usernames = mesos_groups,
#                             mesos_passwords = mesos_groups,
#                             global_username = "admin",
#                             global_password = "arturead"),
#          error = function(e) cli::cli_warn(e))
