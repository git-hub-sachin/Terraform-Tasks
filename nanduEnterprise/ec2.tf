resource "aws_key_pair" "nandu-key-pair" {
  key_name   = "nandu-enterprise-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}


resource "aws_instance" "nandu-public-ec2" {
    count=3
    ami           = "ami-0e2c8caa4b6378d8c"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.nandu-public-subnet.id
    security_groups = [aws_security_group.nandu-public-sg.id]
    key_name             = aws_key_pair.nandu-key-pair.key_name 

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install nginx -y
                echo '<h1>Welcome to Nandu Enterprise</h1>' > /var/www/html/index.html
                sudo systemctl start nginx
                sudo systemctl enable nginx
                EOF
    
    tags = {
        Name = "nandu-enterprise-public-instance-${count.index+1}"
        }
}

resource "aws_instance" "nandu-private-ec2" {
    count=3
    ami           = "ami-0e2c8caa4b6378d8c"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.nandu-private-subnet.id
    security_groups = [aws_security_group.nandu-private-sg.id]
    key_name             = aws_key_pair.nandu-key-pair.key_name 

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install mysql-server -y
                sudo systemctl start mysql
                sudo systemctl enable mysql
                EOF

    tags = {
        Name = "nandu-enterprise-private-instance-${count.index+1}"
        }
}

resource "aws_instance" "nandu-bastion" {
  ami                       = "ami-0e2c8caa4b6378d8c"
  instance_type             = "t2.micro"
  associate_public_ip_address = true
  subnet_id                 = aws_subnet.nandu-public-subnet.id
  security_groups           = [aws_security_group.nandu-public-sg.id]
  tags = {
    Name = "nandu-enterprise-bastion"
  }
}
