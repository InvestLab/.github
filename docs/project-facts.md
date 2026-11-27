# Project facts

Values that every repository, workflow and Terraform module refers to. When one of them changes, update this file in the same pull request as the change.

| Fact | Value |
|---|---|
| GitHub organization | `InvestLab` |
| Domain | Not registered yet (first choice: `investlab.dev`) |
| Public API host | `api.<domain>` |
| AWS account | `investlab`; the account id is kept out of public files and stored in the organization variable `AWS_ACCOUNT_ID` |
| AWS region for workloads | `us-east-2` |
| AWS region for global services | `us-east-1` (IAM, Route 53, CloudFront and its ACM certificate) |
| Route 53 hosted zone id | Created when the domain is registered |
| Tag on every AWS resource | `project = investlab` |
| Container image platform | `linux/arm64` |
| Monthly cost budget | US$30 |
