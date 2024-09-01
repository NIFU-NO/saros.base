# .check_project_paths <- function(x) {
# 	for(.x in x) {
# 		if(fs::is_dir(.x)) fs::dir_create(.x)
# 		if(!fs::file_exists(.x) &&
# 		   !grepl("_raw|_pub|_rig", .x)) rlang::inform(c("Cannot find ", "!"=.x))
# 	}
# }
