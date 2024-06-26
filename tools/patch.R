files <- list.files(
  "rust", 
  recursive = TRUE, 
  pattern = ".h$", 
  full.names = TRUE, 
  include.dirs = FALSE
)

file.remove(files)