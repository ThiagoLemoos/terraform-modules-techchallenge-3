# Terraform Modules - Tech Challenge 3

Infraestrutura AWS provisionada com Terraform usando arquitetura modular, com execução por ambiente (`hml` e `prod`).

Principais componentes:
- **Network (VPC)**
- **EKS Cluster + Managed Node Group**
- **ECR** (repositórios para os serviços)
- **Databases** (RDS Postgres + DynamoDB + ElastiCache)
- **SQS** (módulo `resources`)
- **Kubernetes** (namespaces e secrets)

## Estrutura do repositório

```
.
├── .github/workflows/                 # Pipelines (GitHub Actions)
├── bootstrap/                         # Criação do bucket S3 do backend
│   └── main.tf
├── environments/
│   ├── hml/
│   │   ├── backend.tf                 # Backend S3 (state remoto)
│   │   ├── providers.tf
│   │   ├── modules.tf                 # Instancia módulos
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── backend.tf
│       ├── providers.tf
│       ├── modules.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
├── modules/
│   ├── network/                       # VPC/Subnets/NAT/Tags EKS
│   ├── eks-cluster/                    # EKS + node groups + access entries
│   ├── ecr/                            # Repositórios ECR (terraform-aws-modules/ecr)
│   ├── databases/                      # RDS + DynamoDB + ElastiCache
│   ├── resources/                      # SQS
│   └── kubernetes/                     # Namespaces e secrets no cluster
├── jobs/                               # Jobs Kubernetes (ex.: init_sql)
├── CD/                                 # Manifests/kustomize/ArgoCD
├── academy.tfvars.example
└── README.md
```

## Backend (state remoto)

Este projeto usa backend **S3**.

- **Bucket**: `terraform-state-techchallenge-equipe7`
- **Keys**:
  - `techchallenge3/hml/terraform.tfstate`
  - `techchallenge3/prod/terraform.tfstate`

O bucket é criado via `bootstrap/main.tf`.

## Pré-requisitos

- Terraform `>= 1.5.0`
- AWS CLI v2
- `kubectl`
- Acesso à AWS (no caso de AWS Academy, geralmente via role `voclabs`/`LabRole`)

## Como executar (Windows / PowerShell)

### 1) Criar/garantir o bucket do backend (bootstrap)

Execute dentro de `bootstrap/`:

```bash
terraform init
terraform apply
```

### 2) Inicializar e aplicar um ambiente

Exemplo em `environments/prod` (mesma lógica para `hml`):

```bash
terraform init
terraform apply --var-file=terraform.tfvars
```

Se você alterou `backend.tf` (bucket/key/region), rode:

```bash
terraform init -reconfigure
```

## Kubernetes / EKS

Após o `terraform apply` do ambiente, atualize o `kubeconfig`:

```bash
aws eks update-kubeconfig --name <EKS_CLUSTER_NAME> --region us-east-1
kubectl get nodes
kubectl get namespaces
```

Observação: o repositório já usa `eks_access_entries` para conceder acesso ao cluster (incluindo permissões para criação de namespaces, quando aplicável).

## CI/CD e manifests

- **GitHub Actions**: confira `.github/workflows/` para os pipelines de `init`/`apply`.
- **CD/**: contém manifests e/ou estrutura de entrega contínua (ex.: kustomize/Argo CD).
- **jobs/**: jobs Kubernetes auxiliares (ex.: `init_sql`).

## Módulos

- **`modules/network`**
  - VPC, subnets públicas/privadas, NAT Gateway, IGW, rotas e tags para EKS.
- **`modules/eks-cluster`**
  - Cluster EKS, launch template, node group e configuração de acesso (EKS Access Entries/Policy Associations).
- **`modules/ecr`**
  - Repositórios ECR por serviço (ex.: `auth-service`, `flag-service`, etc.).
- **`modules/databases`**
  - RDS (PostgreSQL), DynamoDB e ElastiCache.
- **`modules/resources`**
  - SQS (fila principal + DLQ).
- **`modules/kubernetes`**
  - Namespaces e secrets no cluster.

## Arquitetura (visão geral)

```mermaid
flowchart TB
  dev[Operador/CI
  Terraform + AWS CLI + kubectl] --> env[environments/hml ou environments/prod]

  env -->|terraform init/apply| tf[Terraform]

  tf -->|state| s3[(S3 Backend
  terraform-state-techchallenge-equipe7)]

  tf --> net[modules/network
  VPC + Subnets + NAT/IGW + Routes]

  tf --> eks[modules/eks-cluster
  EKS Cluster + Node Group
  EKS Access Entries]

  tf --> ecr[modules/ecr
  ECR repos por serviço]

  tf --> db[modules/databases]
  db --> rds[(RDS PostgreSQL)]
  db --> ddb[(DynamoDB)]
  db --> redis[(ElastiCache/Redis)]

  tf --> sqs[modules/resources
  SQS + DLQ]

  tf --> k8s[modules/kubernetes
  Namespaces + Secrets]
  k8s -->|usa endpoint/CA/token| eks

  net --> eks
  net --> db
  net --> sqs
