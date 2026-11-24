# TD 2 — Provisionnement avec Terraform

Ce TD décrit la même fondation sur GCP et AWS : un réseau, deux VM, une base
PostgreSQL privée et un enregistrement DNS. Chaque fournisseur utilise un
module réutilisable placé dans `modules/`.

## Exécution

```powershell
cd foundation-gcp # ou foundation-aws
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -check
terraform validate
terraform plan -out=plan.tfplan
terraform show -no-color plan.tfplan
```

L'authentification passe par les mécanismes standards des providers :
`GOOGLE_APPLICATION_CREDENTIALS` pour GCP, ou le profil et les variables
d'environnement AWS. Les fichiers sensibles, les états et les plans binaires
sont ignorés par Git.

## Résultats des plans

### GCP

Le plan GCP a été généré avec le compte de service du cours :

```text
Plan: 12 to add, 0 to change, 0 to destroy.
```

La sortie complète se trouve dans
[`foundation-gcp/plan-gcp.txt`](foundation-gcp/plan-gcp.txt).

### AWS

Le plan AWS doit être généré après configuration de nouveaux identifiants,
la clé précédemment exposée ayant été écartée pour des raisons de sécurité.

Commande d'export d'un plan :

```powershell
terraform show -no-color plan.tfplan | Out-File -Encoding utf8 plan.txt
```

## Documentation

- [Provider Google](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Provider AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
