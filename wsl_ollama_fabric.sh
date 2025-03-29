#!/bin/bash

# ====================================================
# Ollama & Fabric Setup Script for WSL
# ====================================================
# Author: rpriven
# GitHub: https://github.com/rpriven/ai_setup
# 
# This script installs and configures:
#  - Ollama (local LLM runner)
#  - Go programming language
#  - Fabric CLI tool
#  - Streamlit for Fabric UI
# ====================================================

# Check if running in WSL
if ! grep -q Microsoft /proc/version; then
  echo -e "${RED}This script is designed for WSL (Windows Subsystem for Linux).${NC}"
  echo -e "${RED}It appears you are not running in a WSL environment.${NC}"
  echo -e "${YELLOW}Continue anyway? (y/n)${NC}"
  read -r choice
  if [[ ! "$choice" =~ ^[Yy]$ ]]; then
    echo "Exiting."
    exit 1
  fi
fi

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
  echo -e "\n${BLUE}===========================${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}===========================${NC}"
}

# Function to check command success
check_success() {
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Success: $1${NC}"
  else
    echo -e "${RED}✗ Error: $1 failed${NC}"
    if [ "$2" = "critical" ]; then
      echo -e "${RED}This is a critical error. Exiting setup.${NC}"
      exit 1
    fi
  fi
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Start setup
clear
echo -e "${PURPLE}======================================================${NC}"
echo -e "${PURPLE}     WSL Ollama and Fabric Setup Script             ${NC}"
echo -e "${PURPLE}======================================================${NC}"
echo -e "${YELLOW}This script will set up Ollama, Go, and Fabric in your WSL environment.${NC}"
echo -e "${YELLOW}Press Enter to continue or Ctrl+C to cancel...${NC}"
read

# Update system packages
print_header "Updating System Packages"
sudo apt update && sudo apt upgrade -y
check_success "System update"

# Install Ollama
print_header "Setting Up Ollama"
if command_exists ollama; then
  echo -e "${GREEN}✓ Ollama is already installed.${NC}"
  ollama --version
else
  echo -e "${YELLOW}Installing Ollama...${NC}"
  curl -fsSL https://ollama.com/install.sh | sh
  check_success "Ollama installation"
fi

# Start Ollama service
if pgrep -x "ollama" > /dev/null; then
  echo -e "${GREEN}✓ Ollama service is already running.${NC}"
else
  echo -e "${YELLOW}Starting Ollama service...${NC}"
  ollama serve > /dev/null 2>&1 &
  sleep 2
  check_success "Starting Ollama service"
fi

# Pull Ollama model
print_header "Pulling LLM Model"
echo -e "${YELLOW}Pulling llama3.2:1b model (this may take a while)...${NC}"
ollama pull llama3.2:1b
check_success "Pulling llama3.2:1b model"

# Install Go
print_header "Installing Go"
if command_exists go; then
  echo -e "${GREEN}✓ Go is already installed.${NC}"
  go version
else
  echo -e "${YELLOW}Installing Go...${NC}"
  wget -q https://go.dev/dl/go1.24.1.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go1.24.1.linux-amd64.tar.gz
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
  echo 'export GOROOT=/usr/local/go' >> ~/.profile
  echo 'export GOPATH=$HOME/go' >> ~/.profile
  echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.profile
  source ~/.profile
  check_success "Go installation" "critical"
  go version
  rm go1.24.1.linux-amd64.tar.gz
fi

# Install Fabric
print_header "Installing Fabric"
if command_exists fabric; then
  echo -e "${GREEN}✓ Fabric is already installed.${NC}"
  fabric --version
else
  echo -e "${YELLOW}Installing Fabric...${NC}"
  
  # Try Go installation first
  echo -e "${YELLOW}Attempting to install via Go...${NC}"
  go install github.com/danielmiessler/fabric@latest
  
  if [ $? -ne 0 ] || ! command_exists fabric; then
    echo -e "${YELLOW}Go installation failed, trying direct download method...${NC}"
    curl -L https://github.com/danielmiessler/fabric/releases/latest/download/fabric-linux-amd64 > fabric
    chmod +x fabric
    sudo mv fabric /usr/local/bin/
  fi
  
  check_success "Fabric installation" "critical"
  fabric --version
fi

# Install Python and Streamlit
print_header "Installing Streamlit for Fabric UI"
if command_exists streamlit; then
  echo -e "${GREEN}✓ Streamlit is already installed.${NC}"
else
  echo -e "${YELLOW}Installing Python and Streamlit...${NC}"
  sudo apt install -y python3 python3-pip
  pip3 install streamlit
  check_success "Streamlit installation"
fi

# Download Fabric UI files
print_header "Setting Up Fabric UI"
echo -e "${YELLOW}Downloading Fabric UI files...${NC}"
curl -O https://raw.githubusercontent.com/danielmiessler/fabric/main/streamlit.py
curl -O https://raw.githubusercontent.com/danielmiessler/fabric/main/requirements.txt
pip install -r requirements.txt
check_success "Downloading Fabric UI files"

# Setup Fabric
print_header "Fabric Setup"
echo -e "${YELLOW}You'll now go through Fabric setup to configure your directories and API keys.${NC}"
echo -e "${YELLOW}Select the appropriate options for Anthropic and Ollama when prompted.${NC}"
echo -e "${YELLOW}Press Enter to continue...${NC}"
read
fabric --setup

# Final instructions
print_header "Setup Complete!"
echo -e "${GREEN}Everything is set up! Here's how to use these tools:${NC}"
echo
echo -e "${YELLOW}To use Ollama:${NC}"
echo -e "  ollama run llama3.2:1b                             # Interactive chat"
echo -e "  echo \"Your prompt\" | ollama run llama3.2:1b        # One-off response"
echo
echo -e "${YELLOW}To use Fabric:${NC}"
echo -e "  fabric --help                                      # Get help"
echo -e "  fabric -L                                          # List models"
echo -e "  fabric -d ollama/llama3.2:1b                       # Set default model"
echo -e "  fabric -l                                          # List patterns"
echo -e "  echo \"Explain black holes like I'm 5\" | fabric -s  # Simple prompt"
echo -e "  cat file.txt | fabric -sp summarize                # Apply pattern to file"
echo
echo -e "${YELLOW}To run Fabric UI:${NC}"
echo -e "  streamlit run streamlit.py                         # Start web interface"
echo -e "  Then open: http://localhost:8501"
echo
echo -e "${GREEN}All set! Happy prompting!${NC}"
