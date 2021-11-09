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

variable "is_alerts_enabled" {
    type = bool
}

variable "is_individual_alerts_enabled" {
  type = map(string)
}


variable "name" {
    type = string
}

variable "environment_name" {
    type = string
}

variable "workflow_name_reg" {
    type = string
}

variable "gke_cluster_name" {
    type = string
}

variable "gke_node_pool" {
    type = string
}

variable "gke_namespace_name_application_reg" {
    type = string
}


variable "notification_channels" {
    type = list(string)
}

variable "documentation" {
    type = string
}

variable "resources_preffix" {
    type=string
}

variable "composeres_log_base_preffix" {
    type=string
}

variable "default_thresholds" {
  description = "Composer alerts default values"
  type = map
}