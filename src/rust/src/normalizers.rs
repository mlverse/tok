use extendr_api::prelude::*;
use tokenizers as tk;

pub struct RNormalizer(pub tk::NormalizerWrapper);

#[extendr]
impl RNormalizer {
    pub fn new(normalizer: Robj) -> extendr_api::Result<Self> {
        if normalizer.inherits("RNormalizerNFC") {
            unsafe {
                let ptr = normalizer.external_ptr_addr() as *mut RNormalizerNFC;
                Ok(RNormalizer((*ptr).0.clone().into()))
            }
        } else if normalizer.inherits("RNormalizerNFKC") {
            unsafe {
                let ptr = normalizer.external_ptr_addr() as *mut RNormalizerNFKC;
                Ok(RNormalizer((*ptr).0.clone().into()))
            }
        } else {
            Err(Error::EvalError("Unsupported normalizer".into()))
        }
    }
}

struct RNormalizerNFC(tk::normalizers::NFC);

#[extendr]
impl RNormalizerNFC {
    pub fn new() -> Self {
        RNormalizerNFC(tk::normalizers::NFC::default())
    }
}

struct RNormalizerNFKC(tk::normalizers::NFKC);

#[extendr]
impl RNormalizerNFKC {
    pub fn new() -> Self {
        RNormalizerNFKC(tk::normalizers::NFKC::default())
    }
}

extendr_module! {
    mod normalizers;
    impl RNormalizer;
    impl RNormalizerNFC;
    impl RNormalizerNFKC;
}
