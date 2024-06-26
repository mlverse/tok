use crate::decoders::RDecoder;
use crate::models::RModel;
use crate::normalizers::RNormalizer;
use crate::post_processors::RPostProcessor;
use crate::pre_tokenizers::RPreTokenizer;
use crate::trainers::RTrainer;
use extendr_api::prelude::*;
use std::borrow::Cow;
use tk::{EncodeInput, InputSequence};
use tokenizers as tk;

#[derive(Clone)]
pub struct RTokenizer(tk::Tokenizer);

#[extendr]
impl RTokenizer {
    pub fn new(tokenizer: &RTokenizer) -> RTokenizer {
        RTokenizer(tokenizer.0.clone())
    }
    pub fn from_file(path: &str) -> RTokenizer {
        RTokenizer(tk::Tokenizer::from_file(path).unwrap())
    }
    pub fn from_model(model: &RModel) -> RTokenizer {
        RTokenizer(tk::Tokenizer::new(model.model.clone()))
    }
    pub fn encode(
        &self,
        sequence: Robj,
        pair: Robj,
        is_pretokenized: bool,
        add_special_tokens: bool,
    ) -> R6REncoding {
        let sequence: tk::InputSequence = if is_pretokenized {
            panic!("Pretokenized input is not supported yet")
        } else {
            tk::InputSequence::Raw(std::borrow::Cow::Borrowed(sequence.as_str().unwrap()))
        };

        let input = if let Some(val) = pair.as_str() {
            let pair: tk::InputSequence = if is_pretokenized {
                panic!("Pretokenized input is not supported yet")
            } else {
                tk::InputSequence::Raw(std::borrow::Cow::Borrowed(val))
            };
            tk::EncodeInput::Dual(sequence, pair)
        } else if pair.is_null() {
            tk::EncodeInput::Single(sequence)
        } else {
            panic!("Pair must be a string or NULL")
        };

        R6REncoding(REncoding(
            self.0
                .encode_char_offsets(input, add_special_tokens)
                .unwrap(),
        ))
    }
    pub fn decode(&self, ids: Vec<i32>, skip_special_tokens: bool) -> String {
        let ids_cast: Vec<u32> = ids.into_iter().map(|x| x as u32).collect();
        self.0.decode(&ids_cast, skip_special_tokens).unwrap()
    }
    pub fn encode_batch(
        &self,
        input: Robj,
        is_pretokenized: bool,
        add_special_tokens: bool,
    ) -> Vec<Robj> {
        let input: Vec<tk::EncodeInput> = if is_pretokenized {
            panic!("Pretokenized input is not supported yet")
        } else {
            // the input is just a character vector, there are no pairs at all, we can quickly create the
            // sequences
            if let Some(obj) = input.as_str_vector() {
                obj.into_iter()
                    .map(|x| EncodeInput::Single(InputSequence::Raw(Cow::Borrowed(x))))
                    .collect()
            } else if let Some(obj) = input.as_list() {
                // if the input is a list, we will check if the value is a string. If it is, we will
                // create a single sequence. If it is a list, we will create a pair sequence.
                obj.into_iter()
                    .map(|(_, value)| {
                        if let Some(val) = value.as_str() {
                            EncodeInput::Single(InputSequence::Raw(Cow::Borrowed(val)))
                        } else if let Some(val) = value.as_list() {
                            if val.len() != 2 {
                                panic!("Can't take a list of length != 2 as a pair")
                            }
                            let sequence =
                                InputSequence::Raw(Cow::Borrowed(val[0].as_str().unwrap()));
                            let pair = InputSequence::Raw(Cow::Borrowed(val[1].as_str().unwrap()));
                            EncodeInput::Dual(sequence, pair)
                        } else {
                            panic!("Input must be a string vector or a list of strings")
                        }
                    })
                    .collect()
            } else {
                panic!("Input must be a string vector or a list of strings")
            }
        };

        self.0
            .encode_batch_char_offsets(input, add_special_tokens)
            .unwrap()
            .into_iter()
            .map(|x: tk::Encoding| Robj::from(R6REncoding(REncoding(x))))
            .collect()
    }
    pub fn decode_batch(&self, ids: List, skip_special_tokens: bool) -> Vec<String> {
        // work around https://github.com/extendr/extendr/pull/782
        let mut u32_ids: Vec<Vec<u32>> = Vec::with_capacity(ids.len());
        for i in 0..ids.len() {
            let value = ids[i].as_integer_slice().unwrap().iter().map(|x| *x as u32).collect::<Vec<u32>>();
            u32_ids.push(value);
        }
        let slices = u32_ids.iter().map(|v| &v[..]).collect::<Vec<&[u32]>>();
        self.0.decode_batch(&slices, skip_special_tokens).unwrap()
    }
    pub fn set_pre_tokenizer(&mut self, pre_tokenizer: &RPreTokenizer) {
        self.0.with_pre_tokenizer(pre_tokenizer.0.clone());
    }
    pub fn get_pre_tokenizer(&self) -> Nullable<R6PreTokenizer> {
        if let Some(pre_tokenizer) = self.0.get_pre_tokenizer() {
            let clone = pre_tokenizer.clone();
            NotNull(R6PreTokenizer(RPreTokenizer(clone)))
        } else {
            Null
        }
    }
    pub fn set_post_processor(&mut self, post_processors: &RPostProcessor) {
        self.0.with_post_processor(post_processors.0.clone());
    }
    pub fn get_post_processor(&self) -> Nullable<R6PostProcessor> {
        if let Some(post_processor) = self.0.get_post_processor() {
            let clone = post_processor.clone();
            NotNull(R6PostProcessor(RPostProcessor(clone)))
        } else {
            Null
        }
    }
    pub fn set_normalizer(&mut self, normalizer: &RNormalizer) {
        self.0.with_normalizer(normalizer.0.clone());
    }
    pub fn get_normalizer(&self) -> Nullable<R6Normalizer> {
        if let Some(normalizer) = self.0.get_normalizer() {
            let clone = normalizer.clone();
            NotNull(R6Normalizer(RNormalizer(clone)))
        } else {
            Null
        }
    }
    pub fn set_decoder(&mut self, decoder: &RDecoder) {
        self.0.with_decoder(decoder.0.clone());
    }
    pub fn get_decoder(&self) -> Nullable<R6Decoder> {
        if let Some(decoder) = self.0.get_decoder() {
            let clone = decoder.clone();
            NotNull(R6Decoder(RDecoder(clone)))
        } else {
            Null
        }
    }
    pub fn train_from_files(&mut self, trainer: &mut RTrainer, files: Vec<String>) {
        self.0
            .train_from_files(&mut trainer.trainer, files)
            .unwrap();
    }
    pub fn train_from_sequences(&mut self, trainer: &mut RTrainer, sequences: Robj) {
        self.0
            .train(
                &mut trainer.trainer,
                sequences.as_str_vector().unwrap().iter(),
            )
            .unwrap();
    }
    pub fn save(&mut self, path: &str, pretty: bool) {
        self.0.save(path, pretty).unwrap();
    }
    pub fn enable_padding(&mut self, padding: Nullable<RPaddingParams>) {
        if let NotNull(padding) = padding {
            self.0.with_padding(Some(padding.0));
        } else {
            self.0.with_padding(None);
        }
    }
    pub fn get_padding(&mut self) -> Nullable<RPaddingParams> {
        if let Some(padding) = self.0.get_padding() {
            let clone = padding.clone();
            NotNull(RPaddingParams(clone))
        } else {
            Null
        }
    }
    pub fn no_padding(&mut self) {
        self.0.with_padding(None);
    }
    pub fn enable_truncation(&mut self, truncation: Nullable<RTruncationParams>) {
        if let NotNull(truncation) = truncation {
            self.0.with_truncation(Some(truncation.0)).unwrap();
        } else {
            self.0.with_truncation(None).unwrap();
        }
    }
    pub fn get_truncation(&mut self) -> Nullable<RTruncationParams> {
        if let Some(truncation) = self.0.get_truncation() {
            let clone = truncation.clone();
            NotNull(RTruncationParams(clone))
        } else {
            Null
        }
    }
    pub fn no_truncation(&mut self) {
        self.0.with_truncation(None).unwrap();
    }
    pub fn get_vocab_size(&self, with_added_tokens: bool) -> usize {
        self.0.get_vocab_size(with_added_tokens)
    }
}

