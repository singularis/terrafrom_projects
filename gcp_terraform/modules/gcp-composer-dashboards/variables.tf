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

variable "dashboards_column_count" {
    type        = string
}

variable "resources_preffix" {
    type=string
}

variable "column_count" {
    type=string
}

variable "composeres_log_base_preffix" {
    type=string
}