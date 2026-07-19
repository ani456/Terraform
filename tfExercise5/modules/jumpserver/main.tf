resource "aws_instance" "jumpserver" {
  instance_type               = var.instance_type
  ami                         = data.aws_ami.ubuntu.id
  vpc_security_group_ids      = [var.jumpserver_sg_id]
  subnet_id                   = var.jumpserver_subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name    = var.instance_name
    project = "jumpserver"
  }

}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
    ##for this go in the ami section in public filter search of ami-<id of the ami>
  }
  owners = ["099720109477"] ##Canonical is offical ami owner 
}




