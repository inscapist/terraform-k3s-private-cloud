# K3s in New VPC

## Getting started

```sh
terraform init

# we do it in 2 phases
terraform apply -target=module.vpc
terraform apply
```

## Partial destroy kubernetes cluster

It is not necessary to recreate VPC during experimentation. We can specify `target` to destroy only the kubernetes cluster

```sh
terraform destroy -target=module.k3s-in-new-vpc
```
