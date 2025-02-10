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

# The directory, where all software is installed
BaseDir="/home/$(whoami)/ai"

## Functions

# Function to check and move into a directory
ensure_software_directory() {
    local SOFTWARE=$1
    local DIR_NAME=$(echo "$SOFTWARE" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]')
    local DIR="$BaseDir/$DIR_NAME"

    # Check if the directory exists
    if [ ! -d "$DIR" ]; then
        echo "Directory does not exist. Creating..."
        mkdir -p "$DIR"
    fi

    # Change into the directory
    cd "$DIR" || { echo "Failed to change directory!"; exit 1; }

    echo "Now in directory: $(pwd)"
}

# Consolidated function to check and wait for software installation
check_and_wait_for_installation() {
    local SOFTWARE=$1
    local CHECK_COMMAND=$2
    local INSTALL_COMMAND=$3

    if ! eval "$CHECK_COMMAND" &> /dev/null; then
        echo "$SOFTWARE not installed. Installing..."
        eval "$INSTALL_COMMAND"

        # wait for software to install
        while ! eval "$CHECK_COMMAND" &> /dev/null; do
            echo "Waiting for $SOFTWARE to install..."
            sleep 5
        done
        echo "$SOFTWARE installed successfully!"
    else
        echo "$SOFTWARE already installed!"
    fi
}

# Function to check and setup system software using sudo apt-get
setup_apt_software() {
    local SOFTWARE=$1
    check_and_wait_for_installation "$SOFTWARE" "command -v $SOFTWARE" "sudo apt-get update && sudo apt-get install -y $SOFTWARE"
}

# Function to check and setup system software using curl
setup_curl_software() {
    local SOFTWARE=$1

    ensure_software_directory "$SOFTWARE"
    check_and_wait_for_installation "$SOFTWARE" "command -v $SOFTWARE" "curl -fsSL https://ollama.com/install.sh | sh"
}

# Function to check and setup ollama models
setup_ollama_model() {
    local MODEL=$1
    check_and_wait_for_installation "$MODEL" "ollama list | grep -q $MODEL" "ollama pull $MODEL"
}

## Main

# check if python and pip is installed and if not, install it
setup_apt_software "python3"
setup_apt_software "python3-pip"

# setup Ollama
setup_curl_software "ollama"

# setup qwen:7b directly in Ollama directory
setup_ollama_model "qwen:7b"



## start avatar environment

## run qwen:7b
# ollama run qwen:7b