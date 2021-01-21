# K3s in Existing VPC

## Getting started

```sh
terraform init

# we do it in 2 phases
terraform apply -target=module.subnets
terraform apply
```
