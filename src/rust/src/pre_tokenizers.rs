use extendr_api::prelude::*;
use tokenizers as tk;

pub struct RPreTokenizer(pub tk::PreTokenizerWrapper);

#[extendr]
impl RPreTokenizer {
    pub fn new(pre_tokenizer: Robj) -> extendr_api::Result<Self> {
        if pre_tokenizer.inherits("RPreTokenizerWhitespace") {
            unsafe {
                let ptr = pre_tokenizer.external_ptr_addr() as *mut RPreTokenizerWhitespace;
                Ok(RPreTokenizer((*ptr).0.clone().into()))
            }
        } else {
            Err(Error::EvalError("Tokenizer not supported".into()))
        }
    }
}

struct RPreTokenizerWhitespace(tk::pre_tokenizers::whitespace::Whitespace);

#[extendr]
impl RPreTokenizerWhitespace {
    pub fn new() -> Self {
        RPreTokenizerWhitespace(tk::pre_tokenizers::whitespace::Whitespace::default())
    }
}

extendr_module! {
    mod pre_tokenizers;
    impl RPreTokenizer;
    impl RPreTokenizerWhitespace;
}
