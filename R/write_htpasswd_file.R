
write_htpasswd_file <- function(x, file, header=FALSE) {
  utils::write.table(x = x, file = file,
                     quote = FALSE, sep = ":",
                     col.names = if(isTRUE(header)) c("username", "password") else FALSE,
                     row.names = FALSE,
                     fileEncoding = "UTF-8")

}
