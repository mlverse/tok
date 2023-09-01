use extendr_api::*;
mod models;
mod pre_tokenizers;
mod tokenizer;
mod trainers;
mod normalizers;

pub const VERSION: &str = env!("CARGO_PKG_VERSION");

extendr_module! {
    mod tok;
    use models;
    use tokenizer;
    use trainers;
    use pre_tokenizers;
    use normalizers;
}
