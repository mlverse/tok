test_that("can use a decoder", {
  
  tok <- tokenizer$new(model_bpe$new())
  tok$pre_tokenizer <- pre_tokenizer_byte_level$new(add_prefix_space = FALSE)
  
  text <- "model <- hello + world"
  tok$train_from_memory(text, trainer_bpe$new())
  
  expect_equal(
    tok$decode(tok$encode(text)$ids),
    "model Ġ<- Ġhello Ġ+ Ġworld"
  )
  
  tok$decoder <- decoder_byte_level$new()
  
  expect_equal(tok$decode(tok$encode(text)$ids), text)
})
