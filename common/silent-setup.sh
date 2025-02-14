
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
# The function accepts an optional second parameter INDEX_URL.
# If the second parameter is provided, it will use that URL for the pip install command.
setup_pip_software() {
    local PACKAGE=$1
    local INDEX_URL=$2

    # Extract the actual package name by removing anything after the first occurrence of '=' or '-'
    local PACKAGE_NAME=$(echo "$PACKAGE" | sed 's/[=|-].*//')

    # Ensure python3-pip is installed
    setup_apt_software "python3-pip" "command -v pip3"

    # activate the virtual environment in the function
    source "$PIPVIRTUALENV_DIR/bin/activate"

    if ! pip show "$PACKAGE_NAME" &> /dev/null; then
        echo "Pip package $PACKAGE_NAME is not installed. Installing..."
        if [ -n "$INDEX_URL" ]; then
            pip install "$PACKAGE" --index-url "$INDEX_URL"
        else
            pip install "$PACKAGE"
        fi

        # wait for package to install
        while ! pip show "$PACKAGE_NAME" &> /dev/null; do
            echo "Waiting for $PACKAGE_NAME to install..."
            sleep 5
        done
        echo "$PACKAGE_NAME installed successfully!"
    else
        echo "$PACKAGE_NAME already installed!"
    fi
}
