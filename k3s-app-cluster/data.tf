data "aws_vpc" "this" {
  id = "vpc-35504650"
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.this.id
}
