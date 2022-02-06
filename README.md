# inter_region_vpc_peering_terraform

## What is VPC Peering?

VPC peering is basically a network connection which enables us to connect multiple VPC's (region-region, account-account). VPC peering allows you to deploy cloud resources in a virtual network that you have defined, also data can be transferred across these resources with more security.

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

This is a Fully automated Terraform codes which make use of creating Inter Region VPC Peering. Here we have an APP server and a SSH Server on the First VPC, and a Database server on Second VPC which is situated on a different AWS region.

Also, the Database server resides in a Private Network and the SSH access to Database server is made posssible only from SSH server deployed on VPC 1. This terraform code itself do the subnet calculations and also it will be using the latest available Amazon Linux AMI on all the 3 Insances.

Included the option for applying User Data for APP and DB server, a user can edit them as their wish ( <b>app.sh</b> and <b>db.sh</b> ).

## Project Outline

[<img align="center" alt="Unix" width="900" src="https://raw.githubusercontent.com/ManuGeorge96/ManuGeorge96/master/Tools/peering.drawio.png" />][ln]

## Prerequisites

- Terraform must be instaled.
- An AWS user with corect IAM Permissions.
- Basic Knowledge on installing Services on a Linux machine.

## How to use the code

 - ```sh  
    git clone https://github.com/ManuGeorge96/inter_region_vpc_peering_terraform.git
   ```
 - ```sh  
    cd vpc_peering_terraform
   ```
   <br />
 - Update <b>terraform.tfvars</b> with values.
 - You may also edit the user data files, <b>app.sh</b> and <b>db.sh</b>.
   <br />
 - ```sh
    terraform init
   ``` 
 - ```sh   
    terraform apply
   ```  
 - Once Copleted you will get the required IPs for the Instances on the terminal and you can SSH into the Instances using the key <b>peer</b>

## Behind The Stage

   main.tf
- Section - 1
   -  Resource Block used for creating VPC's on the two regions
   -  aws_vpc

-  Section - 2
   -  Contains two resource block <b>aws_vpc_peering_connection</b> and <b>aws_vpc_peering_connection_accepter</b>
   -  "Peering Connection" used on the requestor side and "Peering Connection Accepter" used on the accepter side.

-  Section - 3
   -  This section does the Subnet calculations and assigning the calculated subnets to each Availability Zones.
   -  aws_subnet

-  Section - 4
   -  Section for creating an Elastic IP on acceepter side.
   -  aws_eip

-  Section - 5
   -  This section deals with the NAT Gateway creation and allocation if Elastic IP to the Gateway on the accepter side.
   -  aws_nat_gateway

-  Section - 6
   -  For creating Internet Gateway on both the side ( requester and accepter ).
   -  aws_internet_gateway

-  Section - 7
   -  This section deals with the key part of the Project, Route Tables on both sides.
   -  aws_route_table
  
-  Section - 8
   -  Here, the created Route Table get allocated to the correct subnets
   -  aws_subnet_association

-  Section - 9
   -  Section deals with the EC2 instance creation APP and SSH on requester side and DB on accepter side.
   -  aws_ec2_instance

-  Section - 10
   -  Section deals with Security Group creation for the EC2 Instances.
   -  aws_security_group









[ln]: https://www.linkedin.com/in/manu-george-03453613a
