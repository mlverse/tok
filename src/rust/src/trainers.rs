use extendr_api::prelude::*;
use tk::models::bpe::BpeTrainer;
use tk::models::TrainerWrapper;
use tk::AddedToken;
use tokenizers as tk;

#[extendr]
pub struct RTrainer {
    pub trainer: TrainerWrapper,
}

#[extendr]
impl RTrainer {
    pub fn new(trainer: Robj) -> Result<Self> {
        if trainer.inherits("RTrainerBPE") {
            Ok(RTrainer{
                trainer: <&RTrainerBPE>::try_from(&trainer)?.trainer.clone().into()
            })
        } else if trainer.inherits("RTrainerWordPiece") {
            Ok(RTrainer{
                trainer: <&RTrainerWordPiece>::try_from(&trainer)?.trainer.clone().into()
            })
        } else if trainer.inherits("RTrainerUnigram") {
            Ok(RTrainer{
                trainer: <&RTrainerUnigram>::try_from(&trainer)?.trainer.clone().into()
            })
        } else {
            Err(Error::EvalError("Model not supported".into()))
        }
    }
}

#[extendr]
pub struct RTrainerBPE {
    pub trainer: BpeTrainer,
}

#[extendr]
impl RTrainerBPE {
    pub fn new(
        vocab_size: Nullable<i32>,
        min_frequency: Nullable<u64>,
        show_progress: Nullable<bool>,
        special_tokens: Nullable<Vec<String>>,
        limit_alphabet: Nullable<i32>,
        initial_alphabet: Nullable<Vec<String>>,
        continuing_subword_prefix: Nullable<String>,
        end_of_word_suffix: Nullable<String>,
        max_token_length: Nullable<i32>,
    ) -> Self {
        let mut trainer = BpeTrainer::builder();
        if let NotNull(vocab_size) = vocab_size {
            trainer = trainer.vocab_size(vocab_size as usize);
        }
        if let NotNull(min_frequency) = min_frequency {
            trainer = trainer.min_frequency(min_frequency);
        }
        if let NotNull(show_progress) = show_progress {
            trainer = trainer.show_progress(show_progress);
        }
        if let NotNull(special_tokens) = special_tokens {
            trainer = trainer.special_tokens(
                special_tokens
                    .iter()
                    .map(|x| AddedToken {
                        content: (x.into()),
                        single_word: (false),
                        lstrip: (false),
                        rstrip: (false),
                        normalized: (true),
                        special: (true),
                    })
                    .collect(),
            );
        }
        if let NotNull(limit_alphabet) = limit_alphabet {
            trainer = trainer.limit_alphabet(limit_alphabet as usize);
        }
        if let NotNull(_initial_alphabet) = initial_alphabet {
            panic!("Cant'");
            //trainer = trainer.initial_alphabet(initial_alphabet);
        }
        if let NotNull(continuing_subword_prefix) = continuing_subword_prefix {
            trainer = trainer.continuing_subword_prefix(continuing_subword_prefix);
        }
        if let NotNull(end_of_word_suffix) = end_of_word_suffix {
            trainer = trainer.end_of_word_suffix(end_of_word_suffix);
        }
        if let NotNull(max_token_length) = max_token_length {
            trainer = trainer.max_token_length(Some(max_token_length as usize));
        }

        RTrainerBPE {
            trainer: (trainer.build()),
        }
    }
}

#[extendr]
pub struct RTrainerWordPiece {
    pub trainer: tk::models::wordpiece::WordPieceTrainer,
}

#[extendr]
impl RTrainerWordPiece {
    pub fn new(
        vocab_size: Nullable<i32>,
        min_frequency: Nullable<u64>,
        show_progress: Nullable<bool>,
        special_tokens: Nullable<Vec<String>>,
        limit_alphabet: Nullable<i32>,
        initial_alphabet: Nullable<Vec<String>>,
        continuing_subword_prefix: Nullable<String>,
        end_of_word_suffix: Nullable<String>,
    ) -> Self {
        let mut trainer = tk::models::wordpiece::WordPieceTrainer::builder();
        if let NotNull(vocab_size) = vocab_size {
            trainer = trainer.vocab_size(vocab_size as usize);
        }
        if let NotNull(min_frequency) = min_frequency {
            trainer = trainer.min_frequency(min_frequency);
        }
        if let NotNull(show_progress) = show_progress {
            trainer = trainer.show_progress(show_progress);
        }
        if let NotNull(special_tokens) = special_tokens {
            trainer = trainer.special_tokens(
                special_tokens
                    .iter()
                    .map(|x| AddedToken {
                        content: (x.into()),
                        single_word: (false),
                        lstrip: (false),
                        rstrip: (false),
                        normalized: (true),
                        special: (true),
                    })
                    .collect(),
            );
        }
        if let NotNull(limit_alphabet) = limit_alphabet {
            trainer = trainer.limit_alphabet(limit_alphabet as usize);
        }
        if let NotNull(_initial_alphabet) = initial_alphabet {
            panic!("Cant'");
            //trainer = trainer.initial_alphabet(initial_alphabet);
        }
        if let NotNull(continuing_subword_prefix) = continuing_subword_prefix {
            trainer = trainer.continuing_subword_prefix(continuing_subword_prefix);
        }
        if let NotNull(end_of_word_suffix) = end_of_word_suffix {
            trainer = trainer.end_of_word_suffix(end_of_word_suffix);
        }

        RTrainerWordPiece {
            trainer: (trainer.build()),
        }
    }
}

#[extendr]
struct RTrainerUnigram {
    trainer: tokenizers::models::unigram::UnigramTrainer,
}

#[extendr]
impl RTrainerUnigram {
    pub fn new(
        vocab_size: Nullable<i32>,
        show_progress: Nullable<bool>,
        special_tokens: Nullable<Vec<String>>,
        initial_alphabet: Nullable<Vec<String>>,
        shrinking_factor: f64,
        unk_token: Nullable<String>,
        max_piece_length: i32,
        n_sub_iterations: i32,
    ) -> Self {
        let mut trainer = tk::models::unigram::UnigramTrainer::builder();

        if let NotNull(vocab_size) = vocab_size {
            trainer.vocab_size(vocab_size as u32);
        }
        if let NotNull(show_progress) = show_progress {
            trainer.show_progress(show_progress);
        }
        if let NotNull(special_tokens) = special_tokens {
            trainer.special_tokens(
                special_tokens
                    .iter()
                    .map(|x| AddedToken {
                        content: (x.into()),
                        single_word: (false),
                        lstrip: (false),
                        rstrip: (false),
                        normalized: (true),
                        special: (true),
                    })
                    .collect(),
            );
        }
        if let NotNull(_initial_alphabet) = initial_alphabet {
            panic!("Cant'");
            //trainer = trainer.initial_alphabet(initial_alphabet);
        }
        trainer.shrinking_factor(shrinking_factor);
        if let NotNull(unk_token) = unk_token {
            trainer.unk_token(Some(unk_token));
        }
        trainer.max_piece_length(max_piece_length as usize);
        trainer.n_sub_iterations(n_sub_iterations as u32);

        RTrainerUnigram {
            trainer: (trainer.build().unwrap()),
        }
    }
}

extendr_module! {
    mod trainers;
    impl RTrainer;
    impl RTrainerBPE;
    impl RTrainerWordPiece;
    impl RTrainerUnigram;
}
