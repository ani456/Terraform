resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "poneglyph1-rds-subnet-group"
  subnet_ids = [
    aws_subnet.private-subnet-rds1.id,
    aws_subnet.private-subnet-rds2.id
  ]

}

###aws_db_instance for plain mysql database for aurora use aws_rds_cluster resource instead
### there are many attributes different for aurora and mysql, for example engine_version, instance_class, storage_type, etc.
## Separate cluster instance (required for Aurora)
## aws_rds_cluster_instance is used to create an instance in the cluster,
## while aws_rds_cluster is used to create the cluster itself. 
##The cluster instance is associated with the cluster and inherits its settings, such as engine version and backup configuration.

resource "aws_db_instance" "poneglyph1-rds" { ###aws_rds_cluster for aurora
  count = var.create_rds ? 1 : 0

  ##Engine and version
  engine         = "mysql"
  engine_version = "8.4.8"

  ##Instance configuration
  identifier        = "database-1"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  ##Backup
  backup_retention_period = 0 //for multi-az deployment, this should be >0
  skip_final_snapshot     = true
  multi_az                = false //make this true for standby replica in another az



  ##Credentials
  db_name  = "test_db"
  username = var.db_username
  password = var.db_password

  ##Network configuration
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible    = false
  port                   = 3306


}

##parameter group is optional if you want to customize the database parameters,
## you can create a parameter group and associate it with the RDS instance.

# resource "aws_db_parameter_group" "poneglyph1-rds-parameter-group" {
#   name   = "poneglyph1-rds-parameter-group"
#   family = "mysql8.0"

#   parameter {
#     name  = "max_connections"
#     value = "200"
#   }

#   parameter {
#     name  = "character_set_server"
#     value = "utf8mb4"
#   }
# }



resource "aws_db_instance" "poneglyph1-rds-replica" {
  count = var.create_rds ? 1 : 0

  identifier          = "database-1-replica"
  replicate_source_db = aws_db_instance.poneglyph1-rds[0].identifier

  instance_class = "db.t3.micro"
  storage_type   = "gp2"

  ## Do NOT set engine, engine_version, db_name, username, password, allocated_storage —
  ## these are inherited from the source instance.

  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds-sg.id]

  ## If replica is in the SAME region, you don't need db_subnet_group_name
  ## (it inherits the source's VPC). Only set it if replicating cross-region
  ## or cross-VPC.

  skip_final_snapshot = true

  ## Replicas can optionally have their own Multi-AZ standby too
  multi_az = false
}
