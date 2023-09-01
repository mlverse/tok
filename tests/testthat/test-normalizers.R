test_that("normalizers can be set", {
  tok <- tokenizer$new(model_bpe$new())
  tok$normalizer <- normalizer_nfc$new()
  expect_true(inherits(tok$normalizer, "tok_normalizer"))
  
  tok <- tokenizer$new(model_bpe$new())
  tok$normalizer <- normalizer_nfkc$new()
  expect_true(inherits(tok$normalizer, "tok_normalizer"))
})
