use extendr_api::*;
mod models;
mod tokenizer;

extendr_module! {
    mod tok;
    use models;
    use tokenizer;
}