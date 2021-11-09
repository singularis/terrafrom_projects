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
}

variable "team" {
    type = string
}

variable "name" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "node_pool_reg" {
    type = string
}

variable "namespace_name_application_reg" {
    type = string
}
variable "resources_preffix" {
    type=string
}
