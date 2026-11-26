from pathlib import Path

import sentencepiece as spm
import torch
from transformers import LlamaConfig, LlamaForCausalLM

torch.manual_seed(42)
torch.set_num_threads(2)

out = Path("tiny-llama")
out.mkdir(exist_ok=True)

sentence = "The sky is blue."
Path("corpus.txt").write_text((sentence + "\n") * 32, encoding="utf-8")

spm.SentencePieceTrainer.train(
    input="corpus.txt",
    model_prefix=str(out / "tokenizer"),
    model_type="char",
    vocab_size=64,
    hard_vocab_limit=False,
    unk_id=0,
    bos_id=1,
    eos_id=2,
)
tokenizer = spm.SentencePieceProcessor(
    model_file=str(out / "tokenizer.model")
)

model = LlamaForCausalLM(LlamaConfig(
    vocab_size=tokenizer.vocab_size(),
    hidden_size=64,
    intermediate_size=128,
    num_hidden_layers=2,
    num_attention_heads=4,
    num_key_value_heads=4,
    max_position_embeddings=128,
    bos_token_id=1,
    eos_token_id=2,
))

ids = torch.tensor([[1, *tokenizer.encode(sentence), 2]])
optimizer = torch.optim.AdamW(model.parameters(), lr=0.003)

for _ in range(100):
    optimizer.zero_grad()
    loss = model(input_ids=ids, labels=ids).loss
    loss.backward()
    optimizer.step()

print(f"Final loss: {loss.item():.4f}")
model.save_pretrained(out)
