resource "aws_security_group" "this" {
  name        = "${var.ec2_config.name}-sg"
  description = "Security group for ${var.ec2_config.name}"
  vpc_id      = var.ec2_config.vpc_id

  dynamic "ingress" {
    for_each = var.ec2_config.ingress_rules
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

  tags = local.tags
}

resource "aws_iam_role" "this" {
  name = "${var.ec2_config.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.ec2_config.name}-profile"
  role = aws_iam_role.this.name
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.ec2_config.instance_type
  subnet_id              = var.ec2_config.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name
  source_dest_check      = false
  user_data              = var.ec2_config.user_data

  tags = local.tags
}

resource "aws_eip_association" "this" {
  instance_id   = aws_instance.this.id
  allocation_id = var.ec2_config.eip_allocation_id
}
