resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "subnet-1"
    }
  }