# Getting started

* Install Nix on WSL using [Determinate](https://docs.determinate.systems/) installer.
```sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

* Clone the nix-wsl-home repo to ~/nix-home

```sh
nix shell nixpkgs#home-manager --command sh -c "\
    git clone https://github.com/American-Forests/nix-wsl-home.git nix-home
    
"
```

* Create setup.home.sh from template:
```sh
cp setup.home.sh.template setup.home.sh
```

* Edit setup.home.sh and fill out the environment variable values.

* Start home-manager and configure to startup automatically in the future
```sh
nix shell nixpkgs#home-manager --command sh -c "\
    cd nix-home \
    && ./start-home.sh
"
```

* Finally, restart your shell and you should get a [starship](https://starship.rs/) prompt with [Pure](https://starship.rs/presets/pure-preset#pure-preset) preset.

Feel free to create your own branch of this repo to customize your environment and contribute enhancements back.