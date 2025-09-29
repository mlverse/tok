#' Generic class for normalizers
#' @export
#' @family normalizers
#' @export
tok_normalizer <- R6::R6Class(
  "tok_normalizer",
  public = list(
    #' @field .normalizer Internal pointer to normalizer object
    .normalizer = NULL,
    #' @description
    #' Initializes a tokenizer
    #' @param normalizer a raw pointer to a tokenizer
    initialize = function(normalizer) {
      if (inherits(normalizer, "RNormalizer")) {
        self$.normalizer <- normalizer
      } else {
        self$.normalizer <- RNormalizer$new(normalizer)  
      }
    }
  )
)

#' NFC normalizer
#' @export
#' @family normalizers
normalizer_nfc <- R6::R6Class(
  "tok_normalizer_nfc",
  inherit = tok_normalizer,
  public = list(
    #' @description
    #' Initializes the NFC normalizer
    initialize = function() {
      super$initialize(RNormalizerNFC$new())
    }  
  )
)

#' NFKC normalizer
#' @export
#' @family normalizers
normalizer_nfkc <- R6::R6Class(
  "tok_normalizer_nfkc",
  inherit = tok_normalizer,
  public = list(
    #' @description
    #' Initializes the NFKC normalizer
    initialize = function() {
      super$initialize(RNormalizerNFKC$new())
    }  
  )
)

