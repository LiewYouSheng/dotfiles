# Initialization Scripts

This repository contains a set of scripts designed to initialize a new developer workstation with common tools and configurations for C++, Python, and JavaScript development.

## Repository Structure

```
.
├── README.md
├── scripts
│ ├── main.ps1
│ ├── initialize.ps1
│ ├── scoop.ps1
│ ├── zsh.ps1
│ ├── github.ps1
│ ├── ssh_keygen.ps1
│ ├── admin_powershell.ps1
│ ├── dotfiles
│ │ ├── .zshrc
│ │ ├── .vimrc
│ │ └── ...
├── modules
│ ├── PrivilegeEscalation.psm1
├── env
│ └── .env
└── .gitignore

```

## Setup Instructions

1. Clone this repository:
```bash
git clone https://github.com/LiewYouSheng/dotfiles.git
```

2. Navigate into the cloned repository:
```
cd dotfiles
```

3. Run the main script in PowerShell:
```
.\scripts\main.ps1
```

The above command will initiate the workstation setup process by executing a series of scripts:

- `initialize.ps1`: General workstation setup.
- `scoop.ps1`: Install and configure Scoop, and install common tools via Scoop.
- `zsh.ps1`: Install and configure Zsh.
- `github.ps1`: Setup GitHub SSH keys.
- `ssh_keygen.ps1`: Generate SSH keys.
- `admin_powershell.ps1`: Privilege escalation script to run commands as an administrator.
- `dotfiles`: Various dotfiles for tool configurations.

This will prompt for Administrator privileges when you start your PowerShell script. If it is not started with Administrator privileges, it will relaunch itself with Administrator privileges.

## Environment Variables
Sensitive information like GitHub username and personal access token are stored in a .env file in the env folder. This file is read by the github.ps1 script.

Create a .env file with the following structure:
```env
GITHUB_USER=yourusername
GITHUB_TOKEN=yourtoken
```

Replace yourusername and yourtoken with your actual GitHub username and personal access token.
