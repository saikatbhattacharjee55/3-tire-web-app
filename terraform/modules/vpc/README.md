# VPC module

Creates a tagged VPC with DNS support, public subnets, private application subnets, isolated database subnets, an internet gateway, NAT Gateway egress, and associated route tables.

Availability zones are discovered in the configured AWS region. Two AZs are used by default. Each AZ gets one subnet in each tier. Subnet CIDRs are derived from `vpc_cidr` and `subnet_newbits`.

The default is one shared NAT Gateway to reduce development cost. This means private subnets in the other AZ rely on cross-AZ egress through that gateway. Set `nat_gateway_per_az = true` for one NAT Gateway per AZ, improving AZ-level egress resilience at a higher cost. Database subnets have no default internet route.

## Inputs

| Name | Description | Required |
| --- | --- | --- |
| `name` | Project name for resource naming | yes |
| `environment_name` | Environment name | yes |
| `vpc_cidr` | VPC IPv4 CIDR block | yes |
| `availability_zone_count` | Two or three available AZs | yes |
| `subnet_newbits` | Additional CIDR bits per subnet | yes |
| `nat_gateway_per_az` | Create a NAT Gateway in each AZ | yes |
| `tags` | Additional resource tags | no |

## Outputs

VPC ID and CIDR, AZ list, public/application/database subnet ID maps, NAT Gateway ID map, and NAT public IP map.
