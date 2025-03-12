# Nix Configuration Guide

## Commands
- Build/switch: `darwin-rebuild switch --flake ~/.config/nix`
- Check flake: `nix flake check`
- Format: `nixfmt <file>` (using nixfmt-rfc-style package in `home.packages`)
- Lint: `nil diagnostics <file>`
- Validate: `nix-instantiate --parse <file>` (syntax check only)
- Update inputs: `nix flake update`

## Code Style Guidelines
- **Formatting**: 2-space indentation, 80-character line limit
- **Naming**: Use camelCase for attributes, descriptive names for modules
- **Imports**: Group imports by category (system, home-manager, etc.)
- **Comments**: Document non-obvious configurations or workarounds
- **Module Structure**: 
  - Keep modules focused on a single concern
  - Use default.nix to re-export modules
  - Include module arguments in function header
- **Attribute Sets**: Sort attributes alphabetically when logical
- **Conditionals**: Use concise conditionals where appropriate
- **Strings**: Use double quotes by default, single quotes for attribute names

## Layout
Keep related configuration in appropriate directories:
- darwin/ for macOS system settings
- home/ for user configuration
- hosts/ for machine-specific settings