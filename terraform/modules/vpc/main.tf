resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-vpc"
    Environment = var.environment_name
    Tier        = "network"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-igw"
    Environment = var.environment_name
  })
}

resource "aws_subnet" "public" {
  for_each = local.az_index

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_newbits, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-public-${each.key}"
    Environment = var.environment_name
    Tier        = "public"
  })
}

resource "aws_subnet" "application" {
  for_each = local.az_index

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_newbits, var.availability_zone_count + each.value)
  availability_zone = each.key

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-app-${each.key}"
    Environment = var.environment_name
    Tier        = "application"
  })
}

resource "aws_subnet" "database" {
  for_each = local.az_index

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_newbits, 2 * var.availability_zone_count + each.value)
  availability_zone = each.key

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-database-${each.key}"
    Environment = var.environment_name
    Tier        = "database"
  })
}

resource "aws_eip" "nat" {
  for_each = toset(local.nat_azs)
  domain   = "vpc"

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-nat-eip-${each.key}"
    Environment = var.environment_name
  })
}

resource "aws_nat_gateway" "main" {
  for_each = toset(local.nat_azs)

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-nat-${each.key}"
    Environment = var.environment_name
  })

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-public-rt"
    Environment = var.environment_name
  })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "application" {
  for_each = local.az_index
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[local.nat_azs[var.nat_gateway_per_az ? each.value : 0]].id
  }

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-app-rt-${each.key}"
    Environment = var.environment_name
  })
}

resource "aws_route_table_association" "application" {
  for_each = aws_subnet.application

  subnet_id      = each.value.id
  route_table_id = aws_route_table.application[each.key].id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-database-rt"
    Environment = var.environment_name
  })
}

resource "aws_route_table_association" "database" {
  for_each = aws_subnet.database

  subnet_id      = each.value.id
  route_table_id = aws_route_table.database.id
}
