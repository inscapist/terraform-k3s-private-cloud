# VPC Endpoints for Session Manager

### First, you probably don't need this

Do you NOT want your EC2 instance to connect to outside world? Download updates? Call external databases? Then you should create a nat gateway instead.

But if you are certain, then this is for you.

There are 3 ways to talk to System Manager services:

- Use internet gateway and assign Public IP (not an option for a private cluster)
- Use a nat gateway
- Create VPC endpoints for each services (this module)

### References

- https://aws.amazon.com/premiumsupport/knowledge-center/ec2-systems-manager-vpc-endpoints/
- https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/vpc-endpoints.tf
- https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html

### NOTE

For windows AMI, you need EC2 endpoint too:
https://docs.aws.amazon.com/vpc/latest/userguide/vpce-interface.html#vpce-private-dns

### DNS support in your VPC

DNS support must be enabled for endpoints to be discoverable.
In the console -> VPC, enable `DnsHostnames` and `DnsSupport`
