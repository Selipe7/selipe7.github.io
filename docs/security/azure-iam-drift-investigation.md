---
title: Azure IAM Drift Investigation
description: Tracing an unapproved Contributor role assignment in Azure and remediating it.
---

# Azure IAM Drift Investigation

*Azure RBAC · Activity Log · Change control · Cloud security*

!!! info "Scenario exercise"
    This is a **simulated investigation** built around a mock Azure Activity Log record. It does not describe a real tenant or production environment. Screenshots from the original exercise are not published.

## Objective

Investigate a possible unauthorized privilege change in Azure by reviewing role assignments and audit logs, then remediate it.

## Environment

| Item | Value |
| --- | --- |
| Type | Simulated cloud security exercise |
| Artifact | Mock Activity Log record (below) |
| Tools | Azure Portal (Activity Log, Access Reviews), Azure CLI, Log Analytics, JSON viewer |
| Date tested | Needs verification (exercise completed before this site existed) |

## Artifact: Activity Log record

```json
{
  "records": [
    {
      "time": "2025-06-01T10:22:18Z",
      "operationName": "Add role assignment",
      "user": "alex.w",
      "role": "Contributor",
      "scope": "/subscriptions/xxx/resourceGroups/prod-rg",
      "status": "Success"
    }
  ]
}
```

[Download the sample record](../assets/samples/security/azure-activity-log-sample.json)

## Procedure

1. Pulled role-assignment events from the Activity Log and the related sign-in and audit records.
2. Identified a **Contributor** role granted to a low-privilege user on a production resource group.
3. Correlated the timestamp with the user's sign-in activity and the audit trail.
4. Checked the change-management system: **no approved change** matched the assignment.
5. Compared the user's effective permissions against the baseline IAM policy.

## Findings

User `alex.w` was granted **Contributor** on `prod-rg` without approval. Contributor can create, change, and delete resources in that scope, so the assignment exposed production data and services to accidental or malicious changes.

## Remediation

- Removed the unapproved role assignment.
- Enabled alerts on role-assignment changes.
- Recorded the incident and the fix in the change-management system.

## MITRE ATT&CK mapping

| Technique | ID |
| --- | --- |
| Account Manipulation: Additional Cloud Roles | T1098.003 |

## What I learned

One bad role assignment can quietly widen the blast radius of a compromised account. Alerting on role changes and tying every assignment to an approved change makes drift visible quickly.

## References

1. MITRE ATT&CK, "Account Manipulation: Additional Cloud Roles (T1098.003)." <https://attack.mitre.org/techniques/T1098/003/>
2. Microsoft Learn, "Azure built-in roles." <https://learn.microsoft.com/azure/role-based-access-control/built-in-roles>
