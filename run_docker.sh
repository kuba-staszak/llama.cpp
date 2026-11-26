  docker run --rm -it \
    --platform linux/arm64 \
    --cap-add SYS_PTRACE \
    --security-opt seccomp=unconfined \
    -v /Users/kuba/llama.cpp:/src \
    -v /Users/kuba/.cache/huggingface/hub/models--openresearchtools--Qwen3.5-4B-GGUF:/model-cache:ro \
    -w /src \
    llama-cpp-dev
