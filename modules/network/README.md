# Network Module

Terraform module that provisions a production ready **VPC networking layer** for ECS/Fargate workloads, including:

* VPC with DNS support and IPv6 enabled
* Public and private subnets across a configurable number of AZs
* Internet Gateway and routing for public subnets
* Optional NAT Gateways for private subnet egress (`none`, `one`, `all`)
* VPC Flow Logs to CloudWatch Logs (KMS-encrypted) with least-privilege IAM role
* Interface VPC Endpoints for SSM and Secrets Manager (private DNS enabled) plus a dedicated endpoint security group
* Exports VPC, subnet objects, and NAT Gateway EIPs for downstream modules (for example, ALB allowlisting)

This module is intended to be consumed by higher level stacks that attach ALBs, ECS clusters/services, RDS, and other application resources.

## What This Module Provisions

* `aws_vpc` with:

  * DNS hostnames and DNS support enabled
  * Generated IPv6 CIDR block assigned
* `aws_internet_gateway`
* Subnets:

  * `aws_subnet.public` across `network_config.az_num` AZs
  * `aws_subnet.private` across `network_config.az_num` AZs
  * Public subnets do **not** auto-assign public IPv4 on launch (`map_public_ip_on_launch = false`)
* Route tables and routes:

  * Public route table with `0.0.0.0/0` to the Internet Gateway
  * Private route tables with optional `0.0.0.0/0` routes to NAT Gateway(s)
* NAT Gateways (optional):

  * `aws_eip.ngw` Elastic IPs (customer-managed) for NAT egress
  * `aws_nat_gateway.ngw` in public subnets
* VPC Flow Logs:

  * `aws_cloudwatch_log_group.vpc_flow` (KMS-encrypted)
  * `aws_kms_key.cloudwatch_logs` + alias for CloudWatch Logs encryption
  * `aws_iam_role.vpc_flow` + inline policy to write to the flow log group
  * `aws_flow_log.this` with `traffic_type = "ALL"`
* VPC Endpoints:

  * Interface endpoint for SSM (`com.amazonaws.<region>.ssm`) associated to **public** subnets
  * Interface endpoint for Secrets Manager (`com.amazonaws.<region>.secretsmanager`) associated to **private** subnets
  * Endpoint security group `aws_security_group.ssm_vpc` (egress allow all)

## Usage

### Example

```hcl
module "network" {
  source = "./modules/network"

  network_config = {
    project_name       = "${var.project}-${var.env}"
    name_prefix        = "${var.org}-${var.project}-${var.env}"
    base_domain        = var.base_domain

    account_id         = local.account_id
    env                = var.env
    project            = var.project
    aws_region         = var.aws_region

    # Topology
    az_num             = 3
    vpc_ip_block       = "172.27.72.0/22"
    subnet_cidr_private = "172.27.72.0/24"
    subnet_cidr_public  = "172.27.73.0/24"
    new_bits_private   = 2
    new_bits_public    = 2

    # NAT strategy: "none" | "one" | "all"
    natgw_count        = var.natgw_count

    # Informational allowlists/ports (primarily consumed by other modules)
    public_ips         = { "104.193.171.254/32" = "Allowed IP" }
    public_ips_v6      = {}
    app_ports          = [80, 443]

    common_tags = {
      Env       = var.env
      ManagedBy = "terraform"
      Project   = var.project
    }
  }
}
```

## Inputs

This module is configured using one object input: `network_config`.

| Name           | Description                                                           | Type   | Default            | Required |
| -------------- | --------------------------------------------------------------------- | ------ | ------------------ | -------- |
| network_config | Composite config for VPC, subnets, NAT strategy, endpoints, and tags. | object | see `variables.tf` | No       |

---

## network_config schema

| Field               | Description                                                                                | Type         | Required |
| ------------------- | ------------------------------------------------------------------------------------------ | ------------ | -------- |
| project_name        | Display name used in Name tags (for example, VPC/IGW naming).                              | string       | yes      |
| name_prefix         | Shared prefix used for naming resources consistently.                                      | string       | yes      |
| base_domain         | Base DNS domain (informational; used by upstream stacks).                                  | string       | yes      |
| account_id          | AWS account id (used for KMS policy scoping; if empty, current caller is used).            | string       | yes      |
| env                 | Environment name (dev, stage, prod, etc.).                                                 | string       | yes      |
| project             | Project identifier used for naming and tagging.                                            | string       | yes      |
| aws_region          | AWS region (used for endpoints and CloudWatch Logs service principal).                     | string       | yes      |
| az_num              | Number of AZs to spread subnets across.                                                    | number       | yes      |
| vpc_ip_block        | VPC IPv4 CIDR block.                                                                       | string       | yes      |
| subnet_cidr_private | Private subnet CIDR base (will be subdivided per AZ).                                      | string       | yes      |
| subnet_cidr_public  | Public subnet CIDR base (will be subdivided per AZ).                                       | string       | yes      |
| new_bits_private    | CIDR subdivision bits for private subnets.                                                 | number       | yes      |
| new_bits_public     | CIDR subdivision bits for public subnets.                                                  | number       | yes      |
| natgw_count         | NAT strategy: `none`, `one`, `all`. Controls NAT gateway count and private default routes. | string       | yes      |
| public_ips          | IPv4 CIDR allowlist (informational; typically consumed by ALB module).                     | map(string)  | yes      |
| public_ips_v6       | IPv6 CIDR allowlist (informational; typically consumed by ALB module).                     | map(string)  | yes      |
| app_ports           | Application ports (informational; typically consumed by ALB/ECS stacks).                   | list(number) | yes      |
| common_tags         | Tags applied to supported resources.                                                       | map(string)  | yes      |

