# Dotfiles

Setting up my Mac with some software that I like.

## Install Prerequisites

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Run

```sh
./install.sh
```

### Manual Steps:
- iTerm2 preferences: General > Preferences > Load preferences from a custom folder or URL > ./config/iterm2

## After updating

```sh
# Short for nix run nix-darwin -- switch --flake ~/dotfiles/
up
```

## Inspiration

- https://github.com/OliverJAsh/dotfiles
