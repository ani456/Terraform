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
  vpc_zone_identifier = [
    aws_subnet.private-subnet-instance1,
    aws_subnet.private-subnet-instance2
  ]
  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  target_group_arns = [aws_lb_target_group.poneglyph1-tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 180

  ## "EC2" (default if you don't set it)
  ## The ASG only checks the EC2 instance's own status checks — basically "is the VM running and responding at the hypervisor/OS level."
  ## As long as the instance is powered on and passing basic system checks, the ASG considers it healthy — even if your application inside it has crashed or is returning 500 errors.
  ## "ELB" (what I set)
  ## The ASG also checks the load balancer's target group health checks — the same health check your ALB/NLB uses to decide whether to route traffic to that instance (e.g. hitting /health and expecting a 200). 
  ## If your app is unresponsive, hung, or failing its health check endpoint — even though the EC2 instance itself is technically "running" — the ASG will mark it unhealthy and terminate + replace it.
  default_cooldown = 180

  tag {
    key                 = "Name"
    value               = "poneglyph1-asg-instance"
    propagate_at_launch = true
  }
  lifecycle { ##Without it (default behavior is destroy-then-create)
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "poneglyph1-scale-up-policy" {
  name                   = "poneglyph1-scale-up-policy"
  autoscaling_group_name = aws_autoscaling_group.poneglyph1-asg.name ##asg doesn't have ID so name is the primary identifier
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0

  }


}
