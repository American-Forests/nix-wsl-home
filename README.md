# Getting started

## Initial Setup

* Clone the nix-wsl-home repo to ~/nix-home

```sh
git clone https://github.com/American-Forests/nix-wsl-home.git nix-home
```

* Open VSCode in Ubuntu and edit the `user-config.nix` file with your personal information:
```sh
cd nix-home
code .
```

* Try loading your home environment (this will prompt you to configure if not done):
```sh
nix shell nixpkgs#home-manager --command sh -c "./nix-home/load-home.sh"
```

## Choose Your Usage Mode

After initial setup, you have three options for using your home environment:

### Option 1: Manual Loading (Default)
Load the environment only when you need it:
```sh
cd ~/nix-home
./load-home.sh
```
This starts a new shell session with home-manager active. Type `exit` to return to your normal shell.

### Option 2: Enable Automatic Loading
Make home-manager load automatically in all new shell sessions:
```sh
cd ~/nix-home
./enable-home-auto.sh
```
After this, restart your shell and you should get a [starship](https://starship.rs/) prompt with [Pure](https://starship.rs/presets/pure-preset#pure-preset) preset. Commands like `neofetch`, `jq`, `gh`, `awscli`, and `starship` will be available in all shell sessions.

### Option 3: Disable Automatic Loading
If you previously enabled automatic loading and want to return to manual mode:
```sh
cd ~/nix-home
./disable-home-auto.sh
```

* Run home-manager news to get rid of the warning of unread messages (from any directory):
```sh
home-manager news
```

## Additional Notes

### Managing Your Environment
* Review the `home.nix` file to see which software packages are installed
* If you make changes to `home.nix` or `flake.nix`, apply them by loading the environment again:
```sh
cd ~/nix-home
./load-home.sh
```
* Feel free to create your own branch of this repo to customize your environment and contribute enhancements back.

### Script Reference
* `load-home.sh` - Load environment for current session (handles initial setup automatically)
* `enable-home-auto.sh` - Enable automatic loading on shell startup
* `disable-home-auto.sh` - Disable automatic loading

### How It Works
* **Manual mode**: Home environment is only active when you explicitly load it with `load-home.sh`
* **Auto mode**: When enabled, nix files in nix-home are symlinked to `~/.config/home-manager/` where home-manager automatically discovers them
* The `user-config.nix` file contains your personal settings and has skip-worktree enabled to prevent accidental commits of personal information

## Learn More

Learn More
This Nix setup is derived from the following resources:
- https://www.youtube.com/watch?v=BMn_GWg2Ai0
- https://www.youtube.com/watch?v=hLxyENmWZSQ
- https://determinate.systems/blog/nix-direnv/

## Implementation Notes

This setup provides flexible control over when home-manager is active:

* **Non-persistent by default**: The initial setup does not automatically load home-manager in future shell sessions
* **Symlink-based auto-loading**: When auto-loading is enabled, symlinks are created from `~/.config/home-manager/` to the nix configuration files in `~/nix-home/`
* **Manual loading option**: Users can temporarily activate the environment without persistence using the load script
* **Multi-user support**: The flake automatically reads the username from `user-config.nix` and creates the appropriate home-manager configuration name dynamically

More inspiration can be found at:
- https://yashgarg.dev/posts/nix-devenv/