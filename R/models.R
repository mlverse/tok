tok_model <- R6::R6Class(
  "tok_model",
  public = list(
    .model = NULL,
    initialize = function(model) {
      self$.model <- RModel$new(model)
    }
  )
)

model_bpe <- R6::R6Class(
  "tok_model_bpe",
  inherit = tok_model,
  public = list(
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

model_wordpiece <- R6::R6Class(
  "tok_model_wordpiece",
  inherit = tok_model,
  public = list(
    initialize = function(vocab = NULL, unk_token = NULL, max_input_chars_per_word = NULL) {
      super$initialize(RModelWordPiece$new(
        vocab = vocab,
        unk_token = unk_token,
        max_input_chars_per_word = max_input_chars_per_word
      ))
    }
  )
)