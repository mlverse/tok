#' Tokenizer
#' @description 
#' A Tokenizer works as a pipeline. It processes some raw text as input and outputs 
#' an [encoding].
#' 
#' @importFrom R6 R6Class
#' @importFrom cli cli_abort
#' 
#' @examples
#' withr::with_envvar(c(HUGGINGFACE_HUB_CACHE = tempdir()), {
#' try({
#' tok <- tokenizer$from_pretrained("gpt2")
#' tok$encode("Hello world")$ids
#' })
#' })
#' 
#' @returns
#' A tokenizer that can be used for encoding character strings or decoding
#' integers.
#' 
#' @export
tokenizer <- R6::R6Class(
  classname = "tok_tokenizer",
  public = list(
    #' @field .tokenizer (unsafe usage) Lower level pointer to tokenizer
    .tokenizer = NULL,
    
    #' @description Initializes a tokenizer
    #' @param tokenizer Will be cloned to initialize a new tokenizer
    initialize = function(tokenizer) {
      if (inherits(tokenizer, "RTokenizer")) {
        self$.tokenizer <- tokenizer
      } else if (inherits(tokenizer, "tok_model")) {
        self$.tokenizer <- RTokenizer$from_model(tokenizer$.model)
      } else {
        self$.tokenizer <- RTokenizer$new(tokenizer$.tokenizer)
      }
    },
    
    #' @description 
    #' Encode the given sequence and pair. This method can process raw text sequences
    #' as well as already pre-tokenized sequences.
    #' @param sequence The main input sequence we want to encode. This sequence can 
    #'  be either raw text or pre-tokenized, according to the is_pretokenized argument
    #' @param pair An optional input sequence. The expected format is the same 
    #'  that for sequence.
    #' @param is_pretokenized Whether the input is already pre-tokenized
    #' @param add_special_tokens Whether to add the special tokens
    encode = function(sequence, pair = NULL, is_pretokenized = FALSE, add_special_tokens = TRUE) {
      self$.tokenizer$encode(sequence, pair, is_pretokenized, add_special_tokens)
    },
    
    #' @description 
    #' Decode the given list of ids back to a string
    #' @param ids The list of ids that we want to decode
    #' @param skip_special_tokens Whether the special tokens should be removed from the decoded string
    decode = function(ids, skip_special_tokens = TRUE) {
      self$.tokenizer$decode(ids, skip_special_tokens)
    },
    
    #' @description 
    #' Encodes a batch of sequences. Returns a list of [encoding]s.
    #' @param input A list of single sequences or pair sequences to encode. Each 
    #'  sequence can be either raw text or pre-tokenized, according to the is_pretokenized 
    #'  argument.
    #' @param is_pretokenized Whether the input is already pre-tokenized
    #' @param add_special_tokens Whether to add the special tokens
    encode_batch = function(input, is_pretokenized = FALSE, add_special_tokens = TRUE) {
      self$.tokenizer$encode_batch(input, is_pretokenized, add_special_tokens)
    },
    
    #' @description 
    #' Decode a batch of ids back to their corresponding string
    #' @param sequences The batch of sequences we want to decode
    #' @param skip_special_tokens Whether the special tokens should be removed from the decoded strings
    decode_batch = function(sequences, skip_special_tokens = TRUE) {
      self$.tokenizer$decode_batch(sequences, skip_special_tokens)
    },
    
    #' @description 
    #' Creates a tokenizer from the path of a serialized tokenizer.
    #' This is a static method and should be called instead of `$new` when initializing
    #' the tokenizer.
    #' @param path Path to tokenizer.json file
    from_file = function(path) {
      cli::cli_abort(gettext("This is a static method. Not available for tokenizers instances."))
    },
    
    #' @description 
    #' Instantiate a new Tokenizer from an existing file on the Hugging Face Hub.
    #' @param identifier The identifier of a Model on the Hugging Face Hub, that 
    #'    contains a tokenizer.json file
    #' @param revision  A branch or commit id
    #' @param auth_token An optional auth token used to access private repositories 
    #'    on the Hugging Face Hub
    from_pretrained = function(identifier, revision = "main", auth_token = NULL) {
      cli::cli_abort(gettext("This is a static method. Not available for tokenizers instances."))
    },
    
    #' @description
    #' Train the Tokenizer using the given files.
    #' Reads the files line by line, while keeping all the whitespace, even new lines. 
    #' @param trainer an instance of a trainer object, specific to that tokenizer type.
    #' @param files character vector of file paths.
    train = function(files, trainer) {
      if (!inherits(trainer, "tok_trainer"))
        cli::cli_abort(gettext("{.arg trainer} must inherit from {.cls tok_trainer}."))
      
      self$.tokenizer$train_from_files(trainer$.trainer, normalizePath(files))
    },
    
    #' @description 
    #' Train the tokenizer on a chracter vector of texts
    #' @param texts a character vector of texts.
    #' @param trainer an instance of a trainer object, specific to that tokenizer type.
    train_from_memory = function(texts, trainer) {
      self$.tokenizer$train_from_sequences(trainer$.trainer, texts)
    },
    
    #' @description
    #' Saves the tokenizer to a json file
    #' @param path  A path to a file in which to save the serialized tokenizer.
    #' @param pretty Whether the JSON file should be pretty formatted.
    save = function(path, pretty = TRUE) {
      self$.tokenizer$save(normalizePath(path, mustWork = FALSE), pretty)
    },
    
    #' @description
    #' Enables padding for the tokenizer
    #' @param direction (str, optional, defaults to right) — The direction in which
    #'  to pad. Can be either `'right'` or `'left'`
    #' @param pad_to_multiple_of  (int, optional) — If specified, the padding length should 
    #'  always snap to the next multiple of the given value. For example if we were 
    #'  going to pad with a length of 250 but `pad_to_multiple_of=8` then we will 
    #'  pad to 256.
    #' @param pad_id (int, defaults to 0) — The id to be used when padding
    #' @param pad_type_id (int, defaults to 0) — The type id to be used when padding
    #' @param pad_token (str, defaults to `'[PAD]'`) — The pad token to be used when padding
    #' @param length (int, optional) — If specified, the length at which to pad. If not 
    #'  specified we pad using the size of the longest sequence in a batch.
    enable_padding = function(direction = "right", pad_id = 0L, pad_type_id = 0L, 
                             pad_token = "[PAD]", length = NULL, pad_to_multiple_of = NULL) {
      inputs <- list(
        direction = direction,
        pad_id = as.integer(pad_id),
        pad_token = pad_token,
        length = as.integer(length),
        pad_to_multiple_of = pad_to_multiple_of
      )
      inputs <- Filter(Negate(is.null), inputs)
      self$.tokenizer$enable_padding(inputs)
    },
    
    #' @description
    #' Disables padding
    no_padding = function() {
      self$.tokenizer$no_padding()
    },
    
    #' @description
    #' Enables truncation on the tokenizer
    #' @param max_length The maximum length at which to truncate.
    #' @param stride The length of the previous first sequence to be included
    #'        in the overflowing sequence. Default: `0`.
    #' @param strategy The strategy used for truncation. Can be one of:
    #'        "longest_first", "only_first", or "only_second". Default: "longest_first".
    #' @param direction The truncation direction. Default: "right".
    enable_truncation = function(max_length, stride = 0, strategy = "longest_first",
                                 direction = "right") {
      self$.tokenizer$enable_truncation(list(
        max_length = as.integer(max_length),
        stride = as.integer(stride),
        strategy = strategy,
        direction = direction
      ))
    },
    
    #' @description
    #' Disables truncation
    no_truncation = function() {
     self$.tokenizer$no_truncation() 
    },
    #' @description
    #' Gets the vocabulary size
    #' @param with_added_tokens Wether to count added tokens
    get_vocab_size = function(with_added_tokens = TRUE) {
     self$.tokenizer$get_vocab_size(with_added_tokens) 
    }
  ),
  active = list(
    #' @field pre_tokenizer instance of the pre-tokenizer
    pre_tokenizer = function(x) {
      if (missing(x)) {
        return(self$.tokenizer$get_pre_tokenizer())
      } 
      
      self$.tokenizer$set_pre_tokenizer(x$.pre_tokenizer)
      invisible(self$pre_tokenizer)
    },
    #' @field normalizer Gets the normalizer instance
    normalizer = function(x) {
      if (missing(x)) {
        return(self$.tokenizer$get_normalizer())
      } 
      
      self$.tokenizer$set_normalizer(x$.normalizer)
      invisible(self$normalizer)
    },
    #' @field post_processor Gets the post processor used by tokenizer
    post_processor = function(x) {
      if (missing(x)) {
        return(self$.tokenizer$get_post_processor())
      } 
      
      self$.tokenizer$set_post_processor(x$.processor)
      invisible(self$post_processor)
    },
    #' @field decoder Gets and sets the decoder
    decoder = function(x) {
      if (missing(x)) {
        return(self$.tokenizer$get_decoder())
      }
      
      self$.tokenizer$set_decoder(x$.decoder)
      invisible(self$decoder)
    },
    #' @field padding Gets padding configuration
    padding = function(x) {
      if (!missing(x)) {
        cli::cli_abort(gettext("Can't be set this way, use {.fn enable_padding}."))
      }
      
      self$.tokenizer$get_padding()
    },
    #' @field truncation Gets truncation configuration
    truncation = function(x) {
      if (!missing(x)) {
        cli::cli_abort(gettext("Can't be set this way, use {.fn enable_truncation}."))
      }
      
      self$.tokenizer$get_truncation()
    }
  )
)

tokenizer$from_file <- function(path) {
  path <- path.expand(path)
  tokenizer$new(RTokenizer$from_file(path))
}

tokenizer$from_pretrained <- function(identifier, revision = "main", auth_token = NULL) {
  if (!is.null(auth_token))
    withr::local_envvar(c(HUGGINGFACE_HUB_TOKEN = auth_token))
  
  rlang::check_installed("hfhub")
  path <- hfhub::hub_download(identifier, revision = revision, "tokenizer.json")
  
  tokenizer$new(RTokenizer$from_file(path))
}