terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_security_group" "db_security_group" {
  name        = "db-security-group"
  description = "Allow incoming traffic on port 1433"
}

resource "aws_security_group_rule" "allow_db_traffic" {
  type        = "ingress"
  from_port   = 1433
  to_port     = 1433
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db_security_group.id
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "sqlserver-ex"
  engine_version       = "15.00.4043.16.v1"
  instance_class       = "db.t3.micro"
  username             = "bessier"
  password             = "password"
  skip_final_snapshot  = true
  publicly_accessible  = true  # Make the RDS instance publicly accessible

  vpc_security_group_ids = [aws_security_group.db_security_group.id]

  tags = {
    Name = "Bessier-DB"
  }
}