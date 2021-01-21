# K3s in New VPC

## Getting started

```sh
terraform init

# we do it in 2 phases
terraform apply -target=module.vpc
terraform apply
```
