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

* Edit your new setup.home.sh and fill out the environment variable values.  Git will ignore this file.

* Start home-manager and configure to startup automatically in the future
```sh
nix shell nixpkgs#home-manager --command sh -c "./nix-home/start-home.sh"
```

* Restart your shell and you should get a [starship](https://starship.rs/) prompt with [Pure](https://starship.rs/presets/pure-preset#pure-preset) preset.
* Commands like `neofetch`, `jq`, `gh`, and `starship` should now be available.
* Run home-manager from your home directory to get rid of the warning of unread messages (from any directory):
```sh
home-manager news --flake ~/nix-home#afnix --impure
```

Setup of your home environment is now complete.

Additional notes:
* The `flake` flag in the previous command is needed to point home-manager to the location of flake.nix containing the afnix homeconfig, which points it to home.nix
* The `impure` flag is needed to ensure load of the environment variables for use by the nix files. 
* Review the home.nix file to see which software packages are installed.
* If you make changes to home.nix or flake.nix you can update your environment by running from any directory:
```sh
~/nix-home/start-home.sh
```
* Feel free to create your own branch of this repo to customize your environment and contribute enhancements back.