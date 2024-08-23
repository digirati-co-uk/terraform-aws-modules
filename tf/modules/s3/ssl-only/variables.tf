variable "bucket" {
  description = "Id of bucket to apply policy too"
  type        = string
}

variable "source_policy_documents" {
  description = " List of IAM policy documents that are merged together into the exported document (see TF docs)"
  default     = null
  type        = list(string)
}

variable "override_policy_documents" {
  description = " List of IAM policy documents that are merged together into the exported document (see TF docs)"
  default     = null
  type        = list(string)
}
