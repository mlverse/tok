use extendr_api::*;
mod decoders;
mod models;
mod normalizers;
mod post_processors;
mod pre_tokenizers;
mod tokenizer;
mod trainers;

pub const VERSION: &str = env!("CARGO_PKG_VERSION");

extendr_module! {
    mod tok;
    use models;
    use tokenizer;
    use trainers;
    use pre_tokenizers;
    use normalizers;
    use post_processors;
    use decoders;
}
