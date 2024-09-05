test_that("R-level cli_abort messages are correctly translated in FR", {
  withr::with_envvar(c(HUGGINGFACE_HUB_CACHE = tempdir()), {
    try({
      tok <- tokenizer$from_pretrained("gpt2")
      temp_json <- tempfile(fileext = ".json")
      withr::with_language(lang = "fr",
                           expect_error(
                             tok$train(temp_json, temp_json),
                             regexp = "doit hériter de",
                             fixed = TRUE
                           ))
    })
  })
  
})