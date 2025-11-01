# YabaiSKHD Multi-Display Configuration Backup

LastSync:  2024-08-29

This repository serves as a backup for my multi-display configuration files on my MacBook. It includes configurations for Yabai, SKHD, and Zsh, tailored to handle different numbers of connected displays.

## Overview

To manage multiple monitors, I created separate configuration files for single, dual, and triple display setups. The key script in this setup is a Zsh function named `switch`, which automatically detects the number of connected monitors and loads the appropriate configuration.

### Configuration Files

- **.yabairc_single**: Configuration for a single display setup.
- **.yabairc_dual**: Configuration for dual display setups.
- **.yabairc_triple**: Configuration for triple display setups.
- **.skhdrc**: Contains shortcuts and hotkeys, including a keybinding to trigger the `switch` function.
- **.zshrc**: Includes the Zsh configuration and the `switch` function.

### Usage Example

For instance, if the current setup uses a single display and you connect additional monitors to switch to a triple display setup, macOS might automatically add extra spaces (desktops). Suppose you initially had 13 spaces configured for single display mode; upon connecting two more monitors, you might end up with 15 spaces.

In this scenario, you can manually remove the extra spaces on the primary display, reducing the total back to the desired configuration. After that, you can run the hotkey associated with the `switch` function. This function will then detect the new display setup and apply the appropriate configuration, ensuring that Yabai updates the window management across all displays accordingly.

### To-Do
Currently, the `.yabairc_dual` file has not been specifically configured for dual displays and is essentially a copy of the single display setup. Further adjustments will be made to tailor this configuration for dual display environments.

## License

This project is maintained for personal use and backup purposes. Feel free to use it as a reference for your multi-display setup.
