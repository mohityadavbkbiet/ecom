#!/bin/bash

# GitHub username
username="mohityadavbkbiet"

# GitHub API endpoint to list user repositories (including private ones)
apiUrl="https://api.github.com/users/$username/repos"

# Function to delete a directory recursively
remove_directory() {
    local path=$1

    if [ -d "$path" ]; then
        rm -rf "$path"
        echo "Deleted existing directory: $path"
    fi
}

# Get list of repositories using curl (no authentication needed for public repositories)
repos=$(curl -s "$apiUrl" | grep -o 'git@[^"]*')

# Loop through each repository
for repoUrl in $repos; do
    # Extract repository name from URL
    repoName=$(basename "$repoUrl" .git)
    
    # Remove existing directory if it exists
    remove_directory "$repoName"
    
    # Clone the repository using Git with SSH authentication
    git clone "$repoUrl"
    
    # Change directory to the cloned repository
    cd "$repoName" || continue  # Continue to next iteration if cd fails
    
    # Remove the existing .git directory if it exists
    remove_directory ".git"
    
    # Initialize a new Git repository
    git init
    
    # Add all files to the staging area
    git add .
    
    # Commit the changes with an empty message
    git commit --allow-empty-message --no-edit
    
    # Create and checkout a new branch (e.g., main)
    git checkout -b main
    
    # Add a remote repository (replace URL with your repository URL)
    git remote add origin "$repoUrl"
    
    # Push the changes to the remote main branch
    git push -u origin main
    
    # Go back to the parent directory
    cd ..
done
