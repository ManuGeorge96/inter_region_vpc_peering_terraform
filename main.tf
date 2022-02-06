##################################################################
#SECTION=1
#################################################################
resource "aws_vpc" "vpc-requestor" {
  cidr_block = var.cidr_requestor
  enable_dns_hostnames = true
  tags = {
    Name = "requestor-Peer"
  }
}

resource "aws_vpc" "vpc-acceptor" {
  provider = aws.acceptor
  cidr_block = var.cidr_acceptor
  enable_dns_hostnames = true
  tags = {
    Name = "acceptor-Peer"
  }
}
###################################################################
#SECTION=2
###################################################################
resource "aws_vpc_peering_connection" "Peering" {
  vpc_id = aws_vpc.vpc-requestor.id
  peer_vpc_id = aws_vpc.vpc-acceptor.id
  peer_region = var.region_acceptor
  auto_accept = false
  tags = {
    Name = "Peer-Requestor"
  }
}
 
resource "aws_vpc_peering_connection_accepter" "Peering" {
  provider = aws.acceptor
  vpc_peering_connection_id = aws_vpc_peering_connection.Peering.id
  auto_accept = true
  tags = {
    Name = "Peer-Acceptor"
  }
}
#########################################################################
#SECTION=3
##########################################################################
resource "aws_subnet" "requestor-Public-1" {
  cidr_block = cidrsubnet(var.cidr_requestor, var.subnetr, 0)
  availability_zone = data.aws_availability_zones.AZ-requestor.names[0]
  vpc_id = aws_vpc.vpc-requestor.id
  map_public_ip_on_launch = true
  tags = {
    Name = "requestor-Public-1"
  }
}

resource "aws_subnet" "requestor-Public-2" {
  cidr_block = cidrsubnet(var.cidr_requestor, var.subnetr, 1)
  availability_zone = data.aws_availability_zones.AZ-requestor.names[1]
  vpc_id = aws_vpc.vpc-requestor.id
  map_public_ip_on_launch = true
  tags = {
    Name = "requestor-Public-2"
  }
}

resource "aws_subnet" "acceptor-Private-1" {
  provider = aws.acceptor
  cidr_block = cidrsubnet(var.cidr_acceptor, var.subneta, 0)
  availability_zone = data.aws_availability_zones.AZ-acceptor.names[0]
  vpc_id = aws_vpc.vpc-acceptor.id
  tags = {
    Name = "acceptor-Private-1"
  }
}

resource "aws_subnet" "acceptor-Public-1" {
  provider = aws.acceptor
  cidr_block = cidrsubnet(var.cidr_acceptor, var.subneta, 1)
  availability_zone = data.aws_availability_zones.AZ-acceptor.names[1]
  vpc_id = aws_vpc.vpc-acceptor.id
  tags = {
    Name = "acceptor-Public-1"
  }
}
############################################################################
#SECTION=4
############################################################################
resource "aws_eip" "acceptor-eip" {
  provider = aws.acceptor
  vpc = true
  tags = {
    Name = "acceptor-EIP"
  }
}
#############################################################################
#SECTION=5
#############################################################################
resource "aws_nat_gateway" "acceptor-NAT" {
  provider = aws.acceptor
  allocation_id = aws_eip.acceptor-eip.id
  subnet_id = aws_subnet.acceptor-Public-1.id
  tags = {
    Name = "acceptor-NAT"
  }
}
##############################################################################
#SECTION=6
##############################################################################
resource "aws_internet_gateway" "requestor-IGw" {
  vpc_id = aws_vpc.vpc-requestor.id
  tags = {
    Name = "requestor-IGW"
  }
}
 
resource "aws_internet_gateway" "acceptor-IGw" {
  provider = aws.acceptor
  vpc_id = aws_vpc.vpc-acceptor.id
  tags = {
    Name = "acceptor-IGW"
  }
}
##############################################################################
#SECTION=7
##############################################################################
resource "aws_route_table" "acceptor-Private-RTB" {
  provider = aws.acceptor
  vpc_id = aws_vpc.vpc-acceptor.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.acceptor-NAT.id
  }
  route {
    cidr_block = aws_subnet.requestor-Public-1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.Peering.id
  }
  tags = {
    Name = "Peer-Private-RTB"
  }
}

