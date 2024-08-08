provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "myterraformVPC"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "web" {
  count = 3
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = "us-east-1a"  // Adjust as per your region
}

resource "aws_subnet" "tomcat" {
  count = 3
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.${count.index + 10}.0/24"
  availability_zone = "us-east-1b"  // Adjust as per your region
}

resource "aws_subnet" "alb" {
  count = 3
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.${count.index + 20}.0/24"
  availability_zone = "us-east-1c"  // Adjust as per your region
}

resource "aws_subnet" "jump" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.30.0/24"
  availability_zone = "us-east-1a"  // Adjust as per your region
}
resource "aws_subnet" "publicSubnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "privateSubnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.privateSubnet.id
  route_table_id = aws_route_table.PublicRT.id

}

resource "aws_instance" "EC2" {
  ami           = "ami-0ba9883b710b05ac6"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.publicSubnet.id  # Correct subnet reference

  tags = {
    Name = "my_demo_instance"
  }
}