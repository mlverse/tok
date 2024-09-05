#' Encoding
#' @description 
#' Represents the output of a [tokenizer].
#' 
#' @examples
#' withr::with_envvar(c(HUGGINGFACE_HUB_CACHE = tempdir()), {
#' try({
#' tok <- tokenizer$from_pretrained("gpt2")
#' encoding <- tok$encode("Hello world")
#' encoding
#' })
#' })
#' @returns
#' An encoding object containing encoding information such as attention masks
#' and token ids.
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
        cli::cli_abort(gettext("Expected class {.cls REncoding} but got {.cls {class(encoding)}}."))
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
    },
    #' @field attention_mask The attention mask used as input for transformers models.
    attention_mask = function(x) {
      if (missing(x)) {
        self$.encoding$get_attention_mask()
      }
    }
  )
)