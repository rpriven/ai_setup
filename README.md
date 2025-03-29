Scripts and tips for setting up AI (Ollama, Fabric, UI) including local and with API keys

   ![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)
   ![Platform](https://img.shields.io/badge/Platform-WSL-green.svg)

# Ollama & Fabric Setup for WSL

This script automates the setup of [Ollama](https://ollama.com/), [Go](https://go.dev/), and [Fabric](https://github.com/danielmiessler/fabric) on WSL (Windows Subsystem for Linux).

### What This Script Does 

- Updates your WSL system packages
- Installs Ollama and downloads the llama3.2:1b model
- Installs Go and sets up environment variables
- Installs Fabric CLI and configures it
- Sets up Streamlit for Fabric UI

## Installation

### Method 1: Download and Run (Recommended)

```bash
# Download the script first
curl -O https://raw.githubusercontent.com/rpriven/ai_setup/refs/heads/main/wsl_ollama_fabric.sh

# Make it executable
chmod +x setup_ollama_fabric.sh

# Run the script
./setup_ollama_fabric.sh
```

### Method 2: Direct Installation

```
curl -fsSL https://raw.githubusercontent.com/rpriven/ai_setup/refs/heads/main/wsl_ollama_fabric.sh | bash
```

### Method 3: Manual Installation: 

See my detailed [PDF Guide](https://github.com/rpriven/ai_setup/blob/main/Guide%20-%20Setting%20Up%20WSL%2C%20Ollama%2C%20Fabric%20and%20Running%20LLM%20and%20AI%20Models%20Locally.pdf) for step-by-step instructions.

---

### After Installation - Basic Usage

#### Ollama Usage
```bash
# Start an interactive chat
ollama run llama3.2:1b

# Generate a one-off response
echo "What is the meaning of life?" | ollama run llama3.2:1b

# List available models
ollama list
```

#### Fabric Usage

```bash
# Get help
fabric --help

# List available models
fabric -L

# Set default model
fabric -d ollama/llama3.2:1b

# List patterns
fabric -l

# Run a simple prompt
echo "Explain quantum computing like I'm 5" | fabric -s

# Apply a pattern to analyze a website
fabric -u https://example.com -p analyze_claims

# Summarize a file
cat document.txt | fabric -sp summarize

# Extract key information from text
cat article.txt | fabric -sp extract_wisdom
```

#### Fabric UI

```bash
# Start the web interface
streamlit run streamlit.py

# Then open in your browser:
# http://localhost:8501
```

### Troubleshooting 

#### Common Issues 

1. Ollama fails to start
  - Ensure WSL has enough memory allocated
  - Check with `ollama --version` to confirm installation
         
2. Go installation issues  
  - Verify with `go version`
  - Ensure PATH is set correctly with `echo $PATH`

3. Fabric not found
  - Run `which fabric` to check installation
  - Verify Go path with `echo $GOPATH`   

### Getting Help 

If you encounter issues not covered here, please open an issue with details about your environment and the error messages you're seeing. 

### Contributing 

Contributions are welcome! Please feel free to submit a Pull Request. 

- Fork the repository
- Create your feature branch (`git checkout -b feature/amazing-feature`)
- Commit your changes (`git commit -m 'Add some amazing feature'`)
- Push to the branch (`git push origin feature/amazing-feature`)
- Open a Pull Request

## Acknowledgments 

- [Ollama](https://ollama.com/) for their excellent local LLM runner
- [Daniel Miessler](https://github.com/danielmiessler) for creating Fabric
- All open-source contributors to these projects

## Additional Resources

- [Official WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Ollama GitHub Repository](https://github.com/ollama/ollama)
- [Fabric GitHub Repository](https://github.com/danielmiessler/fabric)
- [Anthropic API Documentation](https://docs.anthropic.com/claude/reference/getting-started-with-the-api)

Thank you for checking this out.  Please let me know if there are any issues!

Copyright © 2024 Rob Pratt (rpriven)

### License 

This project is licensed under the GNU General Public License v3.0 - see the LICENSE  file for details. 
