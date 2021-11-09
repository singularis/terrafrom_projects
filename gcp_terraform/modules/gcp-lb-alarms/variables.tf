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

variable "loadbalancer" {
    type = string
}

variable "forwarding_rules_names" {
    type = map(string)
}

variable "notification_channels" {
    type = list(string)
}

variable "documentation" {
    type = string
}

