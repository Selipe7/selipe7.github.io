---
title: DNS Tunneling Packet Analysis
description: Using Wireshark to spot DNS tunneling and command-and-control patterns in captured traffic.
---

# DNS Tunneling Packet Analysis

*Wireshark · DNS · Threat intelligence lookups · Network forensics*

!!! info "Scenario exercise"
    This is a **simulated analysis** of a practice packet capture. The capture file and annotated screenshots from the original exercise are not published. The domain below uses a reserved `.example` name and is defanged.

## Objective

Analyze captured DNS traffic for signs of malicious activity such as DNS tunneling, command-and-control (C2) communication, or data exfiltration.

## Environment

| Item | Value |
| --- | --- |
| Type | Simulated network forensics exercise |
| Artifact | Practice capture `malicious_dns.pcap` (not published) |
| Tools | Wireshark, VirusTotal, AbuseIPDB, DNSViz, WHOIS |
| Date tested | Needs verification (exercise completed before this site existed) |

## Procedure

1. Opened the capture in Wireshark and applied the display filter:

    ```text
    dns
    ```

2. Sorted queries by name and looked for long, random-looking subdomains that repeated frequently.
3. Checked the queried domains against VirusTotal and AbuseIPDB, and looked up registration details with WHOIS.
4. Reviewed the timeline and volume of DNS traffic to the suspicious domain to see whether it fit an exfiltration pattern.

## Findings

- Frequent **TXT** record queries to `stealthy-data.securehost[.]example`.
- The subdomain labels contained **base64-encoded** strings, which is unusual for normal name resolution.
- Query volume and structure matched known DNS tunneling tools such as **iodine** and **dnscat2**.

**Verdict:** likely DNS tunneling used for C2 or data exfiltration.

## Response recommendations

- Block the suspicious domain at the DNS resolver.
- Log all outbound DNS queries centrally so they can be searched and alerted on.
- Alert on unusual TXT query volume and on very long or high-entropy subdomain labels.
- Force clients to use internal resolvers, and block direct outbound DNS (port 53) from endpoints.

## MITRE ATT&CK mapping

| Technique | ID |
| --- | --- |
| Application Layer Protocol: DNS | T1071.004 |
| Exfiltration Over Alternative Protocol | T1048 |

## What I learned

DNS is often allowed out of networks with little inspection, which makes it attractive for covert channels. Record type, label length, and query frequency are simple but strong signals.

## References

1. MITRE ATT&CK, "Application Layer Protocol: DNS (T1071.004)." <https://attack.mitre.org/techniques/T1071/004/>
2. MITRE ATT&CK, "Exfiltration Over Alternative Protocol (T1048)." <https://attack.mitre.org/techniques/T1048/>
