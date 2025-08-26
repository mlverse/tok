use extendr_api::prelude::*;
use tokenizers as tk;

#[extendr]
pub struct RDecoder(pub tk::DecoderWrapper);

#[extendr]
impl RDecoder {
    pub fn new(decoder: Robj) -> extendr_api::Result<Self> {
        if decoder.inherits("RDecoderByteLevel") {
            Ok(RDecoder(<&RDecoderByteLevel>::try_from(&decoder)?.0.clone().into()))
        } else {
            Err(Error::EvalError("Unsupported decoder".into()))
        }
    }
}
#[extendr]
struct RDecoderByteLevel(tk::decoders::byte_level::ByteLevel);

#[extendr]
impl RDecoderByteLevel {
    pub fn new() -> Self {
        RDecoderByteLevel(tk::decoders::byte_level::ByteLevel::default())
    }
}

extendr_module! {
    mod decoders;
    impl RDecoder;
    impl RDecoderByteLevel;
}
