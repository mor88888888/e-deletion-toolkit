# e-deletion-toolkit

Windows-focused offensive security toolkit designed for post-exploitation 
operations during authorized red team engagements and penetration tests.

## Modules

### 🔍 Discovery

Enumeration and indexing of filesystem artifacts on compromised Windows hosts.

| Script                    | Description                                                                                                                                            |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `listFolders.ps1`         | Recursive folder enumeration with path-length awareness. Output encrypted with AES-256.                                                                |
| `listFolders_short.ps1`   | Converts folder paths to short 8.3 format (e.g., `C:\PROGRA~1`). Useful for bypassing MAX_PATH limits or evading signature-based detection.            |
| `listFolders.vbs`         | Batch folder enumeration from encrypted input list. Uses `cmd /c dir /s /b` and exports to encrypted ZIP.                                              |
| `list_drives_indexed.ps1` | Queries Windows WMI to identify volumes with Search Index enabled. Outputs drive letters and indexed paths.                                            |
| `winindex-lookup.vbs`     | VBScript that queries the Windows Search Index for files matching configurable keywords. Results exported to CSV and optionally compressed with 7-Zip. |

### 🧹 Cleanup

Secure deletion and audit trail suppression for post-operation hygiene.

| Script                          | Description                                                                       |
| ------------------------------- | --------------------------------------------------------------------------------- |
| `multiple-sdelete.ps1`          | Recursive secure deletion using Sysinternals SDelete with audit policy disabling. |
| `multiple-sdelete-longpath.ps1` | Handles Windows MAX_PATH limitation by relocating folders before secure deletion. |

## Requirements

- Windows 10 / Server 2016+
- PowerShell 5.1+
- [Sysinternals SDelete](https://learn.microsoft.com/en-us/sysinternals/downloads/sdelete)
- [OpenSSL](https://www.openssl.org/)
- [7-Zip](https://www.7-zip.org/) (optional, for encrypted archives)

## Usage

Each script is self-contained. Edit the configuration section at the top 
of each file to define target paths and keywords.

### Running scripts directly

Powershell scripts can be executed as-is with PowerShell. First, ensure your execution policy permits script execution:

```powershell
# Check current policy
Get-ExecutionPolicy
# Temporary allow
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# Run the script
.\listFolders.ps1
```

VBS scripts with cscript as follows:

```shell
cscript //nologo listFolders.txt
```

### Compiling ps1 to executable (optional)

To bypass script execution restrictions or bundle dependencies, compile 
`.ps1` files to standalone executables using [PS2EXE](https://github.com/stefanstrawderm/ps2exe):

```powershell
# Install module first
Install-Module ps2exe -Scope CurrentUser
# Compile script
Invoke-ps2exe -InputFile .\listFolders.ps1 -OutputFile .\listFolders.exe
```

### Obsfuscation VBScript files (optional)

VBScript files in this repository can be obfuscated using [VBScript_Obfuscator](https://github.com/DoctorLai/VBScript_Obfuscator.git)
to reduce detection by signature-based security solutions:

```shell
# Clone the obfuscator
git clone https://github.com/DoctorLai/VBScript_Obfuscator.git

# Obfuscate a script
cscript //nologo VBScript_Obfuscator\vbs_obfuscator.vbs listFolders.vbs
```

### Decrypting outputs

Scripts encrypt their outputs using AES-256-CBC with OpenSSL. To decrypt:

```bash
openssl enc -aes-256-cbc -salt -a -in output.txt -k <key> -d -out output_decripted.txt
```

## ⚠️ Disclaimer

These tools are intended exclusively for authorized security assessments, 
red team engagements, and system administration on assets you own or ## License

This project is licensed under the MIT License. See the [`LICENSE`](LICENSE) file for details.
have explicit permission to test. Unauthorized use against systems you 
do not control may violate local and international laws.

The author is not responsible for misuse of these tools.
