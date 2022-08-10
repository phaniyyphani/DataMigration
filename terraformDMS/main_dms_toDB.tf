# Database Migration Service requires the below IAM Roles to be created before
# replication instances can be created. See the DMS Documentation for
# additional information: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.APIRole
#  * dms-vpc-role
#  * dms-cloudwatch-logs-role
#  * dms-access-for-endpoint



resource "aws_dms_endpoint" "trg_sql-endpoint" {
  database_name               = "phani"
  endpoint_id                 = "trg-sql-src"
  endpoint_type               = "target"
  engine_name                 = "mysql"
  password                    = "ravi123@PSWD"
  port                        = 3306
  server_name                 = "3.88.62.37"
  ssl_mode                    = "none"
  tags = {
    Name = "test"
  }

  username = "ravi"
}

# Create a new replication task for DB to DB
resource "aws_dms_replication_task" "test_sqlDB" {
  migration_type            = "full-load"
  replication_instance_arn  = aws_dms_replication_instance.dms_instance_ry.replication_instance_arn
  replication_task_id       = "sql-ravi-test-sqlDB"
  source_endpoint_arn       = aws_dms_endpoint.src-endpoint.endpoint_arn
  table_mappings            = file("TableMapping_toDB.json")
  tags = {
    Name = "Task for DB to DB Move"
  }
  target_endpoint_arn = aws_dms_endpoint.trg_sql-endpoint.endpoint_arn
}