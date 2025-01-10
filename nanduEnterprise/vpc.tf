provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "nandu-vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "nandu-enterprise-vpc"
  }
}

################################## Subnet ########################################
resource "aws_subnet" "nandu-public-subnet" {
  vpc_id     = aws_vpc.nandu-vpc.id
  cidr_block = "10.0.0.0/25"

  tags = {
    Name = "nandu-enterprise-public-subnet"
  }
}

resource "aws_subnet" "nandu-private-subnet" {
  vpc_id     = aws_vpc.nandu-vpc.id
  cidr_block = "10.0.0.128/25"

  tags = {
    Name = "nandu-enterprise-private-subnet"
  }
}

################################## Internet Gateway ########################################
resource "aws_internet_gateway" "nandu-igw" {
  vpc_id = aws_vpc.nandu-vpc.id

  tags = {
    Name = "nandu-enterprise-igw"
  }
}

################################## NAT Gateway ########################################
resource "aws_eip" "nandu-eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nandu-ngw" {
  allocation_id = aws_eip.nandu-eip.id
  subnet_id     = aws_subnet.nandu-public-subnet.id

  tags = {
    Name = "nandu-enterprise-ngw"
  }
}


################################## Route Table ########################################
resource "aws_route_table" "nandu-public-rt" {
  vpc_id = aws_vpc.nandu-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nandu-igw.id
  }

  tags = {
    Name = "nandu-enterprise-public-rt"
  }
}

resource "aws_route_table_association" "nandu-public-rt-assoc" {
  subnet_id      = aws_subnet.nandu-public-subnet.id
  route_table_id = aws_route_table.nandu-public-rt.id
}

resource "aws_route_table" "nandu-private-rt" {
  vpc_id = aws_vpc.nandu-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nandu-ngw.id
  }

  tags = {
    Name = "nandu-enterprise-private-rt"
  }
}

resource "aws_route_table_association" "nandu-private-rt-assoc" {
  subnet_id      = aws_subnet.nandu-private-subnet.id
  route_table_id = aws_route_table.nandu-private-rt.id
}

######################################Security Group############################################

resource "aws_security_group" "nandu-public-sg" {
  vpc_id      = aws_vpc.nandu-vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nandu-enterprise-public-sg"
  }
}

resource "aws_security_group" "nandu-private-sg" {
  vpc_id      = aws_vpc.nandu-vpc.id

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nandu-enterprise-private-sg"
  }
}

resource "aws_security_group" "nandu-bastion-sg" {
  vpc_id      = aws_vpc.nandu-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.128/25"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nandu-enterprise-bastion-sg"
  }
}
