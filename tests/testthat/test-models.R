test_that("Can initialize a tokenizer different models", {
  models <- list(
    model_bpe$new(),
    model_wordpiece$new()
  )
  
  for (model in models) {
    tok <- tokenizer$new(model)
    expect_true(inherits(tok, "tok_tokenizer"))
  }
  
})
