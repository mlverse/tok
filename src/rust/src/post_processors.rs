use extendr_api::prelude::*;
use tokenizers as tk;

#[extendr]
pub struct RPostProcessor(pub tk::PostProcessorWrapper);

#[extendr]
impl RPostProcessor {
    pub fn new(post_processor: Robj) -> extendr_api::Result<Self> {
        if post_processor.inherits("RPostProcessorByteLevel") {
            Ok(RPostProcessor(
                <&RPostProcessorByteLevel>::try_from(&post_processor)?.0.clone().into(),
            ))
        } else {
            Err(Error::EvalError("Unsupported post_processor".into()))
        }
    }
}

#[extendr]
struct RPostProcessorByteLevel(tk::processors::byte_level::ByteLevel);

#[extendr]
impl RPostProcessorByteLevel {
    pub fn new(trim_offsets: bool) -> Self {
        RPostProcessorByteLevel(
            tk::processors::byte_level::ByteLevel::default().trim_offsets(trim_offsets),
        )
    }
}

extendr_module! {
    mod post_processors;
    impl RPostProcessor;
    impl RPostProcessorByteLevel;
}
