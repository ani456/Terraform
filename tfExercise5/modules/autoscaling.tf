data "aws_ami" "poneglyph1-ami" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "poneglyph-ami"
    values = ["poneglyph-ami*"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_key_pair" "ssh-key" {

  filter {
    name   = "Linux-key"
    values = ["Linux-key"]
  }

}

resource "aws_launch_template" "poneglyph1-lt" {
  image_id             = data.aws_ami.poneglyph1-ami.id
  instance_type        = "t3.micro"
  security_group_names = [aws_security_group.instance-sg.name]
  key_name             = data.aws_key_pair.ssh-key.key_name

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "poneglyph1-asg-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "poneglyph1-asg" {
  name = "poneglyph1-asg"
  launch_template {
    id      = aws_launch_template.poneglyph1-lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.private-subnet-instance1, aws_subnet.private-subnet-instance2]
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2

  availability_zone_distribution {

  }

}
