#' Generic training class
#' @export
#' @family trainer
tok_trainer <- R6::R6Class(
  "tok_trainer",
  public = list(
    #' @field .trainer a pointer to a raw trainer
    .trainer = NULL,
    #' @description
    #' Initializes a generic trainer from a raw trainer
    #' @param trainer raw trainer (internal)
    initialize = function(trainer) {
      self$.trainer <- RTrainer$new(trainer)
    }  
  )
)

#' BPE trainer
#' @export
#' @family trainer
trainer_bpe <- R6::R6Class(
  "tok_trainer_bpe",
  inherit = tok_trainer,
  public = list(
    #' @description
    #' Constrcutor for the BPE trainer
    #' @param vocab_size The size of the final vocabulary, including all tokens and alphabet.
    #'        Default: `NULL`.
    #' @param min_frequency The minimum frequency a pair should have in order to be merged.
    #'        Default: `NULL`.
    #' @param show_progress Whether to show progress bars while training. Default: `TRUE`.
    #' @param special_tokens A list of special tokens the model should be aware of.
    #'        Default: `NULL`.
    #' @param limit_alphabet The maximum number of different characters to keep in the alphabet.
    #'        Default: `NULL`.
    #' @param initial_alphabet A list of characters to include in the initial alphabet,
    #'        even if not seen in the training dataset. Default: `NULL`.
    #' @param continuing_subword_prefix A prefix to be used for every subword that is not a beginning-of-word.
    #'        Default: `NULL`.
    #' @param end_of_word_suffix A suffix to be used for every subword that is an end-of-word.
    #'        Default: `NULL`.
    #' @param max_token_length Prevents creating tokens longer than the specified size.
    #'        Default: `NULL`.
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

#' WordPiece tokenizer trainer
#' @export
#' @family trainer
trainer_wordpiece <- R6::R6Class(
  "tok_trainer_wordpiece",
  inherit = tok_trainer,
  public = list(
    #' @description
    #' Constructor for the WordPiece tokenizer trainer
    #' 
    #' @param vocab_size The size of the final vocabulary, including all tokens and alphabet.
    #'        Default: `NULL`.
    #' @param min_frequency The minimum frequency a pair should have in order to be merged.
    #'        Default: `NULL`.
    #' @param show_progress Whether to show progress bars while training. Default: `TRUE`.
    #' @param special_tokens A list of special tokens the model should be aware of.
    #'        Default: `NULL`.
    #' @param limit_alphabet The maximum number of different characters to keep in the alphabet.
    #'        Default: `NULL`.
    #' @param initial_alphabet A list of characters to include in the initial alphabet,
    #'        even if not seen in the training dataset. If the strings contain more than
    #'        one character, only the first one is kept. Default: `NULL`.
    #' @param continuing_subword_prefix A prefix to be used for every subword that is not a beginning-of-word.
    #'        Default: `NULL`.
    #' @param end_of_word_suffix A suffix to be used for every subword that is an end-of-word.
    #'        Default: `NULL`.
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

#' Unigram tokenizer trainer
#' @export
#' @family trainer
trainer_unigram <- R6::R6Class(
  "tok_trainer_unigram",
  inherit = tok_trainer,
  public = list(
    #' @description
    #' Constructor for the Unigram tokenizer
    #' @param vocab_size The size of the final vocabulary, including all tokens and alphabet.
    #' @param show_progress Whether to show progress bars while training.
    #' @param special_tokens A list of special tokens the model should be aware of.
    #' @param initial_alphabet A list of characters to include in the initial alphabet,
    #'        even if not seen in the training dataset. If the strings contain more than
    #'        one character, only the first one is kept.
    #' @param shrinking_factor The shrinking factor used at each step of training
    #'        to prune the vocabulary.
    #' @param unk_token The token used for out-of-vocabulary tokens.
    #' @param max_piece_length The maximum length of a given token.
    #' @param n_sub_iterations The number of iterations of the EM algorithm to perform
    #'        before pruning the vocabulary.
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