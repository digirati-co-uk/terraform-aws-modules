# Setup table for querying ELB logs. 
# Based on: https://docs.aws.amazon.com/athena/latest/ug/application-load-balancer-logs.html
# NOTE - this was created via a query in Athena then imported
resource "aws_glue_catalog_table" "lb_logs" {
  name          = var.table_name
  database_name = var.database_name
  owner         = "hadoop"
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL                       = "TRUE"
    "projection.enabled"           = "true"
    "projection.day.type"          = "date"
    "projection.day.range"         = "2024/01/01,NOW"
    "projection.day.format"        = "yyyy/MM/dd"
    "projection.day.interval"      = "1"
    "projection.day.interval.unit" = "DAYS"
    "storage.location.template"    = "${var.loadbalancer_logs_location}/$${day}"
    "transient_lastDdlTime"        = "1717767997"
  }

  storage_descriptor {
    location          = var.loadbalancer_logs_location
    number_of_buckets = -1
    input_format      = "org.apache.hadoop.mapred.TextInputFormat"
    output_format     = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.RegexSerDe"

      parameters = {
        "input.regex" : "([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) ([^ ]*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\"($| \"[^ ]*\")(.*)"
        "serialization.format" : "1"
      }
    }

    dynamic "columns" {
      for_each = local.alb_logs_table_columns
      content {
        name = columns.value.name
        type = columns.value.type
      }
    }
  }
}

