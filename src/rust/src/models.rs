use extendr_api::{prelude::*};
use std::sync::{Arc, RwLock};
use tokenizers as tk;
use tk::models::{ModelWrapper};
use tk::models::bpe::BPE;
use extendr_api::Error;

struct RModel {
    pub model: Arc<RwLock<ModelWrapper>>,
}

#[extendr]
impl RModel {
    pub fn new(model: Robj) -> extendr_api::Result<Self> {
        if model.inherits("RModelBPE") {
            unsafe{
                let ptr = model.external_ptr_addr() as *mut RModelBPE;
                Ok(RModel {
                    model: Arc::new(RwLock::new((*ptr).model.clone().into())),
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
    pub fn new(vocab: RVocab, merges: RMerges) -> Self {
        RModelBPE {
            model: BPE::new(vocab.0, merges.0),
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
