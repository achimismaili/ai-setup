#!/bin/bash

# This script will set up a real-time AI avatar that:
# ✅ Understands and speaks German 🇩🇪
# ✅ Responds in real-time using Qwen 2.5-7B
# ✅ Animates a face & lips while speaking
# ✅ Streams the avatar live with OBS Studio

# setup qwen:7b llm with ollama
# chat gpt guidance document, see 
# https://chatgpt.com/canvas/shared/67a9fba4ecd88191b9dea502dcfb2a78

## Configuration

BaseDir="/home/$(whoami)/ai"
DirOllama="$BaseDir/ollama"
DirQwen="$BaseDir/qwen7b"

## Functions

# Function to check and move into a directory
move_into_directory() {
    local DIR=$1
    # Check if the directory exists
    if [ ! -d "$DIR" ]; then
        echo "Directory does not exist. Creating..."
        mkdir -p "$DIR"
    fi

    # Change into the directory
    cd "$DIR" || { echo "Failed to change directory!"; exit 1; }

    echo "Now in directory: $(pwd)"
}

# Function to wait and check if software is installed
wait_for_installation() {
    local SOFTWARE=$1
    while ! command -v "$SOFTWARE" &> /dev/null; do
        echo "Waiting for $SOFTWARE to install..."
        sleep 5
    done
    echo "$SOFTWARE installed successfully!"
}


## Main

# Go to Ollama folder
move_into_directory "$DirOllama"

# check if Ollama is installed, if not install it
if ! command -v "ollama" &> /dev/null; then
    echo "Ollama not installed. Installing..."
    # setup Ollama
    curl -fsSL https://ollama.com/install.sh | sh

    # wait for Ollama to install
    wait_for_installation "ollama"

else
    echo "Ollama already installed!"
fi


# Go to qwen folder
move_into_directory "$DirQwen"

# setup qwen
