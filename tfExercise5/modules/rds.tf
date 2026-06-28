resource "aws_db_subnet_group" "rds_subnet_group" {
  name   = "poneglyph1-rds-subnet-group"
  vpc_id = var.vpc_id
  subnet_ids = [
    aws_subnet.private-subnet-rds1.id,
    aws_subnet.private-subnet-rds2.id
  ]

}


resource "aws_rds_cluster" "poneglyph1-rds" {
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


  ##Credentials
  database_name   = "poneglyph1db"
  master_username = var.db_username
  master_password = var.db_password

  ##Network configuration
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name


}
