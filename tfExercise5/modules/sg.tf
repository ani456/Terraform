#sg for instance
resource "aws_security_group" "instance-sg" {
  vpc_id = aws_vpc.poneglyph1-vpc.id
  name   = "instance-sg"

  ingress {
    description     = "Allow HTTP traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    description     = "Allow SSH traffic from jumpserver"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jumpserver-sg.id]
  }

  ingress {
    description = "Allow loadbalancer traffice on port 5000"
    ##fro m_port and to_port are the same because we want to allow traffic on a single port, 5000
    ##these are used to define a range of ports
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }
}


#sg for ALB
resource "aws_security_group" "alb-sg" {
  vpc_id = aws_vpc.poneglyph1-vpc.id
  name   = "alb-sg"

  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS traffic from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" ##when protocol is -1, aws ignores the port range i.e all ports and allows all traffic
    cidr_blocks = ["10.1.0.0/16"]
  }
}

##sg for rds
resource "aws_security_group" "rds-sg" {
  vpc_id = aws_vpc.poneglyph1-vpc.id
  name   = "rds-sg"

  ingress {
    description     = "Allow MySQL traffic from instance-sg"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.instance-sg.id]
  }

  ingress {
    description     = "Allow mysql traffic from jumpserver"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.jumpserver-sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" ##when protocol is -1, aws ignores the port range i.e all ports and allows all traffic
    cidr_blocks = ["10.1.0.0/16"]
  }
}


##sg for jumpserver

resource "aws_security_group" "jumpserver-sg" {
  vpc_id = aws_vpc.poneglyph1-vpc.id
  name   = "jumpserver-sg"

  ingress {
    description = "Allow SSH traffic from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" ##when protocol is -1, aws ignores the port range i.e all ports and allows all traffic
    cidr_blocks = ["10.1.0.0/16"]
  }
}
