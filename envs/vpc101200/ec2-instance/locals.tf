locals {
  base_config = data.terraform_remote_state.base_config.outputs.base_config
  vpc_outputs = data.terraform_remote_state.vpc.outputs.vpc_outputs
  eip_outputs = data.terraform_remote_state.eip.outputs

  ec2_config = {
    name              = "${local.base_config.name_prefix}-strongswan"
    common_tags       = local.base_config.common_tags
    vpc_id            = local.vpc_outputs.vpc_id
    subnet_id         = local.vpc_outputs.private_subnet_ids[0]
    instance_type     = "t3.micro"
    eip_allocation_id = local.eip_outputs.allocation_id

    user_data = <<-EOF
      #!/bin/bash
      set -e
      dnf install -y strongswan
      systemctl enable strongswan-starter
      systemctl start strongswan-starter
      echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
      sysctl -p
    EOF

    ingress_rules = [
      {
        description = "IKE"
        from_port   = 500
        to_port     = 500
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "NAT-T"
        from_port   = 4500
        to_port     = 4500
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}
