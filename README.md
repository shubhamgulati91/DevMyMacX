# DevMyMacX

Watch it in action - [This is DevMyMacX](https://youtu.be/F-dSk_fuaSQ)

&nbsp;

## Initialize setup

1. Install XCode CLI Tools

   ```sh
   xcode-select --install &>/dev/null
   ```

2. Launch setup

   ```sh
   sh -c "$(curl -fsSL https://github.com/shubhamgulati91/DevMyMacX/raw/dev/bootstrap.sh)" "" --initialize --manual --lean
   ```

&nbsp;

## Refresh Setup

```sh
sh -c "$(curl -fsSL https://github.com/shubhamgulati91/DevMyMacX/raw/dev/bootstrap.sh)" "" --update --automatic --express
```

&nbsp;

## Usage documentation

1. Usage

   ```sh
   bootstrap.sh --arg1 --arg2 --arg3
   ```

   &nbsp;

2. Supported args:

   ```sh
   arg #1:
      --initialize / --update
      -i / -u
   ```

   ```sh
   --initialize
      runs initialize script on newly installed macOS or if running DevMyMacX for the first time

   --update
      runs updater script to refresh setup installed by initializer script and to install new software bundles from chosen Brewfiles
   ```

   &nbsp;

   ```sh
   arg #2:
      --manual / --automatic
      -m / -a
   ```

   ```sh
   --manual
      runs script in manual mode to let user choose setup parameters [recommended for initializing setup]

   --automatic
      runs script in auto mode with default setup parameters [recommended for updating setup]
   ```

   ```note
   NOTE: Do not run initializer in auto mode unless you have modified defaults by editing the initializer script
   ```

   &nbsp;

   ```sh
   arg #3:
      --lean / --express / --full
      -l / -e / -f
   ```

   ```sh
   --lean
      installs essential software bundle

   --express
      installs essential & development software bundle

   --full
      installs essential, development & ms-office software bundle
   ```

   &nbsp;

3. Customize Brewfiles

   To customize Brewfiles before running installer/updater, fork dotfiles repository and provide custom path during manual setup.

   [Dotfiles repository](https://github.com/shubhamgulati91/dotfiles) - <https://github.com/shubhamgulati91/dotfiles>

   [Default Brewfiles source url](https://github.com/shubhamgulati91/dotfiles/tree/main/macOS/homebrew) - <https://github.com/shubhamgulati91/dotfiles/raw/main/macOS/homebrew>

   &nbsp;

4. Brewfiles

   [Brewfile-Mac-App-Store-Bundle](https://github.com/shubhamgulati91/dotfiles/blob/main/macOS/homebrew/Brewfile-Mac-App-Store-Bundle)

   [Brewfile-Essential-Bundle](https://github.com/shubhamgulati91/dotfiles/blob/main/macOS/homebrew/Brewfile-Essential-Bundle)

   [Brewfile-Developer-Bundle](https://github.com/shubhamgulati91/dotfiles/blob/main/macOS/homebrew/Brewfile-Developer-Bundle)

   [Brewfile-MS-Office-Bundle](https://github.com/shubhamgulati91/dotfiles/blob/main/macOS/homebrew/Brewfile-MS-Office-Bundle)