resource "aws_route_table" "acceptor-Public-RTB" {
  provider = aws.acceptor
  vpc_id = aws_vpc.vpc-acceptor.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.acceptor-IGw.id
  }
  tags = {
    Name = "Peer-acceptor-Public"
  }
}

resource "aws_route_table" "requestor-Public-RTB" {
  vpc_id = aws_vpc.vpc-requestor.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.requestor-IGw.id
  }
  route {
    cidr_block = aws_subnet.acceptor-Private-1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.Peering.id
  }
  tags = {
    Name = "Peer-requestor-Public"
  }
}
#################################################################################
#SECTION=8
#################################################################################
resource "aws_route_table_association" "requestor" {
  subnet_id = aws_subnet.requestor-Public-1.id
  route_table_id = aws_route_table.requestor-Public-RTB.id
}
resource "aws_route_table_association" "requestor2" {
  subnet_id = aws_subnet.requestor-Public-2.id
  route_table_id = aws_route_table.requestor-Public-RTB.id
}
resource "aws_route_table_association" "acceptor-private" {
  subnet_id = aws_subnet.acceptor-Private-1.id
  route_table_id = aws_route_table.acceptor-Private-RTB.id
  provider = aws.acceptor
}
resource "aws_route_table_association" "acceptor-public" {
  subnet_id = aws_subnet.acceptor-Public-1.id
  route_table_id = aws_route_table.acceptor-Public-RTB.id
  provider = aws.acceptor
}
#END  OF VPC PEERING + ROUTE CONF
###############################################################################
#SECTION=9
################################################################################
resource "aws_instance" "DB" {
  provider = aws.acceptor
  instance_type = var.type
  subnet_id = aws_subnet.acceptor-Private-1.id
  ami = data.aws_ami.AMI-acceptor.id
  key_name = aws_key_pair.Peer-acceptor.key_name
  vpc_security_group_ids = [ aws_security_group.acceptor-db.id ]
  user_data = file("db.sh")
  tags = {
    Name = "Peer-DB"
  }
}
 resource "aws_instance" "SSH" {
  instance_type = var.type
  subnet_id = aws_subnet.requestor-Public-1.id
  ami = data.aws_ami.AMI-requestor.id
  key_name = aws_key_pair.Peer-requestor.key_name
  vpc_security_group_ids = [ aws_security_group.requestor-ssh.id ]
  tags = {
    Name = "Peer-SSH"
  }
}

 resource "aws_instance" "APP" {
  instance_type = var.type
  subnet_id = aws_subnet.requestor-Public-2.id
  ami = data.aws_ami.AMI-requestor.id
  key_name = aws_key_pair.Peer-requestor.key_name
  vpc_security_group_ids = [ aws_security_group.requestor-app.id ]
  user_data = file("app.sh")
  tags = {
    Name = "Peer-APP"
  }
}
############################################################################
#SECTION=10
#############################################################################
resource "aws_security_group" "acceptor-db" {
  provider = aws.acceptor
  name = "DB-SG"
  description = "DB-acces"
  vpc_id = aws_vpc.vpc-acceptor.id
  ingress {
    description = "DB"
    protocol = "tcp"
    from_port = "3306"
    to_port = "3306"
    cidr_blocks = [ aws_subnet.requestor-Public-2.cidr_block ]
  }
  ingress {
    description = "SSH"
    protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr_blocks = [ aws_subnet.requestor-Public-1.cidr_block ]
    }
    egress {
      description = ""
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = [ "::/0" ]
    }
    tags = {
      Name = "Peer-DB"
    }
}

resource "aws_security_group" "requestor-app" {
  name = "APP-SG"
  description = "app-acces"
  vpc_id = aws_vpc.vpc-requestor.id
  ingress {
    description = "WEB"
    protocol = "tcp"
    from_port = "80"
    to_port = "80"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "SSH"
    protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr_blocks = [ aws_subnet.requestor-Public-1.cidr_block ]
    }
    egress {
      description = ""
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = [ "::/0" ]
    }
    tags = {
      Name = "Peer-APP"
    }
}

resource "aws_security_group" "requestor-ssh" {
  name = "SSH-SG"
  description = "SSH-acces"
  vpc_id = aws_vpc.vpc-requestor.id
  ingress {
    description = "SSH"
    protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    description = ""
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }
  tags = {
    Name = "Peer-SSH"
  }
}
