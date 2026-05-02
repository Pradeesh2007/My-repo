	provider "aws" {
	    region = "ap-northeast-1" #Tokyo
	}

#VPC
	resource "aws_vpc" "main_vpc" {
	    cidr_block = "192.168.0.0/24"
	      enable_dns_support   = true
  		  enable_dns_hostnames = true
	    tags = {
	        Name = "Vpc1"
	    }
	}
 # Creating subnets sn1,sn2, sn3 and sn4 
	resource "aws_subnet" "vpc1sn1" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "192.168.0.0/28"
		availability_zone = "ap-northeast-1a"
		map_public_ip_on_launch = true
		tags = {
		Name = "vpc1sn1"
		}
	}
	resource "aws_subnet" "vpc1sn2" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "192.168.0.16/28"
		availability_zone = "ap-northeast-1c"
		map_public_ip_on_launch = true
		tags = {
		Name = "vpc1sn2"
		}
	}
	resource "aws_subnet" "vpc1sn3" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "192.168.0.32/28"
		availability_zone = "ap-northeast-1a"
		tags = {
		Name = "vpc1sn3"
		}
	}
	resource "aws_subnet" "vpc1sn4" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "192.168.0.48/28"
		availability_zone = "ap-northeast-1c"
		tags = {
		Name = "vpc1sn4"
		}
	}

# creating internet gatway
	resource "aws_internet_gateway" "vpc1ig"{
		vpc_id = aws_vpc.main_vpc.id
		tags = {
		Name = "vpc1ig"
		}
	}
# get EPI for nat
	resource "aws_eip" "vpc1natip"{
	domain = "vpc"
	}
# create a nat gateway
	resource "aws_nat_gateway" "vpc1nat" {
	allocation_id = aws_eip.vpc1natip.id
	subnet_id = aws_subnet.vpc1sn2.id
	depends_on = [aws_internet_gateway.vpc1ig]
	tags = {
	Name = "vpc1nat-gateway"
	}
	}

#crreatinf the route tables
	resource "aws_route_table" "v1pubrt" {
		vpc_id = aws_vpc.main_vpc.id
		route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.vpc1ig.id
		}
		tags = {
		Name= "v1pubrt"
		}
	}
	resource "aws_route_table" "v1prirt"{
	vpc_id = aws_vpc.main_vpc.id
	route{
	cidr_block = "0.0.0.0/0"
	nat_gateway_id = aws_nat_gateway.vpc1nat.id
	}
	tags = {
	Name = "v1prirt"
	}
	}
# associatig the route tables with subnets

	resource "aws_route_table_association" "pubass"{
		for_each = {
		vpc1sn1 = aws_subnet.vpc1sn1.id
		vpc1sn2 = aws_subnet.vpc1sn2.id
		}
		subnet_id = each.value
		route_table_id = aws_route_table.v1pubrt.id
	}
	resource "aws_route_table_association" "priass"{
	for_each = {
	vpc1sn3 = aws_subnet.vpc1sn3.id
	vpc1sn4 = aws_subnet.vpc1sn4.id
	}
	subnet_id = each.value
	route_table_id = aws_route_table.v1prirt.id
	}


