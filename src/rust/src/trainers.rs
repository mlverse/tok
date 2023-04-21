use std::sync::{Arc, RwLock};

use serde::{Deserialize, Serialize};
use tk::models::TrainerWrapper;
use tk::Trainer;
use tokenizers as tk;

struct RTrainer {
    pub trainer: Arc<RwLock<TrainerWrapper>>,
}

impl RTrainer {
    pub fn new(trainer: Arc<RwLock<TrainerWrapper>>) -> Self {
        RTrainer { trainer }
    }
}

