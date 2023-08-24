use tokenizers as tk;
use tk::models::ModelWrapper;
use tk::models::bpe::BPE;
use extendr_api::Error;
use extendr_api::prelude::*;

pub struct RModel {
    pub model: ModelWrapper,
}

#[extendr]
impl RModel {
    pub fn new(model: Robj) -> extendr_api::Result<Self> {
        if model.inherits("RModelBPE") {
            unsafe{
                let ptr = model.external_ptr_addr() as *mut RModelBPE;
                Ok(RModel {
                    model: (*ptr).model.clone().into()
                })
            }
        } else {
            Err(Error::EvalError("Model not supported".into()))
        }
    }
}

struct RModelBPE {
    pub model: BPE,
}

#[extendr]
impl RModelBPE {
    pub fn new(vocab: Nullable<RVocab>, merges: Nullable<RMerges>, cache_capacity: Nullable<i32>, dropout: Nullable<f32>, unk_token: Nullable<String>, continuing_subword_prefix: Nullable<String>, end_of_word_suffix: Nullable<String>, 
        fuse_unk: Nullable<bool>, byte_fallback: Nullable<bool>) -> Self {

        let mut bpe = tk::models::bpe::BPE::builder();

        if let (NotNull(vocab), NotNull(merges)) = (vocab, merges) {
            bpe = bpe.vocab_and_merges(vocab.0, merges.0);
        }

        if let NotNull(cache_capacity) = cache_capacity {
            bpe = bpe.cache_capacity(cache_capacity as usize);
        }

        if let NotNull(dropout) = dropout {
            bpe = bpe.dropout(dropout);
        }

        if let NotNull(unk_token) = unk_token {
            bpe = bpe.unk_token(unk_token);
        }

        if let NotNull(continuing_subword_prefix) = continuing_subword_prefix {
            bpe = bpe.continuing_subword_prefix(continuing_subword_prefix);
        }

        if let NotNull(end_of_word_suffix) = end_of_word_suffix {
            bpe = bpe.end_of_word_suffix(end_of_word_suffix);
        }

        if let NotNull(fuse_unk) = fuse_unk {
            bpe = bpe.fuse_unk(fuse_unk);
        }

        if let NotNull(byte_fallback) = byte_fallback {
            bpe = bpe.byte_fallback(byte_fallback);
        }
   
        RModelBPE {
            model: bpe.build().unwrap()
        }
    }
}

struct RVocab(tk::models::bpe::Vocab);

impl<'a> FromRobj<'a> for RVocab {
    fn from_robj (robj: &'a Robj) -> std::result::Result<Self, &'static str> {
        if let Some(val) = robj.as_list() {
            let mut vocab = tk::models::bpe::Vocab::default();
            for (key, value) in val {
                let key = String::from(key);
                let value = value.as_integer().ok_or("List items must be integer values")? as u32;
                vocab.insert(key, value);
            }
            Ok(RVocab(vocab))
        } else {
            return Err("Expected a named list.");
        }
    }
}

struct RMerges(tk::models::bpe::Merges);

impl<'a> FromRobj<'a> for RMerges {
    fn from_robj (robj: &'a Robj) -> std::result::Result<Self, &'static str> {
        if let Some(val) = robj.as_list() {
            let mut merges = tk::models::bpe::Merges::default();
            for (_, value) in val {
                // values must be a length 2 R list
                if let Some(item) = value.as_list() {
                    if item.len() != 2 {
                        return Err("Expected a list of length 2");
                    }
                    let first = item[0].as_str().ok_or("List items must be string values")?;
                    let second = item[1].as_str().ok_or("List items must be string values")?;
                    merges.push((first.to_string(), second.to_string()));
                } else {
                    return Err("Expected a list");
                }
            }
            Ok(RMerges(merges))
        } else {
            return Err("Expected a list.");
        }
    }
}

extendr_module! {
    mod models;
    impl RModel;
    impl RModelBPE;
}
