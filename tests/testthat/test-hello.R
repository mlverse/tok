test_that("Call to Rust function `hello_world()` works", {
  expect_equal(hello_world(), "Hello world!")
})
