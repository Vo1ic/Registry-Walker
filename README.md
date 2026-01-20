# Registry Walker 🕵️‍♂️

**Registry Walker** is a lightweight, interactive Command Line Interface (CLI) tool for navigating and analyzing the Windows Registry. It allows you to explore registry keys like folders and view values in a clean, readable table format.

Think of it as a **Terminal-based RegEdit** with smart data parsing.

## 🚀 Features

* **Interactive Shell:** Navigate the registry using familiar commands (`cd`, `ls`, `back`).
* **Smart Value Parsing:** Automatically detects and formats data types:
    * `REG_BINARY` → Formatted HEX view (e.g., `0A 1F FF`).
    * `REG_DWORD` → Standard numbers.
    * `REG_MULTI_SZ` → Comma-separated lists.
* **Clean UI:** Displays keys and values in organized, auto-sized tables.
* **Auto-Elevation:** Automatically requests Administrator privileges to ensure access to system keys.
* **Safe:** Designed primarily for **reading** and forensic exploration.

## 📦 Installation & Usage

This tool consists of two files that work together.

1.  Download **both** files to the same folder:
    * `Run_Walker.cmd` (The Launcher)
    * `Registry-Walker.ps1` (The Logic)
2.  Double-click **`Run_Walker.cmd`** to start.
3.  Accept the UAC (Admin) prompt.

> **Note:** Do not run the `.ps1` file directly unless you manually launch PowerShell as Administrator.

## 🎮 Commands

| Command | Description |
| :--- | :--- |
| `ls` / `dir` | List sub-keys (folders) in the current path. |
| `cd <name>` | Go inside a specific folder/key. |
| `back` / `..` | Go up one level to the parent key. |
| `read` | **(Main Feature)** Read & Analyze all values in the current key. |
| `root` | Jump immediately back to the root (`HKLM:\SOFTWARE`). |
| `cls` | Clear the screen. |
| `exit` | Close the program. |

## 📸 Example

```text
[HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion] > read

Value Name      Type      Data
----------      ----      ----
ProductName     REG_SZ    Windows 10 Pro
CurrentBuild    REG_SZ    19045
InstallDate     REG_DWORD 1675843200
