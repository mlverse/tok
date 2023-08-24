test_that("Can initialize a tokenizer from a bpe model", {
  tok <- tokenizer$new(model_bpe$new())
})
