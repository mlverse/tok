use extendr_api::*;
mod models;
mod tokenizer;
mod trainers;
mod pre_tokenizers;

pub const VERSION: &str = env!("CARGO_PKG_VERSION");

extendr_module! {
    mod tok;
    use models;
    use tokenizer;
    use trainers;
    use pre_tokenizers;
}