---
title: Small Security Helper Scripts
description: Short PowerShell and Python scripts for AD password policy, IOC matching, and failed-login searches.
---

# Small Security Helper Scripts

*PowerShell · Python · Log triage*

Short, single-purpose scripts written while practicing blue-team automation. They are starting points, not finished tools: each one has hard-coded inputs that you edit before running.

!!! note "Testing status"
    Date tested: needs verification. These scripts were written before this site existed and have not been re-run for this page.

## Set the default domain password policy

[Download enforce-password-policy.ps1](../assets/scripts/enforce-password-policy.ps1)

Sets the **Default Domain Password Policy** directly with the Active Directory module (it does not create a Group Policy Object).

```powershell
Import-Module ActiveDirectory

$domain = (Get-ADDomain).DistinguishedName
Set-ADDefaultDomainPasswordPolicy -Identity $domain `
    -MinPasswordLength 12 `
    -ComplexityEnabled $true `
    -PasswordHistoryCount 24 `
    -MaxPasswordAge (New-TimeSpan -Days 90)
```

Check the result with `Get-ADDefaultDomainPasswordPolicy`.

!!! warning "Security note"
    Current NIST SP 800-63B guidance recommends against forcing periodic password changes unless there is evidence of compromise. Consider longer minimum lengths and a banned-password list instead of a 90-day maximum age.

## Match indicators of compromise in a log

[Download ioc-scanner.py](../assets/scripts/ioc-scanner.py)

Prints every line in `logs.txt` that contains one of the listed indicators (simple substring match).

```python
ioc_list = ["malicious.com", "192.168.13.37", "e3b0c44298fc"]
with open("logs.txt") as f:
    for line in f:
        if any(ioc in line for ioc in ioc_list):
            print("[MATCH] " + line.strip())
```

## Find failed logins in a log

[Download log-parser.py](../assets/scripts/log-parser.py)

Prints every line in `system.log` that matches `failed login`, ignoring case.

```python
import re

logfile = "system.log"
pattern = r"failed login"

with open(logfile, 'r') as f:
    for line in f:
        if re.search(pattern, line, re.IGNORECASE):
            print(line.strip())
```

## Possible improvements

- Read file paths and indicators from command-line arguments instead of hard-coding them.
- Load IOCs from a file and support regular expressions.
- Print a summary count of matches per indicator.

## References

1. Microsoft Learn, "Set-ADDefaultDomainPasswordPolicy." <https://learn.microsoft.com/powershell/module/activedirectory/set-addefaultdomainpasswordpolicy>
2. NIST, "SP 800-63B: Digital Identity Guidelines, Authentication and Lifecycle Management." <https://pages.nist.gov/800-63-4/sp800-63b.html>
