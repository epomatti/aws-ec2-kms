data "aws_subnet" "selected" {
  id = var.subnet
}

resource "aws_instance" "default" {
  ami           = "ami-08fdd91d87f63bb09"
  instance_type = "t4g.nano"

  associate_public_ip_address = true
  subnet_id                   = var.subnet
  vpc_security_group_ids      = [aws_security_group.default.id]

  availability_zone    = data.aws_subnet.selected.availability_zone
  iam_instance_profile = var.instance_profile_id
  user_data            = file("${path.module}/userdata.sh")

  # Enables metadata V2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  monitoring    = false
  ebs_optimized = false

  lifecycle {
    ignore_changes = [
      ami,
      associate_public_ip_address
    ]
  }

  tags = {
    Name = "${var.server_name}-${var.workload}"
  }
}


resource "aws_security_group" "default" {
  name        = "ec2-ssm-${var.workload}-${var.server_name}"
  description = "Controls access for EC2 via Session Manager"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ec2-ssm-${var.workload}-${var.server_name}"
  }
}

resource "aws_security_group_rule" "ingress_internet" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.default.id
}


resource "aws_security_group_rule" "egress_internet" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.default.id
}
