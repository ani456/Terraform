resource "aws_instance" "web" {
  ami                    = var.ami_id[var.region]
  instance_type          = "t3.micro"
  key_name               = "deployerkey"
  vpc_security_group_ids = [aws_security_group.deployer_sg.id]
  availability_zone      = var.zone
  tags = {
    Name    = "deployer-web"
    project = "deployer"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }
  connection {
    type        = "ssh"
    user        = var.webuser
    private_key = file("deployerkey")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]

  }
}

