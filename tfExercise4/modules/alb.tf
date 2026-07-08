resource "aws_lb" "external-project1-alb" {
  name               = "project1-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.alb_subnet1_az1.id, aws_subnet.alb_subnet1_az2.id]
  security_groups    = [aws_security_group.alb-project1-sg.id]

}

resource "aws_lb_target_group" "frontend-tg" {
  name        = "frontend-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.project1-VPC.id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    path                = "/" //the path at which application or server is running 
    protocol            = "HTTP"
    matcher             = "200"
  }
}




resource "aws_lb_listener" "external-alb-listener" {
  load_balancer_arn = aws_lb.external-project1-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-tg.arn
  }
}





resource "aws_lb" "project1-internal-alb" {
  name               = "project1-internal-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = [aws_subnet.pri_backend_az1.id, aws_subnet.pri_backend_az2.id]
  security_groups    = [aws_security_group.alb-project1-sg.id]
}


resource "aws_lb_target_group" "backend-tg" {
  name     = "backend-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.project1-VPC.id

  health_check {
    path     = "/"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "backend-alb-listener" {
  load_balancer_arn = aws_lb.project1-internal-alb.arn
  port              = 80
  protocol          = "HTTP" //here we are using HTTP protocol for internal load balancer cause we chose application load balancer 
  //if we had chosen network load balancer then we would have used TCP protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-tg.arn
  }
}
