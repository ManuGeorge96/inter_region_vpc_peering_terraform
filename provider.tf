provider "aws" {
  region = var.region_requestor
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "aws" {
  region = var.region_acceptor
  access_key = var.access_key
  secret_key = var.secret_key
  alias = "acceptor"
}
