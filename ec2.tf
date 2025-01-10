resource "aws_instance" "nandu-public-ec2" {
    for_each = { for i in range(1,4) : i => i }
    ami           = "ami-0e2c8caa4b6378d8c"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = module.vpc.public_subnets[0]
    security_groups = [aws_security_group.nandu-public-sg.id]
    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install nginx -y
                echo '<h1>Welcome to Nandu Enterprise</h1>' > /var/www/html/index.html
                sudo systemctl start nginx
                sudo systemctl enable nginx
                EOF
    
    tags = {
        Name = "nandu-enterprise-public-instance-${each.key}"
        }
}

resource "aws_instance" "nandu-private-ec2" {
    for_each = { for i in range(4,7) : i => i }
    ami           = "ami-0e2c8caa4b6378d8c"
    instance_type = "t2.micro"
    subnet_id = module.vpc.private_subnets[0]
    security_groups = [aws_security_group.nandu-private-sg.id]

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install mysql-server -y
                sudo systemctl start mysql
                sudo systemctl enable mysql
                EOF

    tags = {
        Name = "nandu-enterprise-private-instance-${each.key}"
        }
}

