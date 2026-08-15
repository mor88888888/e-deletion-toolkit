# e-deletion-toolkit
Windows-focused offensive security toolkit designed for post-exploitation 
operations during authorized red team engagements and penetration tests.

## Modules

### 🔍 Discovery
Enumeration and indexing of filesystem artifacts on compromised Windows hosts.

| Script | Description |
|--------|-------------|
| `listFolders.ps1` | Recursive folder enumeration with path-length awareness. Output encrypted with AES-256. |
| `winindex-lookup.txt` | VBScript that queries the Windows Search Index for files matching configurable keywords. Results exported to CSV and optionally compressed with 7-Zip. |

### 🧹 Cleanup
Secure deletion and audit trail suppression for post-operation hygiene.

| Script | Description |
|--------|-------------|
| `multiple-sdelete.ps1` | Recursive secure deletion using Sysinternals SDelete with audit policy disabling. |
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

## ⚠️ Disclaimer

These tools are intended exclusively for authorized security assessments, 
red team engagements, and system administration on assets you own or ## License

This project is licensed under the MIT License. See the [`LICENSE`](LICENSE) file for details.
have explicit permission to test. Unauthorized use against systems you 
do not control may violate local and international laws.

The author is not responsible for misuse of these tools.
