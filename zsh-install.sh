#!/bin/zsh

repos=(
  "https://github.com/romkatv/powerlevel10k"
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/Aloxaf/fzf-tab"
  "https://github.com/zsh-users/zsh-syntax-highlighting"
)

# Define the base directory where repositories will be cloned
PLUGIN_BASE_DIR="zsh/.zsh/plugins"

echo "Starting repository cloning process..."
echo "-------------------------------------"

# Create the base directory if it doesn't exist
mkdir -p "$PLUGIN_BASE_DIR" || {
  echo "Error: Could not create directory '$PLUGIN_BASE_DIR'. Exiting."
  exit 1
}
echo "Ensured base directory '$PLUGIN_BASE_DIR' exists."

# Loop through each repository URL in the array
for repo_url in "${repos[@]}"; do
  # Extract the repository name from the URL
  # This handles URLs with or without a trailing '#' or '.git'
  repo_name=$(basename "$repo_url")
  repo_name="${repo_name%.git}" # Remove .git suffix if present
  repo_name="${repo_name%#*}"   # Remove anything after # if present

  # Define the full path where this specific repository will be cloned
  clone_path="$PLUGIN_BASE_DIR/$repo_name"

  echo "\nProcessing repository: $repo_name"
  echo "URL: $repo_url"
  echo "Target path: $clone_path"

  # Check if the repository directory already exists at the target path
  if [[ -d "$clone_path" && -d "$clone_path/.git" ]]; then
    echo "  Directory '$clone_path' already exists. Skipping clone."
  else
    echo "  Directory '$clone_path' does not exist. Attempting to shallow clone..."
    # Perform a shallow clone with depth 1 into the specified path
    # --quiet suppresses most output, --depth 1 only fetches the latest commit
    if git clone --depth 1 --quiet "$repo_url" "$clone_path"; then
      echo "  Successfully cloned '$repo_name' into '$clone_path'."
    else
      echo "  Error: Failed to clone '$repo_name' into '$clone_path'."
      echo "  Please check the URL or your network connection."
    fi
  fi
done

echo "\n-------------------------------------"
echo "Repository cloning process completed."
