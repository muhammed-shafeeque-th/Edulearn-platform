resource "aws_security_group" "bastion" {
  name        = "${var.name}-bastion-sg"
  description = "Security group for Bastion host"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, local.common_tags, { Name = "${var.name}-bastion-sg" })
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id              = var.public_subnet_id
  monitoring             = true

  user_data = file("${path.module}/bastion_user_data.sh")

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

    # associate_public_ip_address = true

  tags = merge(var.tags, local.common_tags, { Name = "${var.name}-bastion" })
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"
}