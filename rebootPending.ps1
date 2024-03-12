# Check for pending reboot on a local or remote computer
function Check-PendingReboot {
    [CmdletBinding()]
    param (
        [string]$ComputerName = $env:COMPUTERNAME
    )

    $rebootPending = $false
    $regPathCBS = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\"
    $regPathAU = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\"
    $regKeyCBS = "RebootPending"
    $regKeyAU = "RebootRequired"

    # Check Component Based Servicing and Windows Update registry keys for pending reboot flags
    if (Test-Path $regPathCBS) {
        $rebootPending = $rebootPending -or (Get-ItemProperty $regPathCBS -Name $regKeyCBS -ErrorAction SilentlyContinue)
    }
    if (Test-Path $regPathAU) {
        $rebootPending = $rebootPending -or (Get-ItemProperty $regPathAU -Name $regKeyAU -ErrorAction SilentlyContinue)
    }

    # Output the result
    [PSCustomObject]@{
        ComputerName   = $ComputerName.ToUpper()
        PendingReboot  = $rebootPending
    }
}

# Usage example:
# Check-PendingReboot -ComputerName "Server01"
