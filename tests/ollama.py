import subprocess

# Fetch content and pipe through ollama for semantic extraction
result = subprocess.run(
    'curl -s https://example.com | ollama run pipelinemodel "extract all the headers and links into a markdown list"',
    shell=True,
    capture_output=True,
    text=True
)

# Print the output
print(result.stdout)
if result.stderr:
    print("Errors:", result.stderr)