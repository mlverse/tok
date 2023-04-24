test_that("Encoding", {
  expect_snapshot_error(encoding$new(1))
})

test_that("can get attributes from encoding", {
  
  tok <- tokenizer$from_file(test_path("assets/tokenizer.json"))
  encoding <- tok$encode("Hello world")
  
  expect_equal(encoding$ids, c(15496, 995))
  expect_equal(encoding$attention_mask, c(1,1))
})
