# platform policy
Run the workflow **Apply org policy** to enforce:
- Org default permission = none
- Org ruleset protecting default branch with CI + 1 review
- Optional per-repo label sync and branch protection

Example dispatch `repos_csv`: `eoin/ml-core,eoin/aws-iac`