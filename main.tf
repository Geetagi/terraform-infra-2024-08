provider "aws" {
  region = var.region
}


resource "aws_s3_bucket" "frontend" {
  bucket = "my-frontend-bucket"
}

resource "aws_s3_bucket_acl" "frontend" {
  bucket = aws_s3_bucket.frontend.bucket
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

output "bucket_url" {
  value = "http://${aws_s3_bucket.frontend.bucket}.s3-website-${var.region}.amazonaws.com"
}


resource "aws_elastic_beanstalk_application" "my_app" {
  name        = "my-app"
  description = "My application"
}

resource "aws_elastic_beanstalk_environment" "backend_beanstalk" {
  name                = "my-app-env"
  application         = aws_elastic_beanstalk_application.my_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.10 running Node.js 14"

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NODE_ENV"
    value     = "production"
  }
}

output "beanstalk_url" {
  value = aws_elastic_beanstalk_environment.backend_beanstalk.endpoint_url
}


resource "aws_db_instance" "mysql_db" {
  identifier        = "mydb"
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  db_name           = "mydb"
  username          = var.db_username
  password          = var.db_password
  allocated_storage = 20
  storage_type      = "gp2"
}

output "rds_endpoint" {
  value = aws_db_instance.mysql_db.endpoint
}