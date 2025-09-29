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

#' Byte level pre tokenizer
#' 
#' This pre-tokenizer takes care of replacing all bytes of the given string with 
#' a corresponding representation, as well as splitting into words.
#' @export
#' @family pre_tokenizer
pre_tokenizer_byte_level <- R6::R6Class(
  "tok_pre_tokenizer_byte_level",
  inherit = pre_tokenizer,
  public = list(
    #' @description
    #' Initializes the bytelevel tokenizer
    #' @param add_prefix_space Whether to add a space to the first word
    #' @param use_regex Set this to False to prevent this pre_tokenizer from using 
    #'   the GPT2 specific regexp for spliting on whitespace.
    initialize = function(add_prefix_space = TRUE, use_regex = TRUE) {
      super$initialize(RPreTokenizerByteLevel$new(
        add_prefix_space, 
        use_regex
      ))
    }
  )
)