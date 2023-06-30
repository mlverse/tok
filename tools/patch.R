files <- list.files(
  "rust", 
  recursive = TRUE, 
  pattern = ".h$", 
  full.names = TRUE, 
  include.dirs = FALSE
)
for (f in files) {
  write("\n", file = f, append = TRUE)
}