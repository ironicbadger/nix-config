# nix-macos-testing


## Getting started on a new Mac

Give full disk access to Terminal.

Install homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Install nix
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```


Clone the repo

```
git clone https://github.com/dsander/nix-testing
cd nix-testing
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install just
```

Clean the dock

```
defaults write com.apple.dock persistent-apps -array && killall Dock
```

Sync Thunderbird Profile

```
rsync -av --progress  --delete ~/Library/Thunderbird/ thorax.local:Library/Thunderbird/
```

Sublime
```
rsync -av --progress --delete  ~/Library/Application\ Support/Sublime\ Text/ thorax.local:"Library/Application\ Support/Sublime\ Text/"
```
Then delete Package (but User) and installed packages https://packagecontrol.io/docs/syncing
