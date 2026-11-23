<#
.SYNOPSIS
  Resets an Active Directory user's password and requires a change at next logon.

.DESCRIPTION
  Prompts for the new password as a SecureString so it is never typed on the
  command line or saved in PowerShell history. Requires the ActiveDirectory
  module (RSAT) and permission to reset passwords on the target account.

.EXAMPLE
  .\Reset-AD-Password.ps1 -Username jdoe
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$Username,

    [Parameter(Mandatory)]
    [SecureString]$NewPassword
)

Import-Module ActiveDirectory -ErrorAction Stop

try {
    if ($PSCmdlet.ShouldProcess($Username, 'Reset password and require change at logon')) {
        Set-ADAccountPassword -Identity $Username -NewPassword $NewPassword -Reset -ErrorAction Stop
        Set-ADUser -Identity $Username -ChangePasswordAtLogon $true -ErrorAction Stop
        Write-Host "Password reset for $Username. User must change it at next logon."
    }
}
catch {
    Write-Error "Failed to reset password for ${Username}: $_"
    exit 1
}
