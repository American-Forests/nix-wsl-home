# Getting started

* Clone the nix-wsl-home repo to ~/nix-home

```sh
git clone https://github.com/American-Forests/nix-wsl-home.git nix-home
```

* Run the start script (this will prompt you to configure your personal settings):
```sh
nix shell nixpkgs#home-manager --command sh -c "./nix-home/start-home.sh"
```

* Open VSCode in Ubuntu and edit the `user-config.nix` file with your personal information:
```sh
cd nix-home
code .
```
* Run the start script again to apply your configuration:
```sh
nix shell nixpkgs#home-manager --command sh -c "./nix-home/start-home.sh"
```
* home-manager should now be started and available to your shell from now on
* Restart your shell and you should get a [starship](https://starship.rs/) prompt with [Pure](https://starship.rs/presets/pure-preset#pure-preset) preset.  It's a multi-line prompt where the first line displays your current directory in blue, and if your are within a git repository it will display your current branch in pink after that.
* Commands like `neofetch`, `jq`, `gh`, `awscli`, and `starship` should now be available.
* Run home-manager news to get rid of the warning of unread messages (from any directory):
```sh
home-manager news
```

Setup of your home environment is now complete.

Additional notes:
* Review the `home.nix` file to see which software packages are installed
* If you make changes to `home.nix` or `flake.nix` you can update your environment by running:
```sh
~/nix-home/start-home.sh
```
* Feel free to create your own branch of this repo to customize your environment and contribute enhancements back.
* When you ran the start-home script, the nix files in nix-home were symlinked to ~/.config/home-manager where home-manager looks for them and will load them automatically.
* You might wonder why user-config.nix is in the git repository and when you added your edits to it that git didn't reflect that there were changes.  The base user-config.nix file is in the repo because nix will ignore and not use any nix config files not in the git repository. And in order to keep personal info out of commits, local edits to this file are ignored by applying skip-worktree setting to user-config.nix by start-home.sh.  This means that if you want to alter the variables in user-config.nix, you would have to remove the skiptree setting temporarily, make changes and stage them, before adding the skiptree back.

## Learn More

Learn More
This Nix setup is derived from the following resources:
- https://www.youtube.com/watch?v=BMn_GWg2Ai0
- https://www.youtube.com/watch?v=hLxyENmWZSQ
- https://determinate.systems/blog/nix-direnv/

## Implementation Notes

This setup automatically creates symlinks from `~/.config/home-manager/` to the nix configuration files in `~/nix-home/`, allowing home-manager to find the configuration files in nix-home without needing to specify flake paths. The symlinks are created automatically when running `start-home.sh`.

The configuration is designed to work for multiple users - the flake automatically reads the username from `user-config.nix` and creates the appropriate home-manager configuration name dynamically.

More inspiration can be found at:
- https://yashgarg.dev/posts/nix-devenv/