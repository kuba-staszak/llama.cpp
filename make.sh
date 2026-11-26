cmake -S . -B build/docker-debug -DCMAKE_BUILD_TYPE=Debug
cmake --build build/docker-debug --target llama-cli --parallel 4