> [!NOTE]
> `public_ips`, `public_ips_v6`, and `app_ports` are carried in `network_config` for convenience and upstream compatibility. This module focuses on VPC primitives; consumers like `modules/alb` typically enforce allowlists and ports.

---

## Outputs

| Name             | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| vpc              | The VPC object.                                              |
| subnets_private  | List of private subnet objects.                              |
| subnets_public   | List of public subnet objects.                               |
| nat_gateway_eips | List of NAT Gateway Elastic IP addresses (customer-managed). |

---

## Resources

| Name                                                       | Type        | Description                                                   |
| ---------------------------------------------------------- | ----------- | ------------------------------------------------------------- |
| aws_vpc.main                                               | resource    | VPC with DNS enabled and generated IPv6 CIDR.                 |
| aws_internet_gateway.igw                                   | resource    | Internet Gateway for public routing.                          |
| aws_subnet.public                                          | resource    | Public subnets across AZs (IPv6 blocks assigned).             |
| aws_subnet.private                                         | resource    | Private subnets across AZs.                                   |
| aws_route_table.public                                     | resource    | Public route table.                                           |
| aws_route.route_public                                     | resource    | Default route to IGW.                                         |
| aws_route_table_association.public                         | resource    | Associates public subnets to public route table.              |
| aws_route_table.private                                    | resource    | Private route tables (one per private subnet).                |
| aws_route_table_association.private                        | resource    | Associates private subnets to private route tables.           |
| aws_eip.ngw                                                | resource    | NAT Gateway EIPs (created only when NAT enabled).             |
| aws_nat_gateway.ngw                                        | resource    | NAT Gateways in public subnets (optional).                    |
| aws_route.private_natgw                                    | resource    | Private default routes to NAT Gateway(s) (optional).          |
| aws_kms_key.cloudwatch_logs                                | resource    | KMS key for CloudWatch Logs encryption (flow logs).           |
| aws_kms_alias.cloudwatch_logs                              | resource    | Alias for the CloudWatch Logs KMS key.                        |
| aws_cloudwatch_log_group.vpc_flow                          | resource    | VPC Flow Logs log group (KMS-encrypted).                      |
| aws_iam_role.vpc_flow                                      | resource    | IAM role assumed by VPC Flow Logs service.                    |
| aws_iam_role_policy.vpc_flow                               | resource    | Inline policy permitting writes to the flow log group.        |
| aws_flow_log.this                                          | resource    | VPC Flow Logs to CloudWatch Logs.                             |
| aws_security_group.ssm_vpc                                 | resource    | Security group for interface endpoints.                       |
| aws_security_group_rule.ssm_egress                         | resource    | Endpoint SG egress allow all.                                 |
| aws_vpc_endpoint.ssm                                       | resource    | Interface endpoint for SSM (private DNS enabled).             |
| aws_vpc_endpoint_subnet_association.ssm_public             | resource    | Associates SSM endpoint to public subnets.                    |
| aws_vpc_endpoint.secretsmanager                            | resource    | Interface endpoint for Secrets Manager (private DNS enabled). |
| aws_vpc_endpoint_subnet_association.secretsmanager_private | resource    | Associates Secrets Manager endpoint to private subnets.       |
| aws_default_security_group.default                         | resource    | Default SG kept empty (baseline hardening).                   |
| data.aws_availability_zones.az                             | data source | Used to spread subnets across available AZs.                  |
| data.aws_caller_identity.current                           | data source | Used for KMS policy scoping when account_id is unset.         |

---

## Notes

* NAT Gateway EIPs exported by this module are **customer-managed** and stable. They can be allowlisted elsewhere (for example, on the public ALB SG) when internal callers egress through NAT.
* You may still see additional public IPs in AWS (for example, ALB-owned ENIs). Those are AWS-managed service addresses and should not be treated as stable allowlist targets.
* VPC Flow Logs are configured for `traffic_type = "ALL"` and write to a KMS-encrypted CloudWatch Log Group with 365-day retention.
* Interface endpoints are created with private DNS enabled. The endpoint SG currently allows all egress; ingress rules can be tightened if you want to scope callers (for example, ECS task SGs).

---

## Related Projects

* `modules/alb` consumes:

  * `vpc` and `subnets_public` for ALB attachment
  * `nat_gateway_eips` to optionally allow NAT egress callers on 80/443
* `modules/ecs-service` consumes:

  * `vpc_id` and private subnets for task networking
* `modules/ecs-cluster` typically follows this module in stack order (network first, then cluster, then services)