pub struct REncoding(tk::Encoding);

#[extendr]
impl REncoding {
    pub fn len(&self) -> usize {
        self.0.len()
    }
    fn get_ids(&self) -> Vec<i32> {
        self.0.get_ids().iter().map(|x| *x as i32).collect()
    }
    fn get_tokens(&self) -> Vec<String> {
        self.0.get_tokens().to_vec()
    }
    fn get_type_ids(&self) -> Vec<u32> {
        self.0.get_type_ids().to_vec()
    }
    fn get_attention_mask(&self) -> Vec<u32> {
        self.0.get_attention_mask().to_vec()
    }
    fn get_special_tokens_mask(&self) -> Vec<u32> {
        self.0.get_special_tokens_mask().to_vec()
    }
    fn get_word_ids(&self) -> Vec<Option<u32>> {
        self.0.get_word_ids().to_vec()
    }
}

pub struct R6REncoding(REncoding);
impl From<R6REncoding> for Robj {
    fn from(val: R6REncoding) -> Self {
        call!("tok::encoding$new", val.0).unwrap()
    }
}

pub struct R6PreTokenizer(RPreTokenizer);
impl From<R6PreTokenizer> for Robj {
    fn from(val: R6PreTokenizer) -> Self {
        call!("tok::pre_tokenizer$new", val.0).unwrap()
    }
}

