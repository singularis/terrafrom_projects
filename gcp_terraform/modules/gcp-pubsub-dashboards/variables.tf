variable "gcp_project_id" {
    description = "GCP project ID for module implementation"
    type = string
}

variable "column_count" {
    description = "Count of columns in dashboard"
    type = string
}

variable "studio" {
    type = string
    default     = "PM"
}

variable "team" {
    type = string
    default     = "SRE"
}

variable "name" {
    type = string
}

variable "topic_id" {
    type = string
}

variable "subscriptions_id" {
    type = map(string)
}

variable "pub_sub_log_base_preffix" {
  type=string
}

variable "resources_preffix" {
    type=string
}
