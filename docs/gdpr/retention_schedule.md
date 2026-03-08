# Retention schedule

This is the working retention policy draft and must be converted into automated enforcement before production use.

| Record type | Proposed retention rule | Current automation status |
|---|---|---|
| clients | retain while active customer relationship exists; archive on closure | not automated |
| dogs | retain while active service relationship exists | not automated |
| walkers | retain while engagement and compliance needs exist | not automated |
| walks / reports | retain for operational history and dispute handling | not automated |
| invoice headers / lines | retain per financial recordkeeping obligations | not automated |
| attachments | minimise; delete when no longer needed for the linked purpose | not automated |
| audit_log | retain according to security and accountability needs | not automated |

## Engineering rule

Any new feature that stores personal data must update this file and the Fides dataset manifest in the same PR.
