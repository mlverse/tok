use extendr_api::prelude::*;
use tokenizers as tk;
#[extendr]
pub struct RNormalizer(pub tk::NormalizerWrapper);

#[extendr]
impl RNormalizer {
    pub fn new(normalizer: Robj) -> extendr_api::Result<Self> {
        if normalizer.inherits("RNormalizerNFC") {
            Ok(RNormalizer(
                <&RNormalizerNFC>::try_from(&normalizer)?.0.clone().into()
            ))
        } else if normalizer.inherits("RNormalizerNFKC") {
            Ok(RNormalizer(
                <&RNormalizerNFKC>::try_from(&normalizer)?.0.clone().into()
            ))
        } else {
            Err(Error::EvalError("Unsupported normalizer".into()))
        }
    }
}

#[extendr]
struct RNormalizerNFC(tk::normalizers::NFC);

#[extendr]
impl RNormalizerNFC {
    pub fn new() -> Self {
        RNormalizerNFC(tk::normalizers::NFC::default())
    }
}

#[extendr]
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
