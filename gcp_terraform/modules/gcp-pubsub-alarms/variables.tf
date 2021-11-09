variable "gcp_project_id" {
    type = string
}

variable "gcp_region" {
    description = "GCP region for alarm implementation"
    type = string
}

variable "studio" {
    type = string
}

variable "team" {
    type = string
}

variable "dashboards_column_count" {
    type        = string
}

variable "resources_preffix" {
    type=string
}

variable "default_trasholds" {
  type = map
}

variable "is_alerts_enabled" {
    type = bool
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

variable "notification_channels" {
    type = list(string)
}

variable "documentation" {
    type = string
}

variable "pub_sub_log_base_preffix" {
  type=string
}

