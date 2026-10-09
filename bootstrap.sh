#!/usr/bin/env bash
set -euo pipefail

# Usage: ./bootstrap.sh [-y|--yes]
#   curl -fsSL <url>/bootstrap.sh | bash -s -- --yes
# -y/--yes (or BOOTSTRAP_YES=1) passes --yes to `mise bootstrap` so it
# runs without confirmation prompts.
BOOTSTRAP_YES="${BOOTSTRAP_YES:-0}"
while [ $# -gt 0 ]; do
    case "$1" in
        -y|--yes) BOOTSTRAP_YES=1 ;;
        *) echo "Unknown argument: $1" >&2; exit 1 ;;
    esac
    shift
done

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
echo "  2) Work (Linux)"
echo "  3) Server (Linux)"
read -r -p "Enter choice [1/2/3, default: 1]: " CHOICE
CHOICE="${CHOICE:-1}"

if [ "$CHOICE" = "2" ] || [ "$CHOICE" = "work" ]; then
    echo "[✓] Selected Work profile (-E work)"
    BOOTSTRAP_ENV_FLAG="-E work"
elif [ "$CHOICE" = "3" ] || [ "$CHOICE" = "server" ]; then
    echo "[✓] Selected Server profile (-E server)"
    BOOTSTRAP_ENV_FLAG="-E server"
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
BOOTSTRAP_ARGS=(--adopt "$DOTFILES_REPO")
if [ "$BOOTSTRAP_YES" = "1" ]; then
    BOOTSTRAP_ARGS+=(--yes)
fi
mise $BOOTSTRAP_ENV_FLAG bootstrap "${BOOTSTRAP_ARGS[@]}"

