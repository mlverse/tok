use tokenizers as tk;
use std::borrow::Cow;
use tk::{InputSequence, EncodeInput};
use extendr_api::prelude::*;

#[derive(Clone)]
pub struct RTokenizer(tk::Tokenizer);

#[extendr]
impl RTokenizer {
    pub fn new(tokenizer: &RTokenizer) -> RTokenizer {
        RTokenizer(tokenizer.0.clone())
    }
    pub fn from_file (path: &str) -> RTokenizer {
        RTokenizer(tk::Tokenizer::from_file(path).unwrap())
    }
    pub fn encode (&self, sequence: Robj, pair: Robj, is_pretokenized: bool, add_special_tokens: bool) -> R6REncoding {
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

        R6REncoding(REncoding(self.0.encode_char_offsets(input, add_special_tokens).unwrap()))
    }
    pub fn decode (&self, ids: Vec<i32>, skip_special_tokens: bool) -> String {
        let ids_cast: Vec<u32> = ids.into_iter().map(|x| x as u32).collect(); 
        self.0.decode(&ids_cast, skip_special_tokens).unwrap()
    }
    pub fn encode_batch (&self, input: Robj, is_pretokenized: bool, add_special_tokens: bool) -> Vec<Robj> {
        
        let input: Vec<tk::EncodeInput> = if is_pretokenized {
            panic!("Pretokenized input is not supported yet")    
        } else {
            // the input is just a character vector, there are no pairs at all, we can quickly create the
            // sequences
            if let Some(obj) = input.as_str_vector() {
                obj.
                    into_iter().
                    map(|x| EncodeInput::Single(InputSequence::Raw(Cow::Borrowed(x)))).
                    collect()
            } else if let Some(obj) = input.as_list() {
                // if the input is a list, we will check if the value is a string. If it is, we will
                // create a single sequence. If it is a list, we will create a pair sequence.
                obj.
                    into_iter().
                    map(|(_, value)| {
                        if let Some(val) = value.as_str() {
                            EncodeInput::Single(InputSequence::Raw(Cow::Borrowed(val)))
                        } else if let Some(val) = value.as_list() {
                            if val.len() != 2 {
                                panic!("Can't take a list of length != 2 as a pair")
                            }
                            let sequence = InputSequence::Raw(Cow::Borrowed(val[0].as_str().unwrap()));
                            let pair = InputSequence::Raw(Cow::Borrowed(val[1].as_str().unwrap()));
                            EncodeInput::Dual(sequence, pair)
                        } else {
                            panic!("Input must be a string vector or a list of strings")
                        }
                    }).
                    collect()
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
    pub fn decode_batch (&self, ids: Robj, skip_special_tokens: bool) -> Vec<String> {

        let u32_ids: Vec<Vec<u32>> = if let Some(x) = ids.as_list() {
            x
                .into_iter()
                .map(|(_, v)| {
                    v
                        .as_integer_vector()
                        .unwrap()
                        .into_iter()
                        .map(|x| x as u32)
                        .collect()
                    })
                .collect()  
        } else {
            panic!("Input must be a list of integer vectors")
        };

        let slices = u32_ids.iter().map(|v| &v[..]).collect::<Vec<&[u32]>>();
        
        self.0
            .decode_batch(&slices, skip_special_tokens)
            .unwrap()
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
    fn from (val: R6REncoding) -> Self{
        call!("tok::encoding$new", val.0).unwrap()
    } 
}

extendr_module! {
    mod tokenizer;
    impl REncoding;
    impl RTokenizer;
}