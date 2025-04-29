# dotfiles

Platform specific dotfile configurations by way of [chezmoi](https://chezmoi.io)

## Quickstart

### :warning: Please be aware that running the command below will trigger a script which installs platform specific binaries. Be sure you have the appropriate permissions and proceed at your own risk. You can analyze this script in the `/bin` folder for the relevant operating systems.

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply chrislcrain
```

## MacOS Requirements

- `git`
- `homebrew`
- `chezmoi`
- `zsh`

_The recommended terminal editor for this configuration is [WezTerm](https://wezterm.org/) but you may use your preferred editor as well. If you do choose to use another terminal please be aware that you will be responsible for setting up your own multiplexer keybinds and you will need to ignore the file at `/dot_config/wezterm`_

## Ubuntu Requirements

_Under Construction_
