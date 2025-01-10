# Using Count Parameter
resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  tags = {
    Name = "Instance-${count.index}"
  }
}

# Using For_Each
resource "aws_instance" "example" {
  for_each = {
    instance1 = "ami-0e2c8caa4b6378d8c"
    instance2 = "ami-0e2c8caa4b6378d8c"
  }
  ami           = each.value
  instance_type = "t2.micro"
  tags = {
    Name = each.key
  }
}

