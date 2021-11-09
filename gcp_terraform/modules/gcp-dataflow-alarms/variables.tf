variable "gcp_project_id" {
    type = string
}

variable "gcp_region" {
    description = "GCP region for alarm implementation"
    type = string
    default     = "us-central1"
}

variable "studio" {
    type = string
}

variable "team" {
    type = string
}

variable "is_alerts_enabled" {
    type = bool
}

variable "is_individual_alerts_enabled" {
  type = map(string)
}

variable "name" {
    type = string
}

variable "job_name" {
    type = string
}

variable "notification_channels" {
    type = list(string)
}

variable "documentation" {
    type = string
}

variable "dashboards_column_count" {
    type        = string
}

variable "resources_preffix" {
    type=string
}

variable "default_thresholds" {
  description = "Dataflow alerts default values"
  type = map
}

variable "dataflow_log_base_preffix" {
  type=string
}