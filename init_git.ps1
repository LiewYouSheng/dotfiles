if (Test-Path -Path ".\.env") {
    $envContent = Get-Content -Path ".\.env"
    foreach ($line in $envContent) {
        if ($line.StartsWith("GITHUB_USER")) {
            $githubUser = $line.Split("=")[1]
        }
        if ($line.StartsWith("GITHUB_TOKEN")) {
            $githubToken = $line.Split("=")[1]
        }
    }
}


# Get user email info
$uri = "https://api.github.com/user/public_emails"

$response = Invoke-RestMethod -Uri $uri -Method Get -Headers @{
    "Authorization" = "Bearer $githubToken"
    "Accept" = "application/vnd.github+json"
    "User-Agent" = "PowerShell"
}

# Get the first email from the response
$gitEmail = $response[0].email

# Set git email and username globally
git config --global user.email "$gitEmail"
git config --global user.name "$githubUser"

# Print confirmation messages
Write-Output "Git user name has been set to: $githubUser"
Write-Output "Git email has been set to: $gitEmail"
