locals {
  alb_logs_table_columns = [
    {
      name = "type",
      type = "string",
    },
    {
      name = "time",
      type = "string",
    },
    {
      name = "elb",
      type = "string",
    },
    {
      name = "client_ip",
      type = "string",
    },
    {
      name = "client_port",
      type = "int",
    },
    {
      name = "target_ip",
      type = "string",
    },
    {
      name = "target_port",
      type = "int",
    },
    {
      name = "request_processing_time",
      type = "double",
    },
    {
      name = "target_processing_time",
      type = "double",
    },
    {
      name = "response_processing_time",
      type = "double",
    },
    {
      name = "elb_status_code",
      type = "string",
    },
    {
      name = "target_status_code",
      type = "string",
    },
    {
      name = "received_bytes",
      type = "bigint",
    },
    {
      name = "sent_bytes",
      type = "bigint",
    },
    {
      name = "request_verb",
      type = "string",
    },
    {
      name = "request_url",
      type = "string",
    },
    {
      name = "request_proto",
      type = "string",
    },
    {
      name = "user_agent",
      type = "string",
    },
    {
      name = "ssl_cipher",
      type = "string",
    },
    {
      name = "ssl_protocol",
      type = "string",
    },
    {
      name = "target_group_arn",
      type = "string",
    },
    {
      name = "trace_id",
      type = "string",
    },
    {
      name = "domain_name",
      type = "string",
    },
    {
      name = "chosen_cert_arn",
      type = "string",
    },
    {
      name = "matched_rule_priority",
      type = "string",
    },
    {
      name = "request_creation_time",
      type = "string",
    },
    {
      name = "actions_executed",
      type = "string",
    },
    {
      name = "redirect_url",
      type = "string",
    },
    {
      name = "new_field",
      type = "string",
    }
  ]
}

variable "table_name" {
  description = "Name to use for AWS Glue table"
  default     = "lb_logs"
}

variable "database_name" {
  description = "Name of the metadata database where the table metadata resides"
}

variable "loadbalancer_logs_location" {
  description = "Full s3:// location where ALB logs are output to (without trailing slash)"
}