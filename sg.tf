variable "sg_port" {
  type        = list(number)
  description = "MULTIPLE SG PORTS"
  default     = [80, 443, 22, 25, 2049, 389]
}

resource "aws_security_group" "allow_dynamic_sg" {
  name        = "allow_dynamic_sg"
  description = "Allow DYNAMIC SG"


  dynamic "ingress" {
    for_each = var.sg_port
    iterator = port
    content {
      description = "MULTIPORT from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = upper("allow_multiple_port_remote_provisioner")
  }
}
