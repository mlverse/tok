test_that("can set a pre_tokenizer for a tokenizer", {
  
  tok <- tokenizer$new(model_bpe$new())
  tok$pre_tokenizer <- pre_tokenizer_whitespace$new()
  
  expect_true(inherits(tok$pre_tokenizer, "tok_pre_tokenizer"))
  
})
