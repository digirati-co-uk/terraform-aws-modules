# Setup table for querying Cloudwatch logs
# Based on: https://docs.aws.amazon.com/athena/latest/ug/cloudfront-logs.html
resource "aws_glue_catalog_table" "cloudfront_logs_catalog_table" {
  name          = var.table_name
  database_name = var.database_name

  parameters = {
    EXTERNAL                 = "TRUE"
    "skip.header.line.count" = "2"
  }

  storage_descriptor {
    location      = var.cloudfront_logs_location
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "serde"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" : "\t"
        "serialization.format" : "\t"
      }
    }

    dynamic "columns" {
      for_each = local.cloudfront_logs_table_columns
      content {
        name = columns.value.name
        type = columns.value.type
      }
    }
  }
}