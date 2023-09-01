test_that("Can use a tokenizer from a file", {
  
  tok <- tokenizer$from_file(test_path("assets/tokenizer.json"))
  input <- "hello world"
  enc <- tok$encode(input)
  
  expect_equal(enc$ids, c(31373, 995))
  expect_equal(class(enc$ids), "integer")
  
  expect_equal(tok$decode(enc$ids), input)
})

test_that("batch encoder/decoder", {
  
  tok <- tokenizer$from_file(test_path("assets/tokenizer.json"))
  input <- c("hello world", "world hello")
  
  enc <- tok$encode_batch(input)
  
  # returns a list of encoding objects
  expect_equal(class(enc), "list")
  expect_equal(class(enc[[1]]), c("tok_encoding", "R6"))
  
  sequences <- lapply(enc, function(x) x$ids)
  
  expect_equal(tok$decode_batch(sequences), input)
})

test_that("from_pretrained", {
  skip_on_cran()
  tok <- tokenizer$from_pretrained("gpt2")
  input <- "hello world"
  enc <- tok$encode(input)
  
  expect_equal(tok$decode(enc$ids), input)
})

test_that("train a tokenizer on files", {
  
  tmp <- tempfile()
  writeLines(c("hello world", "bye bye"), tmp)
  
  tok <- tokenizer$new(model_bpe$new())
  tok$pre_tokenizer <- pre_tokenizer_whitespace$new()
  tok$train(tmp, trainer_bpe$new())
  
  expect_equal(tok$encode("hello")$ids, 17)
  expect_equal(tok$encode("world")$ids, 18)
  expect_equal(tok$encode("bye bye")$ids, c(10, 10))
})

test_that("can train a tokenizer from memory", {
  
  tok <- tokenizer$new(model_bpe$new())
  tok$pre_tokenizer <- pre_tokenizer_whitespace$new()
  tok$train_from_memory(c("hello world", "bye bye"), trainer_bpe$new())
  expect_equal(tok$get_vocab_size(), 19)
  
  expect_equal(tok$encode("hello")$ids, 17)
  expect_equal(tok$encode("world")$ids, 18)
  expect_equal(tok$encode("bye bye")$ids, c(10, 10))
  
  tok <- tokenizer$new(model_bpe$new())
  text <- "model <- hello + world"
  tok$train_from_memory(text, trainer_bpe$new())
  expect_equal(
    tok$decode(tok$encode(text)$ids),
    text
  )
})



test_that("can serialize a tokenizer and load back", {
  
  tok <- tokenizer$from_file(test_path("assets/tokenizer.json"))
  input <- "hello world"
  enc <- tok$encode(input)
  
  tmp <- tempfile(fileext = ".json")
  tok$save(tmp)
  
  tok2 <- tokenizer$from_file(tmp)
  enc2 <- tok$encode(input)
  
  expect_equal(enc$ids, enc2$ids)
})

test_that("enable padding works", {
  tok <- tokenizer$from_file(test_path("assets/tokenizer.json"))
  
  expect_null(tok$padding)
  
  tok$enable_padding(length = 20, pad_id = 5)
  input <- "hello world"
  enc <- tok$encode(input)
  
  expect_equal(length(enc$ids), 20)
  expect_equal(enc$ids[3], 5)
  
  expect_equal(tok$padding$length, 20)
  
  tok$no_padding()
  expect_null(tok$padding)
})

test_that("truncation works", {
  
  tok <- tokenizer$from_file(test_path("assets/tokenizer.json"))
  expect_null(tok$truncation)
  
  tok$enable_truncation(3)
  
  input <- "hello world I'm a new tokenizer called tok"
  enc <- tok$encode(input)
  
  expect_equal(length(enc$ids), 3)
  
  tok$no_truncation()
  expect_null(tok$padding)
  
  enc <- tok$encode(input)
  expect_true(length(enc$ids) > 3)
  
})