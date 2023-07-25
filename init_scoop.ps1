Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time

# Check if scoop is installed
$ScoopExists = $true
try {
    $null = scoop update
} catch {
    $ScoopExists = $false
}

if (-not $ScoopExists) {
    # Install scoop
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

scoop install sudo
sudo scoop install 7zip git --global
scoop install python nodejs gcc git-with-openssh cmake youtube-dl  docker
scoop install gh # github cli
scoop install bit # Fancy autocomplete git
## Extras
scoop bucket add extras
scoop install extras/powertoys # For fancyzones
scoop install extras/obsidian
scoop install extras/vscode
scoop install extras/obs-studio
scoop install extras/zoom
scoop install extras/googlechrome
scoop install extras/qbittorrent

scoop update *
Read-Host -Prompt "Press Enter to exit"
