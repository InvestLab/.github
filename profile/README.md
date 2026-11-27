# InvestLab

InvestLab is a portfolio simulator for the Brazilian stock exchange (B3). You invest fictional cash and follow the result with real market data: quotes during trading hours, dividends, stock events, and the CDI and Ibovespa as benchmarks. A portfolio can also start on a past date. It is bought at that day's closing prices, and every dividend and stock event since then is replayed up to today. The simulator does not charge brokerage fees or taxes.

The project is also practice in running software the way a company does. Each service has its own repository, every change goes through a pull request with required checks, the infrastructure is written in Terraform, and deployments happen through GitOps.

## Status

Milestone 1 is in progress. Its goal is one small Java service that reaches a public HTTPS address on AWS through the full pipeline, from pull request to running container, with no manual deployment step.

## Repositories

| Repository | Purpose | Status |
|---|---|---|
| `.github` | Contribution rules, pull request template, shared workflows and the branch protection script | Active |
| `investlab-infra` | Terraform for AWS: network, k3s node, container registry, DNS and OIDC access for CI | Planned |
| `investlab-gitops` | Helm chart, environment values and Argo CD applications | Planned |
| `investlab-market-data` | Quotes, daily closes, dividends and corporate actions from B3 and other public sources | Planned |
| `investlab-portfolio` | Portfolios, orders and cash balances | Planned |
| `investlab-performance` | Returns, and comparison with the CDI, the Ibovespa and other portfolios | Planned |
| `investlab-web` | Web interface in Portuguese and English | Planned |

## Tech stack

- Services: Java and Spring Boot, Kafka between services, PostgreSQL with one database per service
- Web: React and TypeScript on S3 and CloudFront, sign-in with Amazon Cognito
- Platform: k3s on an EC2 Spot instance, Helm, Argo CD, Terraform, GitHub Actions with OIDC federation to AWS
- Observability: Grafana Cloud
