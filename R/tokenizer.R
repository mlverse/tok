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
      cli::cli_abort("This is a static method. Not available for tokenizers instances.")
    },
    
    #' @description 
    #' Instantiate a new Tokenizer from an existing file on the Hugging Face Hub.
    #' @param identifier The identifier of a Model on the Hugging Face Hub, that 
    #'    contains a tokenizer.json file
    #' @param revision  A branch or commit id
    #' @param auth_token An optional auth token used to access private repositories 
    #'    on the Hugging Face Hub
    from_pretrained = function(identifier, revision = "main", auth_token = NULL) {
      cli::cli_abort("This is a static method. Not available for tokenizers instances.")
    },
    
    #' @description
    #' Train the Tokenizer using the given files.
    #' Reads the files line by line, while keeping all the whitespace, even new lines. 
    #' @param trainer an instance of a trainer object, specific to that tokenizer type.
    #' @param files character vector of file paths.
    train = function(files, trainer) {
      if (!inherits(trainer, "tok_trainer"))
        cli::cli_abort("{.arg trainer} must inherit from {.cls tok_trainer}.")
      
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