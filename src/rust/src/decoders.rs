use extendr_api::prelude::*;
use tokenizers as tk;

pub struct RDecoder(pub tk::DecoderWrapper);

#[extendr]
impl RDecoder {
    pub fn new(decoder: Robj) -> extendr_api::Result<Self> {
        if decoder.inherits("RDecoderByteLevel") {
            unsafe {
                let ptr = decoder.external_ptr_addr() as *mut RDecoderByteLevel;
                Ok(RDecoder((*ptr).0.clone().into()))
            }
        } else {
            Err(Error::EvalError("Unsupported decoder".into()))
        }
    }
}

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
