# AI Avatar Setup Script

This repo serves as a source of ai related scripts.

## Scripts in this GIT repo

### setup-ai-avatar.sh 

A script designed to automate the installation and configuration of an AI avatar environment. It runs the following scripts

- setup-bark.sh
- setup-llm.sh 

### setup-bark.sh

This script will set up Bark for text-to-speech
After running this installation, you can run the speech_test.py script to generate speech.
just run `python3 ./speech_test.py` in this directory

### setup-llm.sh 

This script will set up Qwen 2.5-7B via Ollama and allows to run it
After running this installation, you have your local llm ready to answer any question just start it with `ollama run qwen:7b`

### speech_test.py 

An interactive script for text to sound generation with different voices, you can select available voices via number and enter any text that then text gets read out loud by the selected voice (converting text to wav file is optional and commented out)

### (./common/)silent-setup.sh

Common library that takes care, that packages are installed correctly and also not installed multiple times.

## Requirements

The scripts are tested within the following environment

- OS: Ubuntu LTS 24.04 as Windows Subsystem Linux WSL2 (Windows 11 Subsystem for Linux 2)
- Graphic Card: NVIDIA GeForce RTX 4070 12 GB RAM 
- You should have several GB free disk space within the WSL

## Installation & Usage

### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

### **2️⃣ Make the Scripts Executable**

e.g. for the setup-ai-avatar.sh script:

```bash
chmod +x setup-ai-avatar.sh
```

### **3️⃣ Run the Script**

```bash
./setup-ai-avatar.sh
```

## 🔥 Troubleshooting
- If permissions are denied, run:

  ```bash
  sudo ./setup-ai-avatar.sh
  ```
- If dependencies are missing, install them manually:
  ```bash
  sudo apt update && sudo apt install -y python3 python3-pip ffmpeg git
  ```

## 📜 License
This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.


