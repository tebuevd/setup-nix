# Nix Darwin Configuration

This repository contains my personal Nix Darwin configuration for macOS. It uses [nix-darwin](https://github.com/LnL7/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager) to manage system and user configuration.

## Features

- Complete macOS system configuration via Nix
- Homebrew integration for additional software
- VS Code configuration with extensions
- Git, ZSH, and other developer tools

## Structure

The configuration is organized into the following modules:

- `flake.nix`: Main entry point with inputs and outputs
- `hosts/`: Host-specific configuration
- `darwin/`: macOS-specific system configuration
  - `system/`: System-level settings (keyboard, preferences, security, etc.)
  - `apps/`: Application-specific configuration (homebrew, etc.)
- `home/`: User-specific configuration managed by home-manager
  - `packages.nix`: User packages
  - `shell/`: Shell configuration (zsh)
  - `programs/`: User programs configuration (git, tmux, etc.)
    - `terminals/`: Terminal emulators configuration (ghostty)
  - `editors/`: Code editor configuration (vim, vscode, zed)
- `config/`: Configuration files for various applications

## Getting Started

### Prerequisites

1. Install Nix via Determinate Systems:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
   ```

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/nix-config.git ~/.config/nix
   cd ~/.config/nix
   ```

2. Create your personal configuration:
   ```bash
   cp local.example.nix local.nix
   ```

3. Edit `local.nix` with your personal information:
   ```nix
   {
     hostname = "your-macbook";      # Your machine's hostname
     username = "yourusername";      # Your macOS username
     fullName = "Your Full Name";    # Your name for Git commits
     email = "your.email@example.com"; # Your primary email
     githubEmail = "your.github.email@example.com"; # Email for GitHub
     architecture = "aarch64-darwin"; # or "x86_64-darwin" for Intel Macs
   }
   ```

4. Build and activate the configuration:
   ```bash
   nix run nix-darwin/master#darwin-rebuild -- switch --flake .
   ```

### Updating

To update your system:

```bash
cd ~/.config/nix
git pull
darwin-rebuild switch --flake ~/.config/nix
```

Or simply use the alias defined in the configuration:

```bash
switch
```

## Customization

- Add packages in the appropriate module files
- Configure additional macOS settings in the `darwin/system` directory
- Add Homebrew packages in `darwin/apps/homebrew.nix`
- Add new modules by creating files in the appropriate directories and importing them in the corresponding `default.nix`

## Adding New Configuration

1. Add new nix files to the appropriate directory based on the type of configuration
2. Import the new file in the corresponding `default.nix`
3. Rebuild with `switch` command

## Troubleshooting

If you see errors about the hostname not being found in the flake outputs:
- Check that your `local.nix` file contains the correct hostname
- Try running with the full hostname: `darwin-rebuild switch --flake ~/.config/nix#your-hostname`