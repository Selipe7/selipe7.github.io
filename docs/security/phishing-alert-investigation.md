---
title: Phishing Alert Investigation
description: Triage of a user-reported phishing email, from header analysis to response recommendations.
---

# Phishing Alert Investigation

*Email header analysis · SPF / DKIM / DMARC · URL and domain reputation · Incident response*

!!! info "Scenario exercise"
    This is a **simulated investigation** using sample artifacts, not a production incident. Sender domains and IP addresses use reserved documentation values (`.example`, `203.0.113.0/24`) so no real organization or host is named. Screenshots from the original exercise are not published.

## Objective

An employee reported a suspicious email. Determine whether the message is malicious, what it was trying to do, and what the organization should do next.

## Environment

| Item | Value |
| --- | --- |
| Type | Simulated SOC triage exercise |
| Artifacts | Raw email headers (below) |
| Tools | Email header viewer, URL decoding, VirusTotal, OpenPhish |
| Date tested | Needs verification (exercise completed before this site existed) |

## Artifact: email headers

```text
Received: from mail.fakevendor.example (mail.fakevendor.example. [203.0.113.23])
Authentication-Results: dmarc=fail header.from=fakevendor.example
Return-Path: <accounts-update@fakevendor.example>
From: "Office 365 Admin" <admin@fakevendor.example>
To: victim@yourcompany.example
Subject: Action Required - Verify Your Account
Message-ID: <123456789@mail.fakevendor.example>
```

[Download the sample headers](../assets/samples/security/phishing-email-headers.txt)

## Procedure

1. Collected the full email headers from the reported message.
2. Compared the display name, `From`, `Return-Path`, and reply-to addresses.
3. Inspected links by hovering and decoding them without clicking.
4. Checked the sender and link domains against VirusTotal and OpenPhish.
5. Reviewed authentication results (SPF, DKIM, DMARC).

## Findings

- The display name impersonates **"Office 365 Admin"**, but the address belongs to an unrelated vendor-style domain.
- **DMARC failed** for the `From` domain, and there was no passing SPF or DKIM result.
- The link redirected to a **fake Microsoft 365 login page** built to harvest credentials.
- The subject line uses urgency ("Action Required") to push the user to act quickly.

**Verdict:** credential-phishing attempt.

## Response recommendations

- Block the sender domain and the phishing URL in the email gateway and web filter.
- Search mailboxes for other recipients of the same message and remove it.
- Confirm whether anyone entered credentials. If they did, reset the password, revoke sessions, and review sign-in logs.
- Thank the reporting user and reinforce the reporting process.

## MITRE ATT&CK mapping

| Technique | ID |
| --- | --- |
| Phishing: Spearphishing Link | T1566.002 |
| Impersonation | T1656 |

## What I learned

Header analysis is quick and decisive: the mismatch between display name, sending domain, and failed authentication told most of the story before any link was opened. Social engineering, not technical sophistication, does most of the work in phishing.

## References

1. MITRE ATT&CK, "Phishing: Spearphishing Link (T1566.002)." <https://attack.mitre.org/techniques/T1566/002/>
2. MITRE ATT&CK, "Impersonation (T1656)." <https://attack.mitre.org/techniques/T1656/>
