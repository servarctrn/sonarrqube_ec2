# VPC
# 1- internet GW
# 2- route tables
# 6- subnets
# 2- Subnet Associations
# 1- Security Group 


# Define our VPC
resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name        = "First-Terraform-VPC"
    builder     = "Insert your Name"
    application = "test-environment"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "class-demoIGW" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "Class-Demo-IGW"
  }
}

# Define the public and private route tables
resource "aws_route_table" "web-public-rt" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.class-demoIGW.id
  }

  tags = {
    Name = "Public Subnet RT"
  }
}

resource "aws_route_table" "non-web-private-rt" {
  vpc_id = aws_vpc.default.id

  route = []

  tags = {
    Name = "Public Subnet RT"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet1" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Web Public Subnet1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Web Public Subnet2"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet3" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Database Private Subnet3"
  }
}

resource "aws_subnet" "private-subnet4" {
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Database Private Subnet4"
  }
}
resource "aws_subnet" "private-subnet5" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Database Private Subnet3"
  }
}

resource "aws_subnet" "private-subnet6" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Database Private Subnet4"
  }
}

# Assign the route table to the public Subnet via associations
resource "aws_route_table_association" "web-public-rt1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.web-public-rt.id
}

resource "aws_route_table_association" "web-public-rt2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.web-public-rt.id
}

# Assign the route table to the private Subnet via asociations
resource "aws_route_table_association" "web-private-rt3" {
  subnet_id      = aws_subnet.private-subnet3.id
  route_table_id = aws_route_table.non-web-private-rt.id
}

resource "aws_route_table_association" "web-private-rt4" {
  subnet_id      = aws_subnet.private-subnet4.id
  route_table_id = aws_route_table.non-web-private-rt.id
}

resource "aws_route_table_association" "web-private-rt5" {
  subnet_id      = aws_subnet.private-subnet5.id
  route_table_id = aws_route_table.non-web-private-rt.id
}

resource "aws_route_table_association" "web-private-rt6" {
  subnet_id      = aws_subnet.private-subnet6.id
  route_table_id = aws_route_table.non-web-private-rt.id
}

# Define the security group for public subnet
resource "aws_security_group" "class-demo-sg" {
  name        = "class-demo-sg"
  description = "Allow incoming HTTP,HTTPS,SSH,ICMP and Database traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.default.id

  tags = {
    Name = "class-demo-sg"
  }
}