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

Les plans doivent être exécutés avec les identifiants Cloud de l'étudiant.
Leur sortie peut ensuite être enregistrée avec :

```powershell
terraform show -no-color plan.tfplan | Out-File -Encoding utf8 plan.txt
```

## Documentation

- [Provider Google](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Provider AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
