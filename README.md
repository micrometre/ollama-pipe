# Ollama Pipe

Use Ollama as a powerful text processing tool in Linux pipelines—like `sed`, `grep`, and `awk`, but with AI capabilities. Process data, transform logs, and edit files without writing API code.

## Overview

Ollama's CLI can read from stdin, treating piped text as part of the prompt. This makes it perfect for Unix pipelines and standard input/output redirection.

```bash
cat data.txt | ollama run mymodel "transform this text"
```

## Setup

### 1. Install Ollama

Download and install from [ollama.ai](https://ollama.ai)

### 2. Pull a Model

```bash
ollama pull llama2  # or any model you prefer
```

## The Problem: Chatty Output

By default, LLMs are "chatty"—adding explanations like "Sure! Here is your JSON..." This breaks Unix pipelines. The solution is a custom Modelfile.

## Creating a Pipeline Modelfile

### Step 1: Create a "Pipeline" Modelfile

```docker
FROM llama3.2:1b
PARAMETER temperature 0
SYSTEM "You are a Unix utility. Output ONLY the processed text. No greetings. No explanations."
```




### Step 2: Build the Custom Model

```bash
ollama create pipelinemodel -f Modelfile
```

### Step 3: Use It in Pipelines

Now use it like any Unix utility:

```bash
cat file.txt | ollama run pipelinemodel "your instruction here" > output.txt
```

## Use Cases & Examples

### Text Transformation (sed replacement)

Convert CSV to JSON:

```bash
cat tests/data.csv | ollama run pipelinemodel "convert this CSV data to a JSON array" > data.json
```


### Semantic Filtering (grep replacement)

Unlike traditional `grep`, find patterns by meaning:

```bash
cat tests/server.log | ollama run pipelinemodel "output only the lines that indicate a security threat"
```

### Data Extraction (awk replacement)

Extract structured data from unstructured text:

```bash
curl -s https://example.com | ollama run pipelinemodel "extract all the headers and links into a markdown list"
```

### Code Review (AI-Powered Static Analysis)

Automatically review code changes for bugs, security issues, and style improvements:

```bash
git diff | ollama run code-reviewer
```

This analyzes your Git diff and provides:
- 🔴 **CRITICAL**: Bugs, security leaks, or logic errors
- 🟡 **IMPROVEMENT**: Performance and readability issues
- 🟢 **STYLE**: Naming conventions and clean code suggestions
- ✨ **SUMMARY**: Quick verdict on the changes

## Automation with Make

The project includes Makefile commands for easy automation:

```bash
make project-sync    # Code review + auto-update README from changes
make update-readme   # Regenerate README based on git changes
make project_to_readme  # Generate README from entire project structure
```

## Tips

- Adjust `temperature` in the Modelfile for consistency (0 = deterministic)
- Use small, fast models for quick pipeline operations
- Combine with standard Unix tools for powerful workflows

## License

See LICENSE file for details.



