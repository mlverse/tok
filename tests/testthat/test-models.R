test_that("Can initialize a tokenizer different models", {
  models <- list(
    model_bpe$new(),
    model_wordpiece$new(),
    model_unigram$new(),
    model_unigram$new(vocab = c("hello" = 10, "bye" = 12), 1L),
    model_unigram$new(vocab = list("hello" = 10, "bye" = 12), 1L)
  )
  
  for (model in models) {
    tok <- tokenizer$new(model)
    expect_true(inherits(tok, "tok_tokenizer"))
  }
})
