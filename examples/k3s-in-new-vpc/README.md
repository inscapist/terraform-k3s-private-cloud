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

## Use spot instance for NAT

```terraform
 # If you prefer to use spot-instances for NAT, use this
 # You don't need this if nat_gateway is enabeld
 module "nat" {
   source = "int128/nat-instance/aws"

   name                        = "k3s_nat"
   vpc_id                      = module.vpc.vpc_id
   public_subnet               = module.vpc.public_subnets[0]
   private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
   private_route_table_ids     = module.vpc.private_route_table_ids
 }

```
