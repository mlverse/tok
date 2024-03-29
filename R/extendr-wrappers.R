# Generated by extendr: Do not edit by hand

# nolint start

#
# This file was created with the following call:
#   .Call("wrap__make_tok_wrappers", use_symbols = TRUE, package_name = "tok")

#' @docType package
#' @usage NULL
#' @useDynLib tok, .registration = TRUE
NULL

RModel <- new.env(parent = emptyenv())

RModel$new <- function(model) .Call(wrap__RModel__new, model)

#' @export
`$.RModel` <- function (self, name) { func <- RModel[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RModel` <- `$.RModel`

RModelBPE <- new.env(parent = emptyenv())

RModelBPE$new <- function(vocab, merges, cache_capacity, dropout, unk_token, continuing_subword_prefix, end_of_word_suffix, fuse_unk, byte_fallback) .Call(wrap__RModelBPE__new, vocab, merges, cache_capacity, dropout, unk_token, continuing_subword_prefix, end_of_word_suffix, fuse_unk, byte_fallback)

#' @export
`$.RModelBPE` <- function (self, name) { func <- RModelBPE[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RModelBPE` <- `$.RModelBPE`

RModelWordPiece <- new.env(parent = emptyenv())

RModelWordPiece$new <- function(vocab, unk_token, max_input_chars_per_word) .Call(wrap__RModelWordPiece__new, vocab, unk_token, max_input_chars_per_word)

#' @export
`$.RModelWordPiece` <- function (self, name) { func <- RModelWordPiece[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RModelWordPiece` <- `$.RModelWordPiece`

RModelUnigram <- new.env(parent = emptyenv())

RModelUnigram$new <- function(vocab, unk_id, byte_fallback) .Call(wrap__RModelUnigram__new, vocab, unk_id, byte_fallback)

#' @export
`$.RModelUnigram` <- function (self, name) { func <- RModelUnigram[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RModelUnigram` <- `$.RModelUnigram`

REncoding <- new.env(parent = emptyenv())

REncoding$len <- function() .Call(wrap__REncoding__len, self)

REncoding$get_ids <- function() .Call(wrap__REncoding__get_ids, self)

REncoding$get_tokens <- function() .Call(wrap__REncoding__get_tokens, self)

REncoding$get_type_ids <- function() .Call(wrap__REncoding__get_type_ids, self)

REncoding$get_attention_mask <- function() .Call(wrap__REncoding__get_attention_mask, self)

REncoding$get_special_tokens_mask <- function() .Call(wrap__REncoding__get_special_tokens_mask, self)

REncoding$get_word_ids <- function() .Call(wrap__REncoding__get_word_ids, self)

#' @export
`$.REncoding` <- function (self, name) { func <- REncoding[[name]]; environment(func) <- environment(); func }

#' @export
`[[.REncoding` <- `$.REncoding`

RTokenizer <- new.env(parent = emptyenv())

RTokenizer$new <- function(tokenizer) .Call(wrap__RTokenizer__new, tokenizer)

RTokenizer$from_file <- function(path) .Call(wrap__RTokenizer__from_file, path)

RTokenizer$from_model <- function(model) .Call(wrap__RTokenizer__from_model, model)

RTokenizer$encode <- function(sequence, pair, is_pretokenized, add_special_tokens) .Call(wrap__RTokenizer__encode, self, sequence, pair, is_pretokenized, add_special_tokens)

RTokenizer$decode <- function(ids, skip_special_tokens) .Call(wrap__RTokenizer__decode, self, ids, skip_special_tokens)

RTokenizer$encode_batch <- function(input, is_pretokenized, add_special_tokens) .Call(wrap__RTokenizer__encode_batch, self, input, is_pretokenized, add_special_tokens)

RTokenizer$decode_batch <- function(ids, skip_special_tokens) .Call(wrap__RTokenizer__decode_batch, self, ids, skip_special_tokens)

RTokenizer$set_pre_tokenizer <- function(pre_tokenizer) invisible(.Call(wrap__RTokenizer__set_pre_tokenizer, self, pre_tokenizer))

RTokenizer$get_pre_tokenizer <- function() .Call(wrap__RTokenizer__get_pre_tokenizer, self)

RTokenizer$set_post_processor <- function(post_processors) invisible(.Call(wrap__RTokenizer__set_post_processor, self, post_processors))

RTokenizer$get_post_processor <- function() .Call(wrap__RTokenizer__get_post_processor, self)

RTokenizer$set_normalizer <- function(normalizer) invisible(.Call(wrap__RTokenizer__set_normalizer, self, normalizer))

RTokenizer$get_normalizer <- function() .Call(wrap__RTokenizer__get_normalizer, self)

RTokenizer$set_decoder <- function(decoder) invisible(.Call(wrap__RTokenizer__set_decoder, self, decoder))

RTokenizer$get_decoder <- function() .Call(wrap__RTokenizer__get_decoder, self)

RTokenizer$train_from_files <- function(trainer, files) invisible(.Call(wrap__RTokenizer__train_from_files, self, trainer, files))

RTokenizer$train_from_sequences <- function(trainer, sequences) invisible(.Call(wrap__RTokenizer__train_from_sequences, self, trainer, sequences))

RTokenizer$save <- function(path, pretty) invisible(.Call(wrap__RTokenizer__save, self, path, pretty))

RTokenizer$enable_padding <- function(padding) invisible(.Call(wrap__RTokenizer__enable_padding, self, padding))

RTokenizer$get_padding <- function() .Call(wrap__RTokenizer__get_padding, self)

RTokenizer$no_padding <- function() invisible(.Call(wrap__RTokenizer__no_padding, self))

RTokenizer$enable_truncation <- function(truncation) invisible(.Call(wrap__RTokenizer__enable_truncation, self, truncation))

RTokenizer$get_truncation <- function() .Call(wrap__RTokenizer__get_truncation, self)

RTokenizer$no_truncation <- function() invisible(.Call(wrap__RTokenizer__no_truncation, self))

RTokenizer$get_vocab_size <- function(with_added_tokens) .Call(wrap__RTokenizer__get_vocab_size, self, with_added_tokens)

#' @export
`$.RTokenizer` <- function (self, name) { func <- RTokenizer[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RTokenizer` <- `$.RTokenizer`

RTrainer <- new.env(parent = emptyenv())

RTrainer$new <- function(trainer) .Call(wrap__RTrainer__new, trainer)

#' @export
`$.RTrainer` <- function (self, name) { func <- RTrainer[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RTrainer` <- `$.RTrainer`

RTrainerBPE <- new.env(parent = emptyenv())

RTrainerBPE$new <- function(vocab_size, min_frequency, show_progress, special_tokens, limit_alphabet, initial_alphabet, continuing_subword_prefix, end_of_word_suffix, max_token_length) .Call(wrap__RTrainerBPE__new, vocab_size, min_frequency, show_progress, special_tokens, limit_alphabet, initial_alphabet, continuing_subword_prefix, end_of_word_suffix, max_token_length)

#' @export
`$.RTrainerBPE` <- function (self, name) { func <- RTrainerBPE[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RTrainerBPE` <- `$.RTrainerBPE`

RTrainerWordPiece <- new.env(parent = emptyenv())

RTrainerWordPiece$new <- function(vocab_size, min_frequency, show_progress, special_tokens, limit_alphabet, initial_alphabet, continuing_subword_prefix, end_of_word_suffix) .Call(wrap__RTrainerWordPiece__new, vocab_size, min_frequency, show_progress, special_tokens, limit_alphabet, initial_alphabet, continuing_subword_prefix, end_of_word_suffix)

#' @export
`$.RTrainerWordPiece` <- function (self, name) { func <- RTrainerWordPiece[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RTrainerWordPiece` <- `$.RTrainerWordPiece`

RTrainerUnigram <- new.env(parent = emptyenv())

RTrainerUnigram$new <- function(vocab_size, show_progress, special_tokens, initial_alphabet, shrinking_factor, unk_token, max_piece_length, n_sub_iterations) .Call(wrap__RTrainerUnigram__new, vocab_size, show_progress, special_tokens, initial_alphabet, shrinking_factor, unk_token, max_piece_length, n_sub_iterations)

#' @export
`$.RTrainerUnigram` <- function (self, name) { func <- RTrainerUnigram[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RTrainerUnigram` <- `$.RTrainerUnigram`

RPreTokenizer <- new.env(parent = emptyenv())

RPreTokenizer$new <- function(pre_tokenizer) .Call(wrap__RPreTokenizer__new, pre_tokenizer)

#' @export
`$.RPreTokenizer` <- function (self, name) { func <- RPreTokenizer[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RPreTokenizer` <- `$.RPreTokenizer`

RPreTokenizerWhitespace <- new.env(parent = emptyenv())

RPreTokenizerWhitespace$new <- function() .Call(wrap__RPreTokenizerWhitespace__new)

#' @export
`$.RPreTokenizerWhitespace` <- function (self, name) { func <- RPreTokenizerWhitespace[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RPreTokenizerWhitespace` <- `$.RPreTokenizerWhitespace`

RPreTokenizerByteLevel <- new.env(parent = emptyenv())

RPreTokenizerByteLevel$new <- function(add_prefix_space, use_regex) .Call(wrap__RPreTokenizerByteLevel__new, add_prefix_space, use_regex)

#' @export
`$.RPreTokenizerByteLevel` <- function (self, name) { func <- RPreTokenizerByteLevel[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RPreTokenizerByteLevel` <- `$.RPreTokenizerByteLevel`

RNormalizer <- new.env(parent = emptyenv())

RNormalizer$new <- function(normalizer) .Call(wrap__RNormalizer__new, normalizer)

#' @export
`$.RNormalizer` <- function (self, name) { func <- RNormalizer[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RNormalizer` <- `$.RNormalizer`

RNormalizerNFC <- new.env(parent = emptyenv())

RNormalizerNFC$new <- function() .Call(wrap__RNormalizerNFC__new)

#' @export
`$.RNormalizerNFC` <- function (self, name) { func <- RNormalizerNFC[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RNormalizerNFC` <- `$.RNormalizerNFC`

RNormalizerNFKC <- new.env(parent = emptyenv())

RNormalizerNFKC$new <- function() .Call(wrap__RNormalizerNFKC__new)

#' @export
`$.RNormalizerNFKC` <- function (self, name) { func <- RNormalizerNFKC[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RNormalizerNFKC` <- `$.RNormalizerNFKC`

RPostProcessor <- new.env(parent = emptyenv())

RPostProcessor$new <- function(post_processor) .Call(wrap__RPostProcessor__new, post_processor)

#' @export
`$.RPostProcessor` <- function (self, name) { func <- RPostProcessor[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RPostProcessor` <- `$.RPostProcessor`

RPostProcessorByteLevel <- new.env(parent = emptyenv())

RPostProcessorByteLevel$new <- function(trim_offsets) .Call(wrap__RPostProcessorByteLevel__new, trim_offsets)

#' @export
`$.RPostProcessorByteLevel` <- function (self, name) { func <- RPostProcessorByteLevel[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RPostProcessorByteLevel` <- `$.RPostProcessorByteLevel`

RDecoder <- new.env(parent = emptyenv())

RDecoder$new <- function(decoder) .Call(wrap__RDecoder__new, decoder)

#' @export
`$.RDecoder` <- function (self, name) { func <- RDecoder[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RDecoder` <- `$.RDecoder`

RDecoderByteLevel <- new.env(parent = emptyenv())

RDecoderByteLevel$new <- function() .Call(wrap__RDecoderByteLevel__new)

#' @export
`$.RDecoderByteLevel` <- function (self, name) { func <- RDecoderByteLevel[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RDecoderByteLevel` <- `$.RDecoderByteLevel`


# nolint end
