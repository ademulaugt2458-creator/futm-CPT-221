 # Python Installation Guide

This folder contains `install_python.bat`, which installs Python 3.14.7 and the packages listed in `requirements.txt`.

## Requirements

- Windows 10 or later
- An active internet connection
- Administrator access
- `install_python.bat` and `requirements.txt` in the same folder

## Installation steps


1. Open the **Python Installation** folder.
2. Right-click `install_python.bat` and select **Run as administrator**.
3. Approve the Windows security prompt if displayed.
4. The script will:
	- Download the Python 3.14.7 64-bit installer to your Downloads folder.
	- Install Python for all users and add it to `PATH`.
	- Upgrade `pip`.
	- Install any missing packages from `requirements.txt`.
5. Wait until the message **All steps completed successfully** appears, then press a key to close the window.

## Verification

Open a new Command Prompt or PowerShell window and run:

```bat
python --version
python -m pip --version
```

To verify the packages, run:

```bat
python -m pip list
```

## Troubleshooting

- If the script says it must be run as Administrator, close it and use **Run as administrator**.
- If the download fails, check your internet connection and run the script again.
- If Python is not detected after installation, close and reopen Command Prompt or PowerShell, then run the script again.
- If package installation fails, check the error output and confirm that `requirements.txt` is present and correctly formatted.

The script can be run again safely; it skips Python and packages that are already installed where possible.
