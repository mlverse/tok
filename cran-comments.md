Fixes:

For the HTML refman generated via tools::pkg2HTML() we now get

line 827 column 1 - Warning: <a> anchor "method-tok_normalizer_nfc-new" already defined
line 843 column 1 - Warning: <a> anchor "method-tok_normalizer_nfc-clone" already defined
line 1130 column 1 - Warning: <a> anchor "method-tok_pre_tokenizer_whitespace-new" already defined
line 1146 column 1 - Warning: <a> anchor
"method-tok_pre_tokenizer_whitespace-clone" already defined

the first apparently from

./man/normalizer_nfkc.Rd:\item \href{#method-tok_normalizer_nfc-new}{\code{normalizer_nfkc$new()}}
./man/normalizer_nfc.Rd:\item \href{#method-tok_normalizer_nfc-new}{\code{normalizer_nfc$new()}}