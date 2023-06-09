# Generated by extendr: Do not edit by hand
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

RModelBPE$new <- function(vocab, merges) .Call(wrap__RModelBPE__new, vocab, merges)

#' @export
`$.RModelBPE` <- function (self, name) { func <- RModelBPE[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RModelBPE` <- `$.RModelBPE`

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

RTokenizer$encode <- function(sequence, pair, is_pretokenized, add_special_tokens) .Call(wrap__RTokenizer__encode, self, sequence, pair, is_pretokenized, add_special_tokens)

RTokenizer$decode <- function(ids, skip_special_tokens) .Call(wrap__RTokenizer__decode, self, ids, skip_special_tokens)

RTokenizer$encode_batch <- function(input, is_pretokenized, add_special_tokens) .Call(wrap__RTokenizer__encode_batch, self, input, is_pretokenized, add_special_tokens)

RTokenizer$decode_batch <- function(ids, skip_special_tokens) .Call(wrap__RTokenizer__decode_batch, self, ids, skip_special_tokens)

#' @export
`$.RTokenizer` <- function (self, name) { func <- RTokenizer[[name]]; environment(func) <- environment(); func }

#' @export
`[[.RTokenizer` <- `$.RTokenizer`

