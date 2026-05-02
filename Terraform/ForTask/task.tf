	provider "aws" {
	    region = "ap-northeast-1" #Tokyo
	}

	#VPC
	resource "aws_vpc" "main_vpc" {
	    cidr_block = "10.0.0.0/24"
	      enable_dns_support   = true
  		  enable_dns_hostnames = true
	    tags = {
	        Name = "Vpc2"
	    }
	}

	resource "aws_subnet" "vpc2sn1" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "10.0.0.0/28"
		availability_zone = "ap-northeast-1a"
		map_public_ip_on_launch = true
		tags = {
		Name = "vpc2sn1"
		}
	}
	resource "aws_subnet" "vpc2sn2" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "10.0.0.16/28"
		availability_zone = "ap-northeast-1c"
		map_public_ip_on_launch = true
		tags = {
		Name = "vpc2sn2"
		}
	}
	resource "aws_subnet" "vpc2sn3" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "10.0.0.32/28"
		availability_zone = "ap-northeast-1a"
		tags = {
		Name = "vpc2sn3"
		}
	}
	resource "aws_subnet" "vpc2sn4" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "10.0.0.48/28"
		availability_zone = "ap-northeast-1c"
		tags = {
		Name = "vpc2sn4"
		}
	}

	resource "aws_internet_gateway" "vpc2ig"{
		vpc_id = aws_vpc.main_vpc.id
		tags = {
		Name = "vpc2ig"
		}
	}
	resource "aws_eip" "natip"{
	domain = "vpc"
	}

	resource "aws_nat_gateway" "nat" {
	allocation_id = aws_eip.natip.id
	subnet_id = aws_subnet.vpc2sn2.id
	depends_on = [aws_internet_gateway.vpc2ig]
	tags = {
	Name = "nat-gatewayvpc2"
	}
	}

	resource "aws_route_table" "pubrt" {
		vpc_id = aws_vpc.main_vpc.id
		route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.vpc2ig.id
		}
		tags = {
		Name= "vpc2pubrt"
		}
	}
	resource "aws_route_table" "prirt"{
	vpc_id = aws_vpc.main_vpc.id
	route{
	cidr_block = "0.0.0.0/0"
	nat_gateway_id = aws_nat_gateway.nat.id
	}
	tags = {
	Name = "vpc2prirt"
	}
	}

	resource "aws_route_table_association" "pubass"{
		for_each = {
		vpc2sn1 = aws_subnet.vpc2sn1.id
		vpc2sn2 = aws_subnet.vpc2sn2.id
		}
		subnet_id = each.value
		route_table_id = aws_route_table.pubrt.id
	}
	resource "aws_route_table_association" "priass"{
	for_each = {
	vpc2sn3 = aws_subnet.vpc2sn3.id
	vpc2sn4 = aws_subnet.vpc2sn4.id
	}
	subnet_id = each.value
	route_table_id = aws_route_table.prirt.id
	}


