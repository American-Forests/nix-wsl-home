# Getting started

* Install Nix on WSL using [Determinate](https://docs.determinate.systems/) installer.
```sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

* Clone the nix-wsl-home repo to ~/nix-home

```sh
nix shell nixpkgs#home-manager --command git clone https://github.com/American-Forests/nix-wsl-home.git nix-home
```

* Run the start script (this will prompt you to configure your personal settings):
```sh
~/nix-home/start-home.sh
```

* Edit the `user-config.nix` file with your personal information:
* Run the start script again to apply your configuration:
```sh
~/nix-home/start-home.sh
```

* Restart your shell and you should get a [starship](https://starship.rs/) prompt with [Pure](https://starship.rs/presets/pure-preset#pure-preset) preset.
* Commands like `neofetch`, `jq`, `gh`, `awscli`, and `starship` should now be available.
* Run home-manager from your home directory to get rid of the warning of unread messages (from any directory):
```sh
home-manager news --flake ~/nix-home#afnix
```

Setup of your home environment is now complete.

Additional notes:
* Review the `home.nix` file to see which software packages are installed
* If you make changes to `home.nix` or `flake.nix` you can update your environment by running:
```sh
~/nix-home/start-home.sh
```
* Feel free to create your own branch of this repo to customize your environment and contribute enhancements back.
* nix will only see its config files if they are added to the git repository.  For this reason, user-config.nix was added to the git repo.  In order to keep personal info out of commits, local edits to this file are ignored by applying skip-worktree setting to user-config.nix by start-home.sh.  This means that if you want to alter the base user variables, you would have to remove the skiptree setting temporarily, make changes and stage them, before adding the skiptree back.

## Learn More

Learn More
This Nix setup is derived from the following resources:
- https://www.youtube.com/watch?v=BMn_GWg2Ai0
- https://www.youtube.com/watch?v=hLxyENmWZSQ
- https://determinate.systems/blog/nix-direnv/

## Future

A simpler setup may be possible where nix files in nix-home are automatically found by symlinking them to ~/.config/home-manager where home-manager looks by default.  A different method for loading user-specific configuration may also be found instead of using environment variables.  More inspiration can be found at:
- https://yashgarg.dev/posts/nix-devenv/