resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "poneglyph1-rds-subnet-group"
  subnet_ids = [
    aws_subnet.private-subnet-rds1.id,
    aws_subnet.private-subnet-rds2.id
  ]

}

###aws_db_instance for plain mysql database for aurora use aws_rds_cluster resource instead
### there are many attributes different for aurora and mysql, for example engine_version, instance_class, storage_type, etc.
resource "aws_db_instance" "poneglyph1-rds" {
  count = var.create_rds ? 1 : 0

  ##Engine and version
  engine         = "mysql"
  engine_version = "8.4.8"

  ##Instance configuration
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  backup_retention_period = 7
  skip_final_snapshot     = true
  multi_az                = false


  ##Credentials
  db_name  = "poneglyph1db"
  username = var.db_username
  password = var.db_password

  ##Network configuration
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible    = false
  port                   = 3306

}
