#!/bin/bash

# This script will set up Qwen 2.5-7B via Ollama and allows to run it
# After running this installation, you have your local llm ready to answer any question
# just start it with `ollama run qwen:7b`

# Source the shared functions
source /home/ismaili/code/ai-setup/lib/silent-setup.sh

## Configuration

# The directory, where all software is installed
BaseDir="/home/$(whoami)/ai"

## Main

# There was an installation problem with phyton pip, so I added the following line
# Add missing GPG key for Microsoft Edge repository
add_microsoft_edge_gpg_key

# Create and activate the virtual environment if it doesn't exist
if [ ! -f "$PIPVIRTUALENV_DIR/bin/activate" ]; then
    python3 -m venv "$PIPVIRTUALENV_DIR"
fi
source "$PIPVIRTUALENV_DIR/bin/activate"

# setup Ollama
setup_curl_software "ollama"

# setup qwen:7b directly in Ollama directory
setup_ollama_model "qwen:7b"

## run qwen:7b
# ollama run qwen:7b
