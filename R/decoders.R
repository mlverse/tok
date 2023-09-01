#' Generic class for decoders
#' @export
#' @family decoders
tok_decoder <- R6::R6Class(
  "tok_decoder",
  public = list(
    #' @field .decoder The raw pointer to the decoder
    .decoder = NULL,
    #' @description
    #' Initializes a decoder
    #' @param decoder a raw decoder pointer
    initialize = function(decoder) {
      if (inherits(decoder, "RDecoder")) {
        self$.decoder <- decoder
      } else {
        self$.decoder <- RDecoder$new(decoder)
      }
    }
  )
)

#' Byte level decoder
#' 
#' This decoder is to be used with the [pre_tokenizer_byte_level].
#' @export
#' @family decoders
decoder_byte_level <- R6::R6Class(
  "tok_decoder_byte_level",
  inherit = tok_decoder,
  public = list(
    #' @description
    #' Initializes a byte level decoder
    initialize = function() {
      super$initialize(RDecoderByteLevel$new())
    }
  )
)