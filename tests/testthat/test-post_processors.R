test_that("Can use a post processor", {
  
  tok <- tokenizer$new(model_bpe$new())
  tok$pre_tokenizer <- pre_tokenizer_byte_level$new()
  
  text <- "model <- hello + world"
  tok$train_from_memory(text, trainer_bpe$new())
  
  expect_equal(
    tok$decode(tok$encode(text)$ids),
    "Ġmodel Ġ<- Ġhello Ġ+ Ġworld"
  )
  
  tok <- tokenizer$new(model_bpe$new())
  tok$pre_tokenizer <- pre_tokenizer_byte_level$new()
  
  text <- "model <- hello + world"
  tok$train_from_memory(text, trainer_bpe$new())
  
  tok$post_processor <- processor_byte_level$new(trim_offsets = FALSE)
  
  expect_equal(tok$decode(tok$encode(text)$ids), "Ġmodel Ġ<- Ġhello Ġ+ Ġworld")
  
})
