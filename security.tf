resource "aws_security_group" "self" {
  name        = "${local.cluster_id}-self"
  vpc_id      = data.aws_vpc.this.id
  description = "Allow all members of this SG to inter-communicate"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  tags = merge(module.this.tags, {
    # required for load balancer, see:
    # https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
    "kubernetes.io/cluster/${local.cluster_id}" = "owned"
  })
}

resource "aws_security_group" "egress" {
  name        = "${local.cluster_id}-egress"
  vpc_id      = data.aws_vpc.this.id
  description = "Allow unbounded egress communication"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.this.tags
}

