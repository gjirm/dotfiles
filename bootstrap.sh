#!/usr/bin/env bash
set -euo pipefail

echo "=================================================================="
echo "🚀 Workstation Bootstrap (Mise)"
echo "=================================================================="
echo ""

# ------------------------------------------------------------------------------
# 1. Install & Activate Mise
# ------------------------------------------------------------------------------
if ! command -v mise &>/dev/null && [ ! -x "$HOME/.local/bin/mise" ]; then
    echo "[-] Installing Mise..."
    curl -fsSL https://mise.run | sh
    echo "[✓] Mise installed"
else
    echo "[✓] Mise is already installed"
fi

export PATH="$HOME/.local/bin:$PATH"
CURRENT_SHELL="$(basename "${SHELL:-bash}")"
eval "$("$HOME/.local/bin/mise" activate "$CURRENT_SHELL" 2>/dev/null || "$HOME/.local/bin/mise" activate bash)"

# ------------------------------------------------------------------------------
# 2. Select Machine Purpose (Personal vs Work)
# ------------------------------------------------------------------------------
echo ""
echo "Select the configuration profile for this machine:"
echo "  1) Personal (Linux) [Default]"
echo "  2) Work (macOS)"
read -r -p "Enter choice [1/2, default: 1]: " CHOICE
CHOICE="${CHOICE:-1}"

if [ "$CHOICE" = "2" ] || [ "$CHOICE" = "work" ]; then
    echo "[✓] Selected Work profile (-E work)"
    BOOTSTRAP_ENV_FLAG="-E work"
else
    echo "[✓] Selected Personal profile (-E personal)"
    BOOTSTRAP_ENV_FLAG="-E personal"
fi
export BOOTSTRAP_ENV_FLAG

DOTFILES_REPO="gjirm/dotfiles"
DOTFILES_DIR="$HOME/.config/mise"

if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo "[-] Cloning dotfiles repo into $DOTFILES_DIR..."
    git clone --branch mise "https://github.com/${DOTFILES_REPO}.git" "$DOTFILES_DIR"
else
    echo "[✓] $DOTFILES_DIR is already a git checkout"
fi

cd "$DOTFILES_DIR"
echo "[-] Running bootstrap..."
mise $BOOTSTRAP_ENV_FLAG bootstrap --adopt "$DOTFILES_REPO"

