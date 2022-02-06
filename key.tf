resource "aws_key_pair" "Peer-requestor" {
  key_name = "peer"
  public_key = file("peer.pub")
}
resource "aws_key_pair" "Peer-acceptor" {
  provider = aws.acceptor
  key_name = "peer"
  public_key = file("peer.pub")
}
