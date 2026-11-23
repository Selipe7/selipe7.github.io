---
title: CCDC Tooling Reference
description: Auditing tools a blue team can run against its own hosts to find privilege-escalation and Active Directory attack paths.
---

# CCDC Tooling Reference

*WinPEAS · BloodHound Community Edition · Windows auditing · Active Directory*

Red teams use these tools to find ways to escalate privileges and move through a network. A defending team can run the same tools against **its own** systems to find and fix those paths first.

!!! warning "Authorized use only"
    Run these tools only on systems you own or are explicitly authorized to test, and follow your competition's rules on what software is allowed. Antivirus and EDR products usually flag them as hacking tools, so expect alerts.

!!! info "Why the binaries aren't hosted here"
    This site links to the official project releases instead of hosting copies. Downloading from upstream gets you the current version, and you can check it against the published release.

## WinPEAS

| Item | Value |
| --- | --- |
| What it does | Enumerates a Windows host for privilege-escalation risks: misconfigured services, weak file and registry permissions, stored credentials, unquoted service paths, and more |
| Project | PEASS-ng (Privilege Escalation Awesome Scripts Suite) |
| Official source | <https://github.com/peass-ng/PEASS-ng/releases> |
| Common file | `winPEASx64.exe` (also `winPEASany.exe`, `winPEASx86.exe`, `winPEAS.bat`) |

**Defensive use:** run it on each Windows server early in the competition, save the output, and work through the highlighted findings in order of severity.

## BloodHound CLI

| Item | Value |
| --- | --- |
| What it does | Installs and manages a local **BloodHound Community Edition** instance, which maps Active Directory relationships to show attack paths to privileged groups |
| Publisher | SpecterOps |
| Official source | <https://github.com/SpecterOps/bloodhound-cli/releases> |
| Common file | `bloodhound-cli-windows-amd64.zip` |
| Requires | Docker, plus a collector such as SharpHound to gather AD data |

**Defensive use:** collect AD data, then look for short paths to Domain Admins: excessive group memberships, dangerous ACLs, and sessions of privileged users on workstations. Remove or restrict those paths.

## Notes and lessons learned

!!! note "Needs content"
    Add competition-specific notes here, such as which findings mattered most and how long each tool took to run. Do not publish competition network details, credentials, or scoring information.

## References

1. PEASS-ng, "Releases." <https://github.com/peass-ng/PEASS-ng/releases>
2. SpecterOps, "bloodhound-cli." <https://github.com/SpecterOps/bloodhound-cli>
3. SpecterOps, "BloodHound Community Edition Quickstart." <https://bloodhound.specterops.io/get-started/quickstart/community-edition-quickstart>
