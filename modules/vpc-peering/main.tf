terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [aws.west1, aws.west2]
    }
  }
}

resource "aws_vpc_peering_connection" "west1_to_west2" {
  provider    = aws.west1
  vpc_id      = var.vpc_west1_id
  peer_vpc_id = var.vpc_west2_id
  peer_region = var.region_west2
  auto_accept = false
  tags = {
    Name = "west1-to-west2-peering"
  }
}

resource "aws_vpc_peering_connection_accepter" "west2" {
  provider                  = aws.west2
  vpc_peering_connection_id = aws_vpc_peering_connection.west1_to_west2.id
  auto_accept              = true
  tags = {
    Name = "west2-accept-west1"
  }
}

resource "aws_route" "west1_private_to_west2" {
  provider                  = aws.west1
  route_table_id            = var.west1_private_rt_id
  destination_cidr_block    = var.vpc_cidr_west2
  vpc_peering_connection_id = aws_vpc_peering_connection.west1_to_west2.id
  depends_on                = [aws_vpc_peering_connection_accepter.west2]
}

resource "aws_route" "west1_public_to_west2" {
  provider                  = aws.west1
  route_table_id            = var.west1_public_rt_id
  destination_cidr_block    = var.vpc_cidr_west2
  vpc_peering_connection_id = aws_vpc_peering_connection.west1_to_west2.id
  depends_on                = [aws_vpc_peering_connection_accepter.west2]
}

resource "aws_route" "west2_private_to_west1" {
  provider                  = aws.west2
  route_table_id            = var.west2_private_rt_id
  destination_cidr_block    = var.vpc_cidr_west1
  vpc_peering_connection_id = aws_vpc_peering_connection.west1_to_west2.id
  depends_on                = [aws_vpc_peering_connection_accepter.west2]
}

resource "aws_route" "west2_public_to_west1" {
  provider                  = aws.west2
  route_table_id            = var.west2_public_rt_id
  destination_cidr_block    = var.vpc_cidr_west1
  vpc_peering_connection_id = aws_vpc_peering_connection.west1_to_west2.id
  depends_on                = [aws_vpc_peering_connection_accepter.west2]
}