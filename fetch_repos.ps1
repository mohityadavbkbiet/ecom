# GitHub username
$username = "mohityadavbkbiet"

# GitHub API endpoint to list user repositories (including private ones)
$apiUrl = "https://api.github.com/users/$username/repos"

# Function to delete a directory recursively
function Remove-Directory {
    param (
        [string]$path
    )

    if (Test-Path -Path $path -PathType Container) {
        Remove-Item -Path $path -Recurse -Force
        Write-Host "Deleted existing directory: $path"
    }
}

# Get list of repositories using Invoke-RestMethod (no authentication needed for public repositories)
$repos = Invoke-RestMethod -Uri $apiUrl

# Loop through each repository
foreach ($repo in $repos) {
    # Get the repository details
    $repoName = $repo.name
    $repoUrl = $repo.ssh_url  # Use SSH URL for cloning
    
    # Determine if repository is private
    $isPrivate = $repo.private
    
    # Remove existing directory if it exists
    Remove-Directory -path $repoName
    
    # Clone the repository using Git with SSH authentication
    git clone $repoUrl
    
    # Change directory to the cloned repository
    cd $repoName
    
    # Remove the existing .git directory if it exists
    Remove-Directory -path ".git"
    
    # Initialize a new Git repository
    git init
    
    # Add all files to the staging area
    git add .
    
    # Commit the changes with an empty message
    git commit --allow-empty-message --no-edit
    
    # Create and checkout a new branch (e.g., main)
    git checkout -b main
    
    # Add a remote repository (replace URL with your repository URL)
    git remote add origin $repoUrl
    
    # Forcefully push the changes to the remote main branch
    git push -u origin main --force
    
    # Go back to the parent directory
    cd ..
}
