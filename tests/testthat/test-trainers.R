test_that("train a wordpiece tokenizer on files", {
  tmp <- tempfile()
  writeLines(c("hello world", "bye bye"), tmp)
  
  tok <- tokenizer$new(model_wordpiece$new())
  tok$pre_tokenizer <- pre_tokenizer_whitespace$new()
  tok$train(tmp, trainer_wordpiece$new())
  
  expect_true(is.integer(tok$encode("hello")$ids))
  expect_equal(length(unique(tok$encode("bye bye")$ids)), 1)
})