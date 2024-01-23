data "aws_ami" "official_ubuntu" {
  #  most_recent = true
  owners = ["amazon", "self"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20231207"]
  }
}

data "aws_region" "current" {}

resource "aws_instance" "be" {
  ami           = data.aws_ami.official_ubuntu.id
  instance_type = var.be_instance_type
}

resource "aws_instance" "fe" {
  ami           = data.aws_ami.official_ubuntu.id
  instance_type = var.fe_instance_type
}
