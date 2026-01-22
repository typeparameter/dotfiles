# dotfiles

These are my personal dotfiles that I use to configure all my computers for development. I use [`yadm`][yadm] to manage these dotfiles and bootstrap my environment. I mainly use macOS and Linux for development, and I have not tested these dotfiles on Windows (although they _should_ work with WSL2).


## Installation

If you don't have `yadm` installed (e.g., on a clean install), then you can run this one-liner to install these dotfiles:

```bash
curl -fsSL https://github.com/TheLocehiliosan/yadm/raw/master/yadm | /bin/bash -s -- clone https://github.com/typeparameter/dotfiles
```

This command grabs a working copy of `yadm` from GitHub for the sole purpose of cloning and bootstrapping the dotfiles. Of course, you should always verify the safety of a script before "curl-piping" it, so if you don't trust me or the author, verify it yourself.

If you don't want to run this command for one reason or another, but still feel comfortable using `yadm`, ~~reconsider your thought process~~ you can [install `yadm`][install-yadm] and then clone the dotfiles:

```bash
yadm clone https://github.com/typeparameter/dotfiles
```


## Bootstrapping

After cloning the dotfiles, you will be asked if you want to execute the bootstrap program. This [bootstrap program][bootstrap] executes all the scripts in the [bootstrap.d][bootstrap-d] directory. These scripts help set up the environment so that you can get up and running quickly. Among other things, these scripts do the following:

- Set the user's shell to [`zsh`][zsh]
- Clones [oh-my-zsh][oh-my-zsh]
- Installs [Homebrew][homebrew]
- Installs formulae and casks from Homebrew using my [Brewfiles][brewfiles]
  - This includes the [starship][starship] prompt
- Generates an SSH key at `~/.ssh/id_ed25519`

These bootstrapping scripts are idempotent, so you can re-run the bootstrapping step if need be:

```bash
yadm bootstrap
```


## Contributing

These are _my_ dotfiles, so I probably will not accept any pull requests or issues. However, if you don't like something, feel free to [fork][fork-me] this repo and do it your own way.


## License

These dotfiles are licensed under the [MIT License](LICENSE) so that others can build off them and tweak things as they see fit.


[yadm]: https://github.com/TheLocehiliosan/yadm
[install-yadm]: https://yadm.io/docs/install
[bootstrap]: .config/yadm/bootstrap
[bootstrap-d]: .config/yadm/bootstrap.d
[zsh]: https://www.zsh.org
[oh-my-zsh]: https://github.com/ohmyzsh/ohmyzsh
[homebrew]: https://brew.sh
[brewfiles]: .config/brew
[starship]: https://starship.rs
[fork-me]: https://github.com/typeparameter/dotfiles/fork
