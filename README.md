# vpc_peering_terraform

## Resources Used
 
- Cloud VPC :- 2 
- Peering Connection :- 1
- Subnets :- 4 (2 Public on VPC 1, One Private and One Public on VPC 2)
- Route Table :- 3 ( 1 Public Route Table for VPC 1, One Public-RTB and one Private-RTB on VPC2) 
- Internet-Gateway :- 2
- NAT Gateway :- 1
- Elastic-IP :- 1
- Key-Pair :- 1
- Security Groups :- 3 
- EC2 Instances :- 3

## About

This is a Fully automated Terraform codes which make use of creating Inter Region VPC Peering. Here we have an APP server and a SSH Server on the First VPC, and a Database server on Second VPC which is situated on a differnt AWS region.

Also, the Database server resides in a Private Network and the SSH access to Database server is made posssible only from SSH server deployed on VPC 1. This terraform code itself do the subnet calculations and also it will be using the latest available Amazon Linux AMI on all the 3 Insances.

Included the option for applying User Data to APP and DB server, a user can edit them as their wish ( <b>app.sh</b> and <b>db.sh</b> ).

## Project Outline

[<img align="center" alt="Unix" width="900" src="https://raw.githubusercontent.com/ManuGeorge96/ManuGeorge96/master/Tools/peering.drawio.png" />][ln]

## Prerequisites

- Terraform must be instaled.
- An AWS user with corect IAM Permissions.
- Basic Knowledge on installing Services on a Linux machine.

## How to use the code

- 









[ln]: https://www.linkedin.com/in/manu-george-03453613a
