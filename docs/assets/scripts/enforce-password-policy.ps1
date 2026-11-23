# Enforce Password Policy
Import-Module ActiveDirectory

$domain = (Get-ADDomain).DistinguishedName
Set-ADDefaultDomainPasswordPolicy -Identity $domain `
    -MinPasswordLength 12 `
    -ComplexityEnabled $true `
    -PasswordHistoryCount 24 `
    -MaxPasswordAge (New-TimeSpan -Days 90)
