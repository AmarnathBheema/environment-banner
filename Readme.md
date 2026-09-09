# Environment Banner — DevOps Take-Home Challenge

A simple environment banner application demonstrating Terraform, Docker, Kubernetes, Helm, and GitHub Actions.

The same application is deployed across environments with configuration-driven values such as `Dev` and `Prod`.

## Repository Structure

```text
.
├── terraform/
│   ├── modules/
│   │   ├── s3/
│   │   └── cloudfront/
│   ├── environments/
│   │   ├── dev.tfvars
│   │   └── prod.tfvars
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf
│
├
└── helm/
│     └── environment-banner/
│           ├── Chart.yaml
│           ├── values.yaml
│           └── templates/
│               ├── configmap.yaml
│               ├── deployment.yaml
│               └── service.yaml
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
└── README.md
    Dockerfile
    index.html
```

## Part 1 — Terraform

Provisions:

* Private S3 bucket
* CloudFront distribution with OAC
* Environment-specific static HTML
* Remote Terraform state

### Architecture

```text
Internet
   |
CloudFront
   |
  OAC
   |
Private S3
   |
index.html
```

### Commands

```bash
cd terraform

terraform fmt -check -recursive
terraform validate

terraform plan --var-file=./environments/dev.tfvars
terraform apply --var-file=./environments/dev.tfvars
```

For production:

```bash
terraform plan --var-file=./environments/prod.tfvars
terraform apply --var-file=./environments/prod.tfvars
```

CloudFront URL:

```text
https://<CLOUDFRONT-DOMAIN>
```

> The Terraform backend/state infrastructure is maintained separately and should not be destroyed with the application environment.

---

## Part 2 — Docker & Helm

The application uses nginx and accepts the environment at runtime through the `ENVIRONMENT` variable.

### Docker

Build:

```bash
docker build -t environment-banner:1.0 .
```

Run Dev:

```bash
docker run --rm \
  -e ENVIRONMENT=Dev \
  -p 8080:80 \
  environment-banner:1.0
```

Run Prod using the same image:

```bash
docker run --rm \
  -e ENVIRONMENT=Prod \
  -p 8080:80 \
  environment-banner:1.0
```

Verify:

```bash
curl http://localhost:8080
```

### Kubernetes / Helm

Create kind cluster:

```bash
kind create cluster --name environment-banner
```

Load image:

```bash
TMPDIR=/var/tmp/kind kind load docker-image \
  environment-banner:1.0 \
  --name environment-banner
```

Deploy Dev:

```bash
kubectl create namespace environment-banner

helm install environment-banner \
  ./helm/environment-banner \
  -n environment-banner \
  --set env=Dev
```

Access:

```bash
kubectl port-forward \
  svc/environment-banner 8080:80 \
  -n environment-banner
```

Test:

```bash
curl http://localhost:8080
```

Change to Prod:

```bash
helm upgrade environment-banner \
  ./helm/environment-banner \
  -n environment-banner \
  --set env=Prod
```

The same Docker image is reused; only the Helm configuration changes.

### Configuration Flow

```text
Helm values
    |
    v
ConfigMap
    |
    v
ENVIRONMENT variable
    |
    v
Docker startup
    |
    v
nginx / index.html
```

The Deployment includes resource requests/limits and an HTTP readiness probe.

---

## Part 3 — GitHub Actions

Workflow:

```text
.github/workflows/terraform.yml
```

Runs on:

* Pull requests
* Pushes to `main`

Pipeline performs:

```text
terraform init
       ↓
terraform fmt -check
       ↓
terraform validate
       ↓
terraform plan
```

AWS credentials are provided through GitHub repository secrets:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
```

No credentials are committed to the repository.

`terraform apply` is intentionally not executed by CI.

---

## Validation

### Terraform

```bash
terraform fmt -check -recursive
terraform validate
terraform plan
```

### Helm

```bash
helm lint ./helm/environment-banner
helm template environment-banner ./helm/environment-banner
```

## Cleanup

```bash
helm uninstall environment-banner -n environment-banner
kubectl delete namespace environment-banner
kind delete cluster --name environment-banner
```

Terraform resources:

```bash
cd terraform
terraform destroy --var-file=./environments/dev.tfvars
```
