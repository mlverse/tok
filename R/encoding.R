#' Encoding
#' @description 
#' Represents the output of a [tokenizer].
#' 
#' @export
encoding <- R6::R6Class(
  classname = "tok_encoding",
  public = list(
    #' @field .encoding The underlying implementation pointer.
    .encoding = NULL,
    #' @description Initializes an encoding object (Not to use directly)
    #' @param encoding an encoding implementation object
    initialize = function(encoding) {
      if (inherits(encoding, "REncoding")) {
        self$.encoding <- encoding
      } else {
        cli::cli_abort("Expected class {.cls REncoding} but got {.cls {class(encoding)}}.")
      }
    }  
  ),
  active = list(
    #' @field ids The IDs are the main input to a Language Model. They are the 
    #'  token indices, the numerical representations that a LM understands.
    ids = function(x) {
      if (missing(x)) {
        self$.encoding$get_ids()
      }
    }
  )
)