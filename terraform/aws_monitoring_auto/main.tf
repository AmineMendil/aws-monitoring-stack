
# =========================================================
# CLÉ SSH (AUTO GENERATED)
# =========================================================
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "monitoring_key" {
  key_name   = "monitoring-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/monitoring-key.pem"
  file_permission = "0400"
}

# =========================================================
# AMI UBUNTU DYNAMIQUE
# =========================================================
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# =========================================================
# SECURITY GROUP
# =========================================================
resource "aws_security_group" "monitoring_sg" {
  name = "monitoring-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# =========================================================
# MONITORING SERVER
# =========================================================
resource "aws_instance" "monitoring" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = aws_key_pair.monitoring_key.key_name

  security_groups = [aws_security_group.monitoring_sg.name]

  tags = {
    Name     = "monitoring-server"
    Hostname = "monitoring-server"
  }
}

# =========================================================
# WEB SERVER
# =========================================================
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = aws_key_pair.monitoring_key.key_name

  security_groups = [aws_security_group.monitoring_sg.name]

  tags = {
    Name     = "web-server"
    Hostname = "web-server"
  }
}

# =========================================================
# DB SERVER
# =========================================================
resource "aws_instance" "db" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = aws_key_pair.monitoring_key.key_name

  security_groups = [aws_security_group.monitoring_sg.name]

  tags = {
    Name     = "db-server"
    Hostname = "db-server"
  }
}