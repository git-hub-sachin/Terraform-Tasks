resource "aws_vpc_peering_connection" "peer" {
  provider    = aws.us-west-1
  vpc_id      = var.vpc1_id
  peer_vpc_id = var.vpc2_id
  peer_region = "us-west-2"
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider                  = aws.us-west-2
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true
}