# Nix Darwin Configuration

This repository contains my personal Nix Darwin configuration for macOS. It uses [nix-darwin](https://github.com/LnL7/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager) to manage system and user configuration.

## Features

- Complete macOS system configuration via Nix
- Homebrew integration for additional software
- VS Code configuration with extensions
- Git, ZSH, and other developer tools

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
   cp nix/local.example.nix nix/local.nix
   ```

3. Edit `nix/local.nix` with your personal information:
   ```nix
   {
     hostname = "your-macbook";      # Your machine's hostname
     username = "yourusername";      # Your macOS username
     fullName = "Your Full Name";    # Your name for Git commits
     email = "your.email@example.com"; # Your primary email
     githubEmail = "your.github.email@example.com"; # Email for GitHub
   }
   ```

4. Add the file to Git in a special way to make it visible to Nix but not committed:
   ```bash
   git add --intent-to-add nix/local.nix
   git update-index --assume-unchanged nix/local.nix
   ```

5. Build and activate the configuration (`{hostname}` from `local.nix`):
   ```bash
   nix run nix-darwin/master#darwin-rebuild -- switch --flake .#{hostname}
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

- Add packages in `flake.nix` under `environment.systemPackages` or `home.packages`
- Configure additional macOS settings in the `system.defaults` section
- Add Homebrew packages in `homebrew.nix`
- Customize VS Code extensions in the `programs.vscode` section

## Troubleshooting

If you see errors about the hostname not being found in the flake outputs:
- Check that your `nix/local.nix` file contains the correct hostname
- Ensure the file is being tracked by Git (with the commands in step 4)
- Try running with the full hostname: `darwin-rebuild switch --flake ~/.config/nix#your-hostname`

## License

[MIT License](LICENSE)
