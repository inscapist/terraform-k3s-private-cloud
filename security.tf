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

  tags = {
    # required for load balancer, see:
    # https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
    "kubernetes.io/cluster/${local.cluster_id}" = "owned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_security_group" "node_ports" {
  name        = "${local.cluster_id}-node-ports"
  vpc_id      = data.aws_vpc.this.id
  description = "Allow node ports to be discovered"

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
}
