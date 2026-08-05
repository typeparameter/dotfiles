# dotfiles

These are my personal dotfiles for configuring development environments on macOS and Linux. The configuration is managed declaratively with [Nix] and [Home Manager], using platform-specific settings where appropriate.

## Installation

A working Nix installation is required. The `nix`, `nix-channel`, and `nix-shell` commands must be available in the current shell.

Run the installer from an interactive terminal.

```bash
curl -fsSL https://raw.githubusercontent.com/typeparameter/dotfiles/main/install.sh | bash
```

The installer performs the following steps.

- Detect and confirm the username and home directory
- Prompt for the Git user name and email
- Update the `nixpkgs` and `home-manager` channels, adding them if needed
- Clone this repository to `~/.config/home-manager`
- Generate the machine-specific `local.nix`
- Install and activate Home Manager

### Non-interactive installation

When no controlling terminal is available, the installer runs non-interactively. This can also be requested explicitly.

```bash
curl -fsSL https://raw.githubusercontent.com/typeparameter/dotfiles/main/install.sh | NONINTERACTIVE=1 bash
```

Non-interactive installs use the username from `id -un` and the current `$HOME` without configuring a Git identity.

## License

These dotfiles are licensed under the [MIT License](LICENSE), so others can build upon and tweak them as they see fit.


[Nix]: https://nixos.org/
[Home Manager]: https://github.com/nix-community/home-manager
