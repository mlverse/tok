#' Generic class for processors
#' @export
#' @family processors
tok_processor <- R6::R6Class(
  "tok_processor",
  public = list(
    #' @field .processor Internal pointer to processor object
    .processor = NULL,
    #' @description
    #' Initializes a tokenizer
    #' @param processor a raw pointer to a processor
    initialize = function(processor) {
      if (inherits(processor, "RPostProcessor")) {
        self$.processor <- processor
      } else {
        self$.processor <- RPostProcessor$new(processor)  
      }
    }
  )
)

#' Byte Level post processor
#' 
#' This post-processor takes care of trimming the offsets.
#' By default, the ByteLevel BPE might include whitespaces in the produced tokens. 
#' If you don’t want the offsets to include these whitespaces, then this 
#' PostProcessor must be used.
#'
#' @family processors
#' @export
processor_byte_level <- R6::R6Class(
  "tok_processor_byte_level",
  inherit = tok_processor,
  public = list(
    #' @description
    #' Initializes the byte level post processor
    #' @param trim_offsets Whether to trim the whitespaces from the produced offsets.
    initialize = function(trim_offsets = TRUE) {
      super$initialize(
        RPostProcessorByteLevel$new(trim_offsets)
      )
    }
  )
)