serialize_read <- function(path, format) {
  switch(format,
         rds = readRDS(file = path)
  )
}

serialize_read_syntax <- function(format) {
  switch(format,
         rds = "readRDS")
}

serialize_write <- function(object, path, format) {
  switch(format,
         rds = saveRDS(object = object, file = path)
  )
}
