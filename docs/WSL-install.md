# Setting up Ubuntu on Windows on Ubuntu Environment

WSL setup for building and testing Streamlit on Windows with Linux WSL.

## Prerequisities

Windows 10 Build 19044+ or Windows 11

## WSL Installation

On Powershell run:
```wsl --install --distribution Ubuntu-22.04```

On Windows, this distribution is now accessible as an application.

## Installing Python with WSL

Update distribution:
```sudo apt-get update```

Install Git:
```sudo apt-get install git```

Install Python:
```sudo apt install python3 python3-pip```

## Logging in to GitHub
If you want to go the old-fashioned way, you can generate a PAT and use that every time you want to push instead of a password. If you want to stick with just running `git push` follow the instructions below.

Install the GitHub CLI
```bash
 (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
     && sudo mkdir -p -m 755 /etc/apt/keyrings \
     && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
     && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
     && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
     && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
     && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
     && sudo apt update \
     && sudo apt install gh -y
```

Ensure the CLI installed properly
```bash
gh --version
```

Log in to GitHub
```bash
gh auth login
```

Then follow the directions to sign in
```
? Where do you use GitHub? GitHub.com
? What is your preferred protocol for Git operations on this host? HTTPS
? Authenticate Git with your GitHub credentials? Yes
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: <CODE>
Press Enter to open https://github.com/login/device in your browser...
✓ Authentication complete.
- gh config set -h github.com git_protocol https
✓ Configured git protocol
! Authentication credentials saved in plain text
✓ Logged in as <USERNAME>
```

## Logging into GitHub (Alternative)
https://github.com/git-ecosystem/git-credential-manager/blob/release/docs/credstores.md

## Starting Resources

[Streamlit Getting Started](https://docs.streamlit.io/get-started)

[Streamlit Docs](https://docs.streamlit.io/)

[Crash Course Youtube Video](https://youtu.be/20V_ZB7taCM)
