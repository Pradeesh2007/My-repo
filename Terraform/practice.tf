	provider "aws" {
	    region = "ap-northeast-1" #Tokyo
	}

	#VPC
	resource "aws_vpc" "main_vpc" {
	    cidr_block = "10.0.0.0/24"
	    tags = {
	        Name = "VpcForEBS"
	    }
	}

	resource "aws_subnet" "sn1" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "10.0.0.0/28"
		availability_zone = "ap-northeast-1a"
		map_public_ip_on_launch = true
		tags = {
		Name = "sn1"
		}
	}
	resource "aws_subnet" "sn2" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "10.0.0.16/28"
		availability_zone = "ap-northeast-1c"
		map_public_ip_on_launch = true
		tags = {
		Name = "sn2"
		}
	}
	resource "aws_subnet" "sn3" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "10.0.0.32/28"
		availability_zone = "ap-northeast-1a"
		tags = {
		Name = "sn3"
		}
	}
	resource "aws_subnet" "sn4" {
		vpc_id = aws_vpc.main_vpc.id
		cidr_block = "10.0.0.48/28"
		availability_zone = "ap-northeast-1c"
		tags = {
		Name = "sn4"
		}
	}

	resource "aws_internet_gateway" "ig"{
		vpc_id = aws_vpc.main_vpc.id
		tags = {
		Name = "IG"
		}
	}

	resource "aws_route_table" "pubrt" {
		vpc_id = aws_vpc.main_vpc.id
		route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.ig.id
		}
		tags = {
		Name= "pubrt"
		}
	}

	resource "aws_route_table_association" "pubass"{
		for_each = {
		sn1 = aws_subnet.sn1.id
		sn2 = aws_subnet.sn2.id
		}
		subnet_id = each.value
		route_table_id = aws_route_table.pubrt.id
	}
