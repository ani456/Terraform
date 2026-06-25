
##Traget Group for the ALB############################################
resource "aws_lb_target_group" "poneglyph1-tg" {
  name     = "poneglyph1-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.poneglyph1-vpc.id



  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2 ##number of consecutive successful health checks required before considering an unhealthy target healthy
    unhealthy_threshold = 2
    timeout             = 5 ##in seconds, amount of time to wait for a response from the target before considering the health check failed
    interval            = 30
    //success_codes       = "200"
  }

  tags = {
    Name = "poneglyph1-tg"
  }
}

##Application Load Balancer############################################
resource "aws_lb" "poneglyph1-alb" {
  name            = "poneglyph1-alb"
  internal        = false
  security_groups = [aws_security_group.alb-sg.id]
  subnets = [
  aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]
  load_balancer_type = "application"

  tags = {
    Name = "poneglyph1-alb"
  }

}

##Listener for the ALB############################################
resource "aws_lb_listener" "poneglyph1-alb-listener" {
  load_balancer_arn = aws_lb.poneglyph1-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.poneglyph1-tg.arn

  }
}
