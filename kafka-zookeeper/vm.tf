provider "aws" {
  region = "us-east-2" # Replace with your desired region
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "kafka-demo"
  public_key = file("C:\\Users\\coupland\\.ssh\\id_rsa.pub") # Path to your public key
}

resource "aws_security_group" "kafka_sg" {
  name        = "kafka-demo-sg"
  description = "Allow SSH, Zookeeper, and Kafka traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # or replace with you IP
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # or replace with you IP
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # or replace with you IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # or replace with you IP
  }

  tags = {
    Name = "kafka-demo-sg"
  }
}

# otherwise you would need to manually type in AMI ID that changes on a given region
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"]
}

resource "aws_instance" "kafka_instance" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.large"
  key_name      = aws_key_pair.my_key_pair.key_name

  vpc_security_group_ids = [aws_security_group.kafka_sg.id]

  tags = {
    Name = "kafka_instance"
  }
}

# no need to go to the console to copy the public IP. TF will output it once terraform apply went through
output "ec2_public_ip" {
  value = aws_instance.kafka_instance.public_ip
}