data "aws_availability_zones" "AZ-requestor" {
  state = "available"
}
data "aws_availability_zones" "AZ-acceptor" {
  provider = aws.acceptor
  state = "available"
}
data "aws_ami" "AMI-requestor" {
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.*-hvm-2.*-x86_64-gp2"]
  }
  filter {
  name = "root-device-type"
  values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
}
data "aws_ami" "AMI-acceptor" {
  provider = aws.acceptor
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.*-hvm-2.*-x86_64-gp2"]
  }
  filter {
  name = "root-device-type"
  values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
}
