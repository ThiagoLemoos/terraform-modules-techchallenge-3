# Terraform Modules Tech Challenge 3

Este projeto contém uma infraestrutura completa na AWS provisionada com Terraform, utilizando uma arquitetura modular para provisionar VPC, cluster EKS e banco de dados RDS.

## 📁 Estrutura do Projeto

```
.
├── backend.tf              # Configuração do backend S3 para estado remoto
├── providers.tf            # Configuração de providers e versões
├── variables.tf            # Variáveis de entrada do projeto
├── modules.tf              # Instanciação dos módulos
├── outputs.tf              # Saídas do projeto
├── .gitignore              # Arquivos ignorados pelo Git
├── environments/           # Configurações por ambiente
│   ├── dev/               # Ambiente de desenvolvimento
│   ├── staging/           # Ambiente de staging
│   └── prod/              # Ambiente de produção
│       └── prod.hcl       # Configuração do backend para produção
├── modules/               # Módulos Terraform
│   ├── network/           # Módulo de rede (VPC)
│   │   ├── vpc.tf         # Configuração da VPC
│   │   ├── variables.tf   # Variáveis do módulo
│   │   └── outputs.tf     # Saídas do módulo
│   ├── databases/         # Módulo de banco de dados
│   │   ├── rds.tf         # Configuração RDS
│   │   ├── variables.tf   # Variáveis do módulo
│   │   └── outputs.tf     # Saídas do módulo
│   └── eks-cluster/       # Módulo do cluster EKS
│       ├── eks.tf         # Configuração do EKS
│       ├── variables.tf   # Variáveis do módulo
│       └── outputs.tf     # Saídas do módulo
└── assets/                # Arquivos estáticos
```

## 🏗️ Arquitetura

### Módulo de Rede (`modules/network`)
- **VPC**: Cria uma Virtual Private Cloud com CIDR configurável
- **Subnets**: 
  - 3 subnets públicas para load balancers
  - 3 subnets privadas para recursos internos
- **NAT Gateway**: Gateway NAT para saída de internet das subnets privadas
- **Internet Gateway**: Gateway de internet para subnets públicas
- **Route Tables**: Tabelas de roteamento configuradas
- **Tags Kubernetes**: Subnets marcadas para uso com EKS

**Recursos provisionados:**
- VPC principal
- Internet Gateway
- NAT Gateway (single)
- 3 Public Subnets
- 3 Private Subnets
- Route Tables associadas

### Módulo de Banco de Dados (`modules/databases`)
- **RDS**: Banco de dados MySQL 8.0
- **Configurações de segurança**: Grupos de segurança e criptografia
- **Backup e monitoring**: Configurações de backup e monitoring automatizados

**Recursos RDS:**
- Engine: MySQL 8.0
- Instance: db.t3a.large
- Storage: 5GB
- Monitoring habilitado
- Backup automático

### Módulo EKS (`modules/eks-cluster`)
- **Cluster EKS**: Kubernetes gerenciado pela AWS
- **Node Groups**: Grupos de nós gerenciados
- **Addons**: Addons essenciais do Kubernetes
- **Segurança**: Configurações de segurança e acesso

**Recursos provisionados:**
- Cluster EKS versão 1.34
- Node groups com instâncias A1
- Addons: VPC CNI, CoreDNS, kube-proxy
- IRSA habilitado
- Endpoint privado apenas

## 🔧 Configuração

### Pré-requisitos
- Terraform >= 1.5.0
- AWS CLI configurado
- Permissões adequadas na AWS

### Variáveis Principais

| Variável | Descrição | Default |
|----------|-----------|---------|
| `aws_region` | Região AWS | `us-east-1` |
| `project_name` | Nome do projeto | `techchallenge` |
| `cidr_block` | CIDR da VPC | `10.0.0.0/16` |
| `cluster_name` | Nome do cluster EKS | `core-eks` |
| `kubernetes_version` | Versão do Kubernetes | `1.34` |

### Tags Padrão
Todos os recursos são marcados com as seguintes tags:
```hcl
{
  team       = "Devops"
  project    = "env-techchallenge"
  environment = "Prod"
  managedBy  = "Terraform"
}
```

## 🚀 Deploy

### 1. Clonar o repositório
```bash
git clone <repository-url>
cd terraform-modules-techchallenge-3
```

### 2. Configurar variáveis
Copie e edite o arquivo `terraform.tfvars`:
```bash
cp terraform.tfvars.example terraform.tfvars
# Edite as variáveis conforme necessário
```

### 3. Inicializar o Terraform
```bash
terraform init
```

### 4. Planejar o deploy
```bash
terraform plan
```

### 5. Aplicar as mudanças
```bash
terraform apply
```

## 🌍 Ambientes

O projeto suporta múltiplos ambientes através da pasta `environments/`:

### Produção
- Backend S3: `prod-techchallenge-terraform-state-us-east-1`
- Configuração em `environments/prod/prod.hcl`

### Desenvolvimento e Staging
- Estrutura similar ao ambiente de produção
- Configurações específicas para cada ambiente

## 📊 Saídas

O projeto exporta as seguintes saídas principais:

### Rede
- `vpc_id`: ID da VPC
- `vpc_cidr_block`: Bloco CIDR da VPC
- `public_subnets`: IDs das subnets públicas
- `private_subnets`: IDs das subnets privadas

### Banco de Dados
- `rds_instance_endpoint`: Endpoint da instância RDS
- `rds_instance_id`: ID da instância RDS

## 🔐 Segurança

### Configurações de Segurança Implementadas:
- **VPC**: Isolamento de rede com subnets privadas
- **Security Groups**: Grupos de segurança configurados
- **IAM**: Roles e políticas de acesso configuradas
- **Encryption**: Criptografia em repouso e em trânsito
- **TLS**: TLS habilitado para conexões de banco de dados
- **Private Endpoints**: Endpoints privados para serviços críticos

### Controle de Acesso:
- IRSA (IAM Roles for Service Accounts) habilitado
- Endpoint privado do EKS
- Grupos de segurança restritivos

## 📈 Monitoramento

### Recursos Monitorados:
- **RDS**: Enhanced Monitoring com intervalo de 30 segundos
- **EKS**: CloudWatch integration para cluster e nodes
- **VPC**: VPC Flow Logs (se configurado)

## 🔄 Backup e Recuperação

### RDS:
- Backup window: 03:00-06:00 UTC
- Retention period configurável
- Deletion protection habilitado

## 🛠️ Manutenção

### Maintenance Windows:
- **RDS**: Segunda-feira 00:00-03:00 UTC
- **EKS**: Updates controlados via versões

## 📝 Melhores Práticas

1. **Versionamento**: Sempre versionar o estado do Terraform
2. **Planejamento**: Usar `terraform plan` antes de aplicar
3. **Revisão**: Revisar mudanças em ambiente de staging primeiro
4. **Segurança**: Nunca commitar arquivos `.tfvars` com dados sensíveis
5. **Monitoramento**: Monitorar custos e recursos provisionados

## 🐛 Troubleshooting

### Problemas Comuns:

**Erro de permissão IAM:**
- Verifique se as credenciais AWS estão configuradas
- Confirme as permissões necessárias

**Timeout no deploy:**
- Verifique limites de recursos na AWS
- Confirme quotas de serviço

**Problemas de rede:**
- Verifique configurações de VPC e security groups
- Confirme regras de outbound

## 📞 Suporte

Para suporte ou dúvidas:
- Team: Devops
- Project: env-techchallenge
- Managed by: Terraform

---

**Nota**: Este projeto faz parte do Tech Challenge 3 e segue as melhores práticas de Infrastructure as Code (IaC) com Terraform.