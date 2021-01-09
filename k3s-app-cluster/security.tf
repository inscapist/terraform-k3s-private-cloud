resource "aws_security_group" "self" {
  name        = "${local.name}-self"
  vpc_id      = data.aws_vpc.this.id
  description = "Allow all members of this SG to inter-communicate"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}

resource "aws_security_group" "egress" {
  name        = "${local.name}-egress"
  vpc_id      = data.aws_vpc.this.id
  description = "Allow unbounded egress communication"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

