# Getting started

First, install Nix on WSL using [Determinate](https://docs.determinate.systems/) installer.

Then, run the following command from your home directory to clone the nix-wsl-home repo to ~/nix-home

```sh
nix shell nixpkgs#home-manager nixpkgs#gh --command sh -c "\
    gh auth login \
    && gh repo clone American-Forests/nix-wsl-home -- nix-home --depth=1 \
    && home-manager switch --flake ./nix-home#afnix \
"
```