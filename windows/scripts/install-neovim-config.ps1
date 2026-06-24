$ErrorActionPreference = "Stop"

$nvimConfigDir = Join-Path $env:LOCALAPPDATA "nvim"
$nvimGitDir = Join-Path $nvimConfigDir ".git"
$nvimConfigBranch = "mac"

if (Test-Path -LiteralPath $nvimGitDir) {
    "Neovim config already installed"
    git -C $nvimConfigDir fetch origin $nvimConfigBranch
    git -C $nvimConfigDir checkout $nvimConfigBranch
    exit 0
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    "git not found; skipping Neovim config install"
    exit 0
}

if (-not (Test-Path -LiteralPath (Split-Path -Parent $nvimConfigDir))) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $nvimConfigDir) | Out-Null
}

"Installing Neovim config..."
git clone https://github.com/TylerHillery/kickstart.nvim.git $nvimConfigDir
git -C $nvimConfigDir checkout $nvimConfigBranch
