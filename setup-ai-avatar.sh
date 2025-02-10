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
# The directory for the Python virtual environment
PIPVIRTUALENV_DIR="$BaseDir/python-pip-venv"

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

# Function to add the missing public key for Microsoft Edge repository
add_microsoft_edge_gpg_key() {
    local KEY_FINGERPRINT="EB3E94ADBE1229CF"
    local KEYRING_FILE="/usr/share/keyrings/microsoft-archive-keyring.gpg"
    if ! gpg --no-default-keyring --keyring "$KEYRING_FILE" --list-keys "$KEY_FINGERPRINT" &> /dev/null; then
        echo "Adding missing GPG key for Microsoft Edge repository..."
        curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o "$KEYRING_FILE"
        echo "deb [signed-by=$KEYRING_FILE] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list > /dev/null
        sudo apt-get update
    else
        echo "GPG key for Microsoft Edge repository already exists."
    fi
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
# First parameter is the name of the apt package to install.
# The function accepts an optional second parameter CHECK_COMMAND. 
# If the second parameter is provided, it will use that command to check for the software; 
# otherwise, it will default to command -v $SOFTWARE.
setup_apt_software() {
    local SOFTWARE=$1
    local CHECK_COMMAND=${2:-"command -v $SOFTWARE"}
    check_and_wait_for_installation "$SOFTWARE" "$CHECK_COMMAND" "sudo apt-get update && sudo apt-get install -y $SOFTWARE"
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

# Function to check and setup pip packages
setup_pip_software() {
    local PACKAGE=$1

    # first, check if python and pip is installed and if not, install it
    setup_apt_software "python3"

    # Ensure python3-pip is installed
    setup_apt_software "python3-pip" "command -v pip3"

    # Ensure python3-venv is installed
    setup_apt_software "python3-venv" "dpkg -l | grep -qw python3-venv"

    # Create and activate the virtual environment if it doesn't exist
    if [ ! -f "$PIPVIRTUALENV_DIR/bin/activate" ]; then
        python3 -m venv "$PIPVIRTUALENV_DIR"
    fi
    source "$PIPVIRTUALENV_DIR/bin/activate"

    if ! pip show "$PACKAGE" &> /dev/null; then
        echo "Pip package $PACKAGE is not installed. Installing..."
        pip install "$PACKAGE"

        # wait for package to install
        while ! pip show "$PACKAGE" &> /dev/null; do
            echo "Waiting for $PACKAGE to install..."
            sleep 5
        done
        echo "$PACKAGE installed successfully!"
    else
        echo "$PACKAGE already installed!"
    fi
}

## Main

# There was an installation problem with phyton pip, so I added the following line
# Add missing GPG key for Microsoft Edge repository
add_microsoft_edge_gpg_key

# setup Ollama
setup_curl_software "ollama"

# setup qwen:7b directly in Ollama directory
setup_ollama_model "qwen:7b"

# setup speech

# install bark ai
setup_pip_software "bark"

# install dependencies torch, numpy, scipy
setup_pip_software "numpy"
setup_pip_software "scipy"
# for direct sound output
setup_pip_software "sounddevice"
# Running Bark on GPU
# nvidia-smi  # Check if GPU is detected
setup_pip_software "torch"

# For GPUs:
# pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118  # For CUDA 11.8

# Install PortAudio library
setup_apt_software "portaudio19-dev"

## start avatar environment

# Activate the virtual environment before running any commands that depend on it
source "$PIPVIRTUALENV_DIR/bin/activate"

# Run the Python script to generate speech
python3 /home/ismaili/code/ai-setup/generate_speech.py

## run qwen:7b
# ollama run qwen:7b