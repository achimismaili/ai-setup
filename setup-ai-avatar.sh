#!/bin/bash

# This script will set up a real-time AI avatar that:
# ✅ Installs Qwen 2.5-7B via Ollama and allows to run it
# After running this installation, you have your local llm ready to answer any question
# just start it with `ollama run qwen:7b`

# ✅ Installs Bark for text-to-speech
# After running this installation, you can run the speech_test.py script to generate speech.
# just run `python3 ./speech_test.py` in this directory

# This script is based on this chat gpt guidance document, see 
# https://chatgpt.com/canvas/shared/67a9fba4ecd88191b9dea502dcfb2a78

# Source the shared functions
source /home/ismaili/code/ai-setup/lib/silent-setup.sh

## Configuration

# The directory, where all software is installed
BaseDir="/home/$(whoami)/ai"
# The directory for the Python virtual environment
PIPVIRTUALENV_DIR="$BaseDir/python-pip-venv"

## Main

# There was an installation problem with phyton pip, so I added the following line
# Add missing GPG key for Microsoft Edge repository
add_microsoft_edge_gpg_key

# setup python3 and python virtual environment plus activate virtual environment
setup_apt_software "python3"

# Ensure python3-venv is installed
setup_apt_software "python3-venv" "dpkg -l | grep -qw python3-venv"

# Create and activate the virtual environment if it doesn't exist
if [ ! -f "$PIPVIRTUALENV_DIR/bin/activate" ]; then
    python3 -m venv "$PIPVIRTUALENV_DIR"
fi
source "$PIPVIRTUALENV_DIR/bin/activate"

# setup Ollama
setup_curl_software "ollama"

# setup qwen:7b directly in Ollama directory
setup_ollama_model "qwen:7b"

# setup speech

# install bark ai
setup_pip_software "bark"

# install dependencies torch, numpy, scipy

# torch is also for running Bark on GPU, to check, run "nvidia-smi", if GPU is detected
# setup_pip_software "torch"
# getting torch to work was pain in the a**
# torch 2.1 does not work with python 3.12 anymore, touch 2.6 causes too many issues, so I selected 2.2.2
# Following is the command to install torch 2.2.2 with cuda 11.8 (cu118 is the right NVIDIA GPU support version for my GPU)
setup_pip_software "torch==2.2.2+cu118" "https://download.pytorch.org/whl/cu118"
setup_pip_software "torchvision" "https://download.pytorch.org/whl/cu118"
setup_pip_software "torchaudio" "https://download.pytorch.org/whl/cu118"

# setup_pip_software "numpy"
# current numpy 2.2.2 is not compatible with outdated torch version, so installing numpy 1.26.4
# ... but numpy 1.26.4 is not available in the default pip repository
Numpy_pip_name="numpy-1.26.4-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"

if ! pip show "numpy" &> /dev/null; then
    wget "https://files.pythonhosted.org/packages/0f/50/de23fde84e45f5c4fda2488c759b69990fd4512387a8632860f3ac9cd225/$Numpy_pip_name"
fi 

setup_pip_software $Numpy_pip_name

setup_pip_software "scipy"
# for direct sound output
setup_pip_software "sounddevice"

# Install PortAudio library
setup_apt_software "portaudio19-dev" "dpkg -l | grep -qw portaudio19-dev"

# Install ALSA plugins for hearing wsl2 sound in windows
setup_apt_software "libasound2-plugins" "dpkg -l | grep -qw libasound2-plugins"

# check, if .asounrc file is available in home directory, if not copy from this directory
if [ ! -f ~/.asoundrc ]; then
    cp .asoundrc ~/.asoundrc
fi

## start avatar environment

# Activate the virtual environment before running any commands that depend on it
source "$PIPVIRTUALENV_DIR/bin/activate"

# Run the Python script to generate speech
# python3 ./speech_test.py

## run qwen:7b
# ollama run qwen:7b