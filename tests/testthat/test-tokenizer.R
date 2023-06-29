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