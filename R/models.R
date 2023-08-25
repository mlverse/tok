#' Generic class for tokenization models
#' @export
#' @family model
tok_model <- R6::R6Class(
  "tok_model",
  public = list(
    #' @field .model stores the pointer to the model. internal
    .model = NULL,
    #' @description
    #' Initializes a genric abstract tokenizer model
    #' @param model Pointer to a tokenization model
    initialize = function(model) {
      self$.model <- RModel$new(model)
    }
  )
)

#' BPE model
#' @export
#' @family model
model_bpe <- R6::R6Class(
  "tok_model_bpe",
  inherit = tok_model,
  public = list(
    #' @description Initializes a BPE model
    #' An implementation of the BPE (Byte-Pair Encoding) algorithm
    #' @param vocab A named integer vector of string keys and their corresponding ids. Default: `NULL`
    #' @param merges A list of pairs of tokens (`[character, character]`). Default: `NULL`.
    #' @param cache_capacity The number of words that the BPE cache can contain.
    #'        The cache speeds up the process by storing merge operation results. Default: `NULL.`
    #' @param dropout A float between 0 and 1 representing the BPE dropout to use. Default: `NULL`
    #' @param unk_token The unknown token to be used by the model. Default: `NULL```.
    #' @param continuing_subword_prefix The prefix to attach to subword units that don’t
    #'        represent the beginning of a word. Default: `NULL`
    #' @param end_of_word_suffix The suffix to attach to subword units that represent
    #'        the end of a word. Default: `NULL`
    #' @param fuse_unk Whether to fuse any subsequent unknown tokens into a single one. Default: `NULL`.
    #' @param byte_fallback Whether to use the spm byte-fallback trick. Default: `FALSE`.
    initialize = function(
    vocab = NULL, merges = NULL, cache_capacity = NULL, 
    dropout = NULL, unk_token = NULL, continuing_subword_prefix = NULL,
    end_of_word_suffix = NULL, fuse_unk = NULL, byte_fallback = FALSE
    ) {
      super$initialize(RModelBPE$new(
        vocab = vocab,
        merges = merges, 
        cache_capacity = cache_capacity,
        dropout = dropout,
        unk_token = unk_token,
        continuing_subword_prefix = continuing_subword_prefix,
        end_of_word_suffix = end_of_word_suffix,
        fuse_unk = fuse_unk,
        byte_fallback = byte_fallback
      ))
    }
  )
)

#' An implementation of the WordPiece algorithm
#' 
#' @family model
#' @export
model_wordpiece <- R6::R6Class(
  "tok_model_wordpiece",
  inherit = tok_model,
  public = list(
    #' @description
    #' Constructor for the wordpiece tokenizer
    #' @param vocab A dictionary of string keys and their corresponding ids.
    #'        Default: `NULL`.
    #' @param unk_token The unknown token to be used by the model.
    #'        Default: `NULL`.
    #' @param max_input_chars_per_word The maximum number of characters to allow in a single word.
    #'        Default: `NULL`.
    initialize = function(vocab = NULL, unk_token = NULL, max_input_chars_per_word = NULL) {
      super$initialize(RModelWordPiece$new(
        vocab = vocab,
        unk_token = unk_token,
        max_input_chars_per_word = max_input_chars_per_word
      ))
    }
  )
)

#' An implementation of the Unigram algorithm
#' @export
#' @family model
model_unigram <- R6::R6Class(
  "tok_model_unigram",
  inherit = tok_model,
  public = list(
    #' @description
    #' Constructor for Unigram Model
    #' @param vocab A dictionary of string keys and their corresponding relative score.
    #'        Default: `NULL`.
    #' @param unk_id The unknown token id to be used by the model.
    #'        Default: `NULL`.
    #' @param byte_fallback Whether to use byte-fallback trick. Default: `FALSE`.
    initialize = function(vocab = NULL, unk_id = NULL, byte_fallback = FALSE) {
      super$initialize(RModelUnigram$new(
        vocab = vocab,
        unk_id = unk_id,
        byte_fallback = byte_fallback
      ))
    }
  )
)