#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    log_error "This script should not be run as root"
    exit 1
fi

# Check if NixOS
if [[ ! -f /etc/NIXOS ]]; then
    log_error "This script is designed for NixOS only"
    exit 1
fi

log_info "Starting Hyprland Dotfiles NixOS installation..."

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

log_info "Dotfiles directory: $DOTFILES_DIR"

# Backup existing configuration
BACKUP_DIR="$HOME/.config/nixos-backup-$(date +%Y%m%d-%H%M%S)"
if [[ -d /etc/nixos ]]; then
    log_info "Backing up existing NixOS configuration to $BACKUP_DIR"
    sudo mkdir -p "$BACKUP_DIR"
    sudo cp -r /etc/nixos/* "$BACKUP_DIR/" 2>/dev/null || true
fi

# Create hardware configuration if it doesn't exist
if [[ ! -f "$SCRIPT_DIR/hosts/default/hardware-configuration.nix" ]]; then
    log_info "Generating hardware configuration..."
    sudo nixos-generate-config --show-hardware-config > "$SCRIPT_DIR/hosts/default/hardware-configuration.nix"
    log_success "Hardware configuration generated"
fi

# Copy configuration to /etc/nixos
log_info "Installing NixOS configuration..."
sudo rm -rf /etc/nixos/*
sudo cp -r "$SCRIPT_DIR"/* /etc/nixos/
sudo chown -R root:root /etc/nixos

# Enable flakes if not already enabled
if ! grep -q "experimental-features.*flakes" /etc/nix/nix.conf 2>/dev/null; then
    log_info "Enabling Nix flakes..."
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
fi

# Copy dotfiles to user directory
log_info "Installing dotfiles..."
mkdir -p "$HOME/.config"
cp -r "$DOTFILES_DIR/.config"/* "$HOME/.config/" 2>/dev/null || true
cp -r "$DOTFILES_DIR/.local" "$HOME/" 2>/dev/null || true

# Make scripts executable
if [[ -d "$HOME/.local/bin" ]]; then
    chmod +x "$HOME/.local/bin"/*
fi

# Create wallpapers directory
mkdir -p "$HOME/.local/share/wallpapers"
if [[ -d "$DOTFILES_DIR/wallpapers" ]]; then
    cp -r "$DOTFILES_DIR/wallpapers"/* "$HOME/.local/share/wallpapers/"
fi

log_info "Building NixOS configuration..."
if sudo nixos-rebuild switch --flake /etc/nixos#default; then
    log_success "NixOS configuration built successfully!"
else
    log_error "Failed to build NixOS configuration"
    log_info "You can try building manually with: sudo nixos-rebuild switch --flake /etc/nixos#default"
    exit 1
fi

log_info "Installing Home Manager configuration..."
if nix run home-manager/master -- switch --flake /etc/nixos#t0psh31f; then
    log_success "Home Manager configuration applied successfully!"
else
    log_warning "Home Manager configuration failed, but system configuration succeeded"
    log_info "You can try applying it manually with: home-manager switch --flake /etc/nixos#t0psh31f"
fi

log_success "Installation completed!"
log_info "Please reboot your system to ensure all changes take effect"
log_info "After reboot, you can start Hyprland from your display manager or TTY"

echo
log_info "Useful commands:"
echo "  - Rebuild system: sudo nixos-rebuild switch --flake /etc/nixos#default"
echo "  - Update flake inputs: nix flake update /etc/nixos"
echo "  - Apply home-manager: home-manager switch --flake /etc/nixos#t0psh31f"
echo "  - Start Hyprland: Hyprland (from TTY)"
