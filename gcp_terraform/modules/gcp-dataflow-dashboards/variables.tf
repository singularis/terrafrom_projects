variable "gcp_project_id" {
    description = "GCP project ID for module implementation"
    type = string
}

variable "studio" {
    type = string
}

variable "team" {
    type = string
}

variable "name" {
    type = string
}

variable "job_name" {
    type = string
}


variable "resources_preffix" {
    type=string
}

variable "dataflow_log_base_preffix" {
  type=string
}

variable "column_count" {
    description = "Count of columns in dashboard"
    type = string
}