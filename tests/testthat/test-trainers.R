test_that("train different tokenizer models", {
  tmp <- tempfile()
  writeLines(c("hello world", "bye bye"), tmp)
  
  models <- list(
    list(model = model_wordpiece$new(), trainer = trainer_wordpiece$new()),
    list(model = model_unigram$new(), trainer = trainer_unigram$new()),
    list(model = model_bpe$new(), trainer = trainer_bpe$new())
  )
  
  for (model in models) {
    tok <- tokenizer$new(model$model)
    tok$pre_tokenizer <- pre_tokenizer_whitespace$new()
    tok$train(tmp, model$trainer)  
    
    expect_true(is.integer(tok$encode("hello")$ids))
    expect_true(all(table(tok$encode("bye bye")$ids) == 2))
  }
  
})