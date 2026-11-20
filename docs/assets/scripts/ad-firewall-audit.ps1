#requires -Version 5.1
<#[
.SYNOPSIS
  Read-only audit of application-aware Active Directory firewall rules.
.DESCRIPTION
  Exports *existing* Windows Firewall rules that match a chosen name prefix.
  Makes no configuration changes. Run on an authorized Windows Server with
  the NetSecurity PowerShell module. Treat output as configuration-sensitive.
.EXAMPLE
  .\ad-firewall-audit.ps1 -NamePrefix 'LAB-AD-' -OutputCsv 'C:\Temp\lab-ad-rules.csv'
#>
[CmdletBinding()]
param(
    [string]$NamePrefix = 'LAB-AD-',
    [string]$OutputCsv = (Join-Path $env:TEMP 'ad-firewall-audit.csv')
)

$ErrorActionPreference = 'Stop'
Import-Module NetSecurity -ErrorAction Stop
$rules = @(Get-NetFirewallRule -PolicyStore ActiveStore |
    Where-Object { $_.Name -like "$NamePrefix*" })

$inventory = foreach ($r in $rules) {
    $port    = $r | Get-NetFirewallPortFilter
    $app     = $r | Get-NetFirewallApplicationFilter
    $service = $r | Get-NetFirewallServiceFilter
    $address = $r | Get-NetFirewallAddressFilter

    [PSCustomObject]@{
        Name          = $r.Name
        DisplayName   = $r.DisplayName
        Enabled       = $r.Enabled
        Direction     = $r.Direction
        Action        = $r.Action
        Profile       = $r.Profile
        Protocol      = $port.Protocol
        LocalPort     = ($port.LocalPort -join ',')
        RemotePort    = ($port.RemotePort -join ',')
        Program       = $app.Program
        Service       = $service.Service
        RemoteAddress = ($address.RemoteAddress -join ',')
    }
}

$targetDirectory = Split-Path -Parent $OutputCsv
if ($targetDirectory -and -not (Test-Path -LiteralPath $targetDirectory)) {
    New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
}
$inventory | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8
Write-Host "Exported $($inventory.Count) matching rules to $OutputCsv"
$inventory | Format-Table DisplayName,Protocol,LocalPort,Program,Service -AutoSize

Write-Host 'Firewall profile defaults:'
Get-NetFirewallProfile |
    Select-Object Name,Enabled,DefaultInboundAction,DefaultOutboundAction |
    Format-Table -AutoSize
