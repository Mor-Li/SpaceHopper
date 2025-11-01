# DesktopJumper

English | [简体中文](README_zh-CN.md)

**DesktopJumper** is a simple tool for macOS that allows users to quickly switch between different desktops. This project is particularly useful for scenarios where you need to switch between workspaces, such as moving from a development environment to a ChatGPT workspace and back.

## Usage Scenario

A common use case for DesktopJumper is during interactions with ChatGPT. For instance, when you have a question or need assistance, you can use a keyboard shortcut to jump to the desktop where ChatGPT is running. After getting the needed information, another shortcut brings you back to your original workspace.

## Installation

1. Ensure you have `yabai` and `jq` installed on your system.
2. Clone the repository to your local machine.
3. Add the following line to your `skhdrc` file to set up the keyboard shortcut:
   ```
   alt - space : zsh "~/GithubRepo/DesktopJumper/switch_space.sh"
   ```

## How It Works

The script defines keycodes for desktop switching and uses `yabai` and `osascript` to change the desktop. It saves the current desktop state, switches to the target desktop (e.g., desktop 3 for ChatGPT), and allows switching back to the previous desktop.

For introduction in Chinese, please visit the [中文README](./README_zh-CN.md).
