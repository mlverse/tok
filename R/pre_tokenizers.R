#' Generic class for tokenizers
#' @export
#' @family pre_tokenizer
pre_tokenizer <- R6::R6Class(
  "tok_pre_tokenizer",
  public = list(
    #' @field .pre_tokenizer Internal pointer to tokenizer object
    .pre_tokenizer = NULL,
    #' @description
    #' Initializes a tokenizer
    #' @param pre_tokenizer a raw pointer to a tokenizer
    initialize = function(pre_tokenizer) {
      if (inherits(pre_tokenizer, "RPreTokenizer")) {
        self$.pre_tokenizer <- pre_tokenizer
      } else {
        self$.pre_tokenizer <- RPreTokenizer$new(pre_tokenizer)  
      }
    }
  )
)

#' This pre-tokenizer simply splits using the following regex: `\w+|[^\w\s]+`
#' @export
#' @family pre_tokenizer
pre_tokenizer_whitespace <- R6::R6Class(
  "tok_pre_tokenizer_whitespace",
  inherit = pre_tokenizer,
  public = list(
    #' @description
    #' Initializes the whistespace tokenizer
    initialize = function() {
      super$initialize(RPreTokenizerWhitespace$new())
    }
  )
)