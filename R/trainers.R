tok_trainer <- R6::R6Class(
  "tok_trainer",
  public = list(
    .trainer = NULL,
    initialize = function(trainer) {
      self$.trainer <- RTrainer$new(trainer)
    }  
  )
)

trainer_bpe <- R6::R6Class(
  "tok_trainer_bpe",
  inherit = tok_trainer,
  public = list(
    .trainer = NULL,
    initialize = function(vocab_size = NULL, 
                          min_frequency = NULL, 
                          show_progress = NULL, 
                          special_tokens = NULL, 
                          limit_alphabet = NULL, 
                          initial_alphabet = NULL,
                          continuing_subword_prefix = NULL, 
                          end_of_word_suffix = NULL,
                          max_token_length = NULL) {
      super$initialize(RTrainerBPE$new(
        vocab_size = vocab_size,
        min_frequency = min_frequency,
        show_progress = show_progress,
        special_tokens = special_tokens,
        limit_alphabet = limit_alphabet,
        initial_alphabet = initial_alphabet,
        continuing_subword_prefix = continuing_subword_prefix,
        end_of_word_suffix = end_of_word_suffix,
        max_token_length = max_token_length
      ))
    }
  )
)

trainer_wordpiece <- R6::R6Class(
  "tok_trainer_wordpiece",
  inherit = tok_trainer,
  public = list(
    initialize = function(
    vocab_size = 30000,
    min_frequency = 0,
    show_progress = FALSE,
    special_tokens = NULL,
    limit_alphabet = NULL,
    initial_alphabet = NULL,
    continuing_subword_prefix = "##",
    end_of_word_suffix = NULL
    ) {
      super$initialize(RTrainerWordPiece$new(
        vocab_size = vocab_size,
        min_frequency = min_frequency,
        show_progress = show_progress,
        special_tokens = special_tokens,
        limit_alphabet = limit_alphabet,
        initial_alphabet = initial_alphabet,
        continuing_subword_prefix = continuing_subword_prefix,
        end_of_word_suffix = end_of_word_suffix
      ))
    }
  )
)

trainer_unigram <- R6::R6Class(
  "tok_trainer_unigram",
  inherit = tok_trainer,
  public = list(
    initialize = function(
    vocab_size = 8000,
    show_progress = TRUE,
    special_tokens = NULL,
    shrinking_factor = 0.75,
    unk_token = NULL,
    max_piece_length = 16,
    n_sub_iterations = 2
    ) {
      super$initialize(RTrainerUnigram$new(
        vocab_size = vocab_size,
        show_progress = show_progress,
        special_tokens = special_tokens,
        shrinking_factor = shrinking_factor,
        unk_token = unk_token,
        max_piece_length = max_piece_length,
        n_sub_iterations = n_sub_iterations,
        initial_alphabet = NULL
      ))
    }
  )
)