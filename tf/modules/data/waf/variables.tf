locals {
  waf_logs_table_columns = [
    {
      name = "timestamp",
      type = "bigint",
    },
    {
      name = "formatversion",
      type = "int",
    },
    {
      name = "webaclid",
      type = "string",
    },
    {
      name = "terminatingruleid",
      type = "string",
    },
    {
      name = "terminatingruletype",
      type = "string",
    },
    {
      name = "action",
      type = "string",
    },
    {
      name = "terminatingrulematchdetails",
      type = "array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>",
    },
    {
      name = "httpsourcename",
      type = "string",
    },
    {
      name = "httpsourceid",
      type = "string",
    },
    {
      name = "rulegrouplist",
      type = "array<struct<rulegroupid:string,terminatingrule:struct<ruleid:string,action:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>>,nonterminatingmatchingrules:array<struct<ruleid:string,action:string,overriddenaction:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>,challengeresponse:struct<responsecode:string,solvetimestamp:string>,captcharesponse:struct<responsecode:string,solvetimestamp:string>>>,excludedrules:string>>",
    },
    {
      name = "ratebasedrulelist",
      type = "array<struct<ratebasedruleid:string,limitkey:string,maxrateallowed:int>>",
    },
    {
      name = "nonterminatingmatchingrules",
      type = "array<struct<ruleid:string,action:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>,challengeresponse:struct<responsecode:string,solvetimestamp:string>,captcharesponse:struct<responsecode:string,solvetimestamp:string>>>",
    },

    {
      name = "requestheadersinserted"
      type = "array<struct<name:string,value:string>>"
    },
    {
      name = "responsecodesent"
      type = "string"
    },
    {
      name = "httprequest"
      type = "struct<clientip:string,country:string,headers:array<struct<name:string,value:string>>,uri:string,args:string,httpversion:string,httpmethod:string,requestid:string,fragment:string,scheme:string,host:string>"
    },
    {
      name = "labels"
      type = "array<struct<name:string>>"
    },
    {
      name = "captcharesponse"
      type = "struct<responsecode:string,solvetimestamp:string,failurereason:string>"
    },
    {
      name = "challengeresponse"
      type = "struct<responsecode:string,solvetimestamp:string,failurereason:string>"
    },
    {
      name = "ja3fingerprint"
      type = "string"
    },
    {
      name = "ja4fingerprint"
      type = "string"
    },
    {
      name = "oversizefields"
      type = "string"
    },
    {
      name = "requestbodysize"
      type = "int"
    },
    {
      name = "requestbodysizeinspectedbywaf"
      type = "int"
    }
  ]
}

variable "table_name" {
  description = "Name to use for AWS Glue table"
  default     = "waf_logs"
}

variable "database_name" {
  description = "Name of the metadata database where the table metadata resides"
  type        = string
}

variable "waf_logs_location" {
  description = "Full s3:// location where AWF logs are output to (without trailing slash)"
  type        = string
}

variable "log_start_date" {
  description = "Date to start partitioning in format YYYY/MM/DD (date wehn logs started being recorded)"
  type        = string
}
