use extendr_api::*;
mod models;
mod tokenizer;

pub const VERSION: &str = env!("CARGO_PKG_VERSION");

extendr_module! {
    mod tok;
    use models;
    use tokenizer;
}