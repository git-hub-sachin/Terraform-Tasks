provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "mahendra-ec2" {
  name = "mahendra-ec2-user"
}

resource "aws_iam_user_policy_attachment" "mahendra-ec2-policy" {
  user       = aws_iam_user.mahendra-ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_user_login_profile" "mahendra-ec2-login" {
  user              = aws_iam_user.mahendra-ec2.name
  password_length        = 16
  password_reset_required = true 
}

output "password" {
  value = aws_iam_user_login_profile.mahendra-ec2-login.encrypted_password
}