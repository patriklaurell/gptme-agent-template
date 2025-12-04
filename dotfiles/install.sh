#!/bin/bash
# Install dotfiles by creating symlinks
# Run from the dotfiles directory: ./install.sh
#
# Structure follows XDG conventions:
#   ~/.config/git/hooks/ -> <repo>/dotfiles/.config/git/hooks/
#   ~/.config/pre-commit/ -> <repo>/dotfiles/.config/pre-commit/

set -e

# Get the absolute path to the dotfiles directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# Detect agent name from parent directory
AGENT_DIR="$(dirname "$DOTFILES_DIR")"
AGENT_NAME="$(basename "$AGENT_DIR")"

echo "Installing dotfiles for agent: $AGENT_NAME"
echo "Dotfiles location: $DOTFILES_DIR"
echo ""

# Create parent directories
mkdir -p ~/.config/git
mkdir -p ~/.git-templates

# Remove existing symlinks or directories
rm -f ~/.config/git/hooks 2>/dev/null || true
rm -f ~/.config/pre-commit 2>/dev/null || true

# Symlink entire directories (cleaner, auto-updates with new files)
echo "Symlinking git hooks directory..."
ln -sf "$DOTFILES_DIR/.config/git/hooks" ~/.config/git/hooks

echo "Symlinking pre-commit config directory..."
ln -sf "$DOTFILES_DIR/.config/pre-commit" ~/.config/pre-commit

# Configure git to use hooks directory
echo "Configuring git..."
git config --global core.hooksPath ~/.config/git/hooks

# Set up template directory for new repos (pre-commit init-templatedir)
echo "Setting up git template directory..."
git config --global init.templateDir ~/.git-templates
pre-commit init-templatedir ~/.git-templates 2>/dev/null || echo "Note: pre-commit not found, skipping template init"

echo ""
echo "✅ Dotfiles installed successfully!"
echo ""
echo "Installed:"
echo "  - Git hooks: ~/.config/git/hooks/ -> $DOTFILES_DIR/.config/git/hooks/"
echo "  - Pre-commit config: ~/.config/pre-commit/ -> $DOTFILES_DIR/.config/pre-commit/"
echo "  - Git config: core.hooksPath and init.templateDir"
echo ""
echo "Optional: Configure forbidden repo patterns"
echo "  Create ~/.config/git/forbidden-repos with one pattern per line"
echo "  Example:"
echo "    # External repos without push access"
echo "    gptme/gptme"
echo "    gptme/gptme-contrib"
echo ""
echo "To test:"
echo "  cd $AGENT_DIR && git commit --allow-empty -m 'test hooks'"
