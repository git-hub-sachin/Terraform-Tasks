resource "aws_instance" "nandu-public-ec2" {
    count=3
    ami           = "ami-0e2c8caa4b6378d8c"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.nandu-public-subnet.id
    security_groups = [aws_security_group.nandu-public-sg.id]
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
    tags = {
        Name = "nandu-enterprise-public-instance-${count.index+1}"
        }
}