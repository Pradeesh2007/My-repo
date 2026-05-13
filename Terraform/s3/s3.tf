provider "aws" {   
    region = ap-northeast-1
 }

 resource "aws_s3_bucket" "s3-1" {
    bucker = "minato-s3-07"
    tags = {
        Name = "minatoBucket"
    }
 }