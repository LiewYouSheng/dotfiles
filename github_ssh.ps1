# Get the ssh-agent service
$service = Get-Service -Name ssh-agent

# Check if the service is disabled
if ($service.StartType -eq 'Disabled') {
    # If it is disabled, set it to manual
    $service | Set-Service -StartupType Manual

    # You may also want to start the service right away
    Start-Service ssh-agent
}

# Read .env file
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

# Prompt user for GitHub username and personal access token if not set
if (-not $githubUser -or $githubUser -eq "") {
    $githubUser = Read-Host -Prompt "Enter your GitHub username"
    "GITHUB_USER=$githubUser" | Set-Content -Path ".\.env" -NoNewline
}

if (-not $githubToken -or $githubToken -eq "") {
    # Open GitHub personal access tokens page
    Start-Process "https://github.com/settings/tokens/new"
    $githubToken = Read-Host -Prompt "Enter your GitHub personal access token"
    "GITHUB_TOKEN=$githubToken" | Add-Content -Path ".\.env" -NoNewline
}


$keyPath = "$HOME\.ssh\id_ed25519"

if (-Not (Test-Path $keyPath)) {
    ssh-keygen -t ed25519 -C "$githubUser@$(hostname)" -f "$keyPath" -N ""
    # Add SSH key to ssh-agent
    ssh-add "$keyPath"
}

# Get public key
$publicKey = Get-Content -Raw "$keyPath.pub"

# Use GitHub API to upload public key
$payload = @{
    title = "$(hostname)-Windows"
    key   = "${publicKey}"
} | ConvertTo-Json

Write-Output $payload

Invoke-RestMethod -Uri 'https://api.github.com/user/keys' -Method Post -Body $payload -Headers @{
    "Authorization" = "Basic $([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${githubUser}:${githubToken}")))"
    "User-Agent"    = "PowerShell"
} -ContentType "application/json"


Read-Host -Prompt "Press Enter to exit"