pub struct R6Normalizer(RNormalizer);
impl From<R6Normalizer> for Robj {
    fn from(val: R6Normalizer) -> Self {
        call!("tok::tok_normalizer$new", val.0).unwrap()
    }
}

pub struct R6PostProcessor(RPostProcessor);
impl From<R6PostProcessor> for Robj {
    fn from(val: R6PostProcessor) -> Self {
        call!("tok::tok_processor$new", val.0).unwrap()
    }
}

pub struct R6Decoder(RDecoder);
impl From<R6Decoder> for Robj {
    fn from(val: R6Decoder) -> Self {
        call!("tok::tok_decoder$new", val.0).unwrap()
    }
}

pub struct RPaddingParams(tk::PaddingParams);
impl TryFrom<Robj> for RPaddingParams {
    type Error = Error;
    fn try_from(robj: Robj) -> std::result::Result<Self, Self::Error> {
        if let Some(val) = robj.as_list() {
            let mut params = tk::PaddingParams::default();
            for (key, value) in val {
                match key {
                    "direction" => {
                        params.direction = match value.as_str() {
                            Some("left") => tk::PaddingDirection::Left,
                            Some("right") => tk::PaddingDirection::Right,
                            _ => return Err(Error::Other("Invalid padding direction".to_string())),
                        }
                    }
                    "pad_to_multiple_of" => {
                        params.pad_to_multiple_of = Some(value.as_integer().unwrap() as usize);
                    }
                    "pad_id" => {
                        params.pad_id = value.as_integer().unwrap() as u32;
                    }
                    "pad_type_id" => {
                        params.pad_type_id = value.as_integer().unwrap() as u32;
                    }
                    "pad_token" => {
                        params.pad_token = value.as_str().unwrap().to_string();
                    }
                    "length" => {
                        if let Some(l) = value.as_integer() {
                            params.strategy = tk::PaddingStrategy::Fixed(l as usize);
                        } else {
                            params.strategy = tk::PaddingStrategy::BatchLongest;
                        }
                    }
                    _ => return Err(Error::Other("Invalid padding parameter".to_string())),
                }
            }
            Ok(RPaddingParams(params))
        } else {
            return Err(Error::Other("Expected a named list.".to_string()));
        }
    }
}

impl From<RPaddingParams> for Robj {
    fn from(params: RPaddingParams) -> Self {
        let object: List = list!(
            length = match params.0.strategy {
                tk::PaddingStrategy::BatchLongest => Null,
                tk::PaddingStrategy::Fixed(size) => NotNull(size),
            },
            pad_to_multiple_of = params.0.pad_to_multiple_of,
            pad_id = params.0.pad_id,
            pad_token = params.0.pad_token,
            pad_type_id = params.0.pad_type_id,
            direction = params.0.direction.as_ref(),
        );
        object.into_robj()
    }
}

pub struct RTruncationParams(tk::TruncationParams);

impl TryFrom<Robj> for RTruncationParams {
    type Error = Error;
    fn try_from(robj: Robj) -> std::result::Result<Self, Self::Error> {
        if let Some(val) = robj.as_list() {
            let mut params = tk::TruncationParams::default();
            for (key, value) in val {
                match key {
                    "max_length" => params.max_length = value.as_integer().unwrap() as usize,
                    "stride" => params.stride = value.as_integer().unwrap() as usize,
                    "strategy" => {
                        let value: &str = value.as_str().unwrap();
                        params.strategy = match value {
                        "longest_first" => tk::TruncationStrategy::LongestFirst,
                        "only_first" => tk::TruncationStrategy::OnlyFirst,
                        "only_second" => tk::TruncationStrategy::OnlySecond,
                        _ => {
                            return Err(Error::Other("Unknown strategy. Use one of `longest_first`, `only_first` or `only_second`.".to_string()))
                        }
                    };
                    }
                    "direction" => {
                        let value: &str = value.as_str().unwrap();
                        params.direction = match value {
                            "left" => tk::TruncationDirection::Left,
                            "right" => tk::TruncationDirection::Right,
                            _ => return Err(Error::Other("Unknown direction".to_string())),
                        };
                    }
                    _ => return Err(Error::Other("Invalid truncation parameter".to_string())),
                }
            }
            Ok(RTruncationParams(params))
        } else {
            return Err(Error::Other("Expected a named list.".to_string()));
        }
    }
}

impl From<RTruncationParams> for Robj {
    fn from(params: RTruncationParams) -> Self {
        let object: List = list!(
            max_length = params.0.max_length,
            stride = params.0.stride,
            strategy = params.0.strategy.as_ref(),
            direction = params.0.direction.as_ref(),
        );
        object.into_robj()
    }
}

extendr_module! {
    mod tokenizer;
    impl REncoding;
    impl RTokenizer;
}
