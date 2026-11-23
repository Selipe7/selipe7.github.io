---
title: Active Directory Password Reset Script
description: PowerShell script that resets an AD user's password securely and forces a change at next logon.
---

# Active Directory Password Reset Script

*PowerShell · Active Directory module · Help desk automation*

## Objective

Automate a common help desk task: reset a user's Active Directory password and require the user to choose a new one at next logon, without exposing the temporary password on the command line.

## Environment

| Item | Value |
| --- | --- |
| Platform | Windows with RSAT Active Directory module |
| Permissions | Delegated right to reset passwords on the target account |
| Date tested | Needs verification. This revision has not yet been re-tested in the lab. |

## Script

[Download Reset-AD-Password.ps1](../assets/scripts/Reset-AD-Password.ps1)

```powershell
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
```

## Usage

```powershell
# Preview the change without making it
.\Reset-AD-Password.ps1 -Username jdoe -WhatIf

# Run it. PowerShell prompts for NewPassword as a masked SecureString.
.\Reset-AD-Password.ps1 -Username jdoe
```

## Verification

```powershell
Get-ADUser jdoe -Properties PasswordLastSet, pwdLastSet |
    Select-Object SamAccountName, PasswordLastSet, pwdLastSet
```

`pwdLastSet` of `0` confirms that the user must change the password at next logon.

## Security notes

- The password is collected as a `SecureString`, so it never appears in the command line, console history, or process listings.
- Run it under an account that has only the delegated reset right, not Domain Admin.
- Password resets are recorded on domain controllers as Security event **4724** ("An attempt was made to reset an account's password"). Forward that event to your SIEM for an audit trail.

## What I learned

An earlier version of this script placed `Import-Module` before `param()`, which PowerShell does not allow in a script, and accepted the password as plain text. Fixing both showed how small script details affect whether automation is safe to hand to a help desk.

## References

1. Microsoft Learn, "Set-ADAccountPassword." <https://learn.microsoft.com/powershell/module/activedirectory/set-adaccountpassword>
2. Microsoft Learn, "4724(S, F): An attempt was made to reset an account's password." <https://learn.microsoft.com/windows/security/threat-protection/auditing/event-4724>
