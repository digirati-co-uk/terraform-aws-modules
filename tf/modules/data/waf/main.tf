# Setup table for querying WAF logs. 
# Based on: https://docs.aws.amazon.com/athena/latest/ug/create-waf-table-partition-projection.html
resource "aws_glue_catalog_table" "waf_logs" {
  name          = var.table_name
  database_name = var.database_name
  owner         = "hadoop"
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL                            = "TRUE"
    "projection.enabled"                = "true"
    "projection.log_time.format"        = "yyyy/MM/dd/HH/mm",
    "projection.log_time.interval"      = "1",
    "projection.log_time.interval.unit" = "minutes",
    "projection.log_time.range"         = "${var.log_start_date}/00/00,NOW",
    "projection.log_time.type"          = "date",
    "storage.location.template"         = "${var.waf_logs_location}/$${log_time}"
  }

  partition_keys {
    name = "log_time"
    type = "string"
  }

  storage_descriptor {
    location          = var.waf_logs_location
    number_of_buckets = -1
    input_format      = "org.apache.hadoop.mapred.TextInputFormat"
    output_format     = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"

      parameters = {
        "serialization.format" : "1"
      }
    }

    dynamic "columns" {
      for_each = local.waf_logs_table_columns
      content {
        name = columns.value.name
        type = columns.value.type
      }
    }
  }
}

