.PHONY: help create clean

MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))


DOCKGEN_MODEL_NAME = dockgenmodel
DOCKGEN_MODEFILE = DocGen.Modelfile

PIPELINE_MODEL_NAME = pipelinemodel
PIPELINE_MODEFILE = Pipeline.Modelfile

CODE_REVIEW_MODEL_NAME = codereviewmodel
CODE_REVIEW_MODEFILE = CodeReview.Modelfile

help:
	@echo "Available commands:"
	@echo "  make create_pipeline_model    - Create the pipeline Ollama model"
	@echo "  make create_dockgen_model     - Create the docgen Ollama model"
	@echo "  make project_to_readme        - Generate README.md from project structure"
	@echo "  make update-readme            - Update README.md based on git changes"
	@echo "  make project-sync             - Code review and auto-update documentation"
	@echo "  make clean_pipeline_model     - Remove the pipeline model"
	@echo "  make clean_dockgen_model      - Remove the docgen model"

create_pipeline_model:
	@echo "Creating model '$(PIPELINE_MODEL_NAME)' from $(PIPELINE_MODEFILE)..."
	@ollama rm $(PIPELINE_MODEL_NAME) 2>/dev/null || true
	ollama create $(PIPELINE_MODEL_NAME) -f  "$(MAKEFILE_DIR)$(PIPELINE_MODEFILE)"
	@echo "Model created successfully!"

clean_pipeline_model:
	@echo "Removing model '$(PIPELINE_MODEL_NAME)'..."
	ollama rm $(PIPELINE_MODEL_NAME)
	@echo "Model removed successfully!"

create_dockgen_model:
	@echo "Creating model '$(DOCKGEN_MODEL_NAME)' from $(DOCKGEN_MODEFILE)..."

	@ollama rm $(DOCKGEN_MODEL_NAME) 2>/dev/null || true
	ollama create $(DOCKGEN_MODEL_NAME) -f "$(MAKEFILE_DIR)$(DOCKGEN_MODEFILE)"
	@echo "Model created successfully!"
clean_dockgen_model:
	@echo "Removing model '$(DOCKGEN_MODEL_NAME)'..."
	ollama rm $(DOCKGEN_MODEL_NAME)
	@echo "Model removed successfully!"


create_code_review_model:
	@echo "Creating model '$(CODE_REVIEW_MODEL_NAME)' from $(CODE_REVIEW_MODEFILE)..."
	@ollama rm $(CODE_REVIEW_MODEL_NAME) 2>/dev/null || true
	ollama create $(CODE_REVIEW_MODEL_NAME) -f  "$(MAKEFILE_DIR)$(CODE_REVIEW_MODEFILE)"
	@echo "Model created successfully!"

clean_code_review_model:
	@echo "Removing model '$(CODE_REVIEW_MODEL_NAME)'..."
	ollama rm $(CODE_REVIEW_MODEL_NAME)
	@echo "Model removed successfully!"



project_to_readme:
	@( \
	  echo "Here is the current directory structure:"; \
	  ls -R; \
	  echo -e "\nHere are the contents of the source files:"; \
	  find . -maxdepth 2 -not -path '*/.*' -type f -exec echo "--- File: {} ---" \; -exec cat {} \;; \
	) | ollama run $(PIPELINE_MODEL_NAME) "Based on this project structure and code, write a professional README.md. Include a summary, features, and file overview. Output ONLY markdown." > README.md

update-readme:
	@if [ -n "$$(git status --porcelain)" ]; then \
	  echo "🔍 Changes detected. Regenerating README..."; \
	  ( \
	    echo "GIT DIFF SUMMARY:"; \
	    git diff --stat; \
	    echo -e "\nPROJECT STRUCTURE:"; \
	    find . -maxdepth 2 -not -path "*/.*" -not -path "./node_modules/*"; \
	    echo -e "\nFILE CONTENTS:"; \
	    find . -maxdepth 2 -not -path "*/.*" -not -path "./node_modules/*" -type f \
	    \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.go" -o -name "*.rs" -o -name "*.txt" -o -name "*.sh" \) \
	    -exec echo -e "\n--- File: {} ---" \; -exec cat {} \; \
	  ) | ollama run $(DOCKGEN_MODEL_NAME) > README.md && echo "✅ README.md updated based on latest changes."; \
	else \
	  echo "✨ No changes detected in git. README is already up to date."; \
	fi

project-sync:
	@if [ -n "$$(git status --porcelain)" ]; then \
	  echo "🧐 Starting Code Review..."; \
	  git diff | ollama run $(CODE_REVIEW_MODEL_NAME); \
	  echo -e "\n📝 Updating README..."; \
	  ( \
	    git diff --stat; \
	    find . -maxdepth 2 -not -path "*/.*" -not -path "./node_modules/*" -type f \
	    \( -name "*.py" -o -name "*.js" -o -name "*.go" -o -name "*.ts" \) \
	    -exec echo "--- {} ---" \; -exec cat {} \; \
	  ) | ollama run $(DOCKGEN_MODEL_NAME) > README.md; \
	  echo "✅ Project documentation and review complete."; \
	else \
	  echo "✨ No changes to process."; \
	fi




