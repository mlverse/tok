#' @export
pre_tokenizer <- R6::R6Class(
  "tok_pre_tokenizer",
  public = list(
    .pre_tokenizer = NULL,
    initialize = function(pre_tokenizer) {
      if (inherits(pre_tokenizer, "RPreTokenizer")) {
        self$.pre_tokenizer <- pre_tokenizer
      } else {
        self$.pre_tokenizer <- RPreTokenizer$new(pre_tokenizer)  
      }
    }
  )
)

#' @export
pre_tokenizer_whitespace <- R6::R6Class(
  "tok_pre_tokenizer_whitespace",
  inherit = pre_tokenizer,
  public = list(
    initialize = function() {
      super$initialize(RPreTokenizerWhitespace$new())
    }
  )
)