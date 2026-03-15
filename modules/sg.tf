# from_port is the start of the destination port range that is allowed on the resource attached to this security group.
# Together with to_port, it defines the destination port(s) allowed on the backend instance.

resource "aws_security_group" "alb-project1-sg" {

  name        = "alb-project1-sg"
  description = "Security group for public subnet and load balancer"
  vpc_id      = aws_vpc.project1-VPC.id

  ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  ]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


//frontend security group
resource "aws_security_group" "frontend-project1-sg" {

  name   = "frontend-project1-sg"
  vpc_id = aws_vpc.project1-VPC.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-project1-sg.id]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


//backend security group
resource "aws_security_group" "backend-project1-sg" {

  name   = "backend-project1-sg"
  vpc_id = aws_vpc.project1-VPC.id

  egress {
    from_port   = 0 //allows traffic to any port
    to_port     = 0
    protocol    = "-1" //allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//database security group
resource "aws_security_group" "database-project1-sg" {

  name   = "database-project1-sg"
  vpc_id = aws_vpc.project1-VPC.id
}

//security group rules, these are written separately to avoid circular dependencies between security groups.,
//which may lead to errors during terraform apply. Cause both security groups reference each other in their ingress rules,
// which creates a circular dependency. By defining the security group rules separately,
// we can avoid this issue and ensure that the security groups are created successfully without any errors.
resource "aws_security_group_rule" "backend_ingress" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend-project1-sg.id
  source_security_group_id = aws_security_group.frontend-project1-sg.id
}

resource "aws_security_group_rule" "database_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database-project1-sg.id
  source_security_group_id = aws_security_group.backend-project1-sg.id
}
