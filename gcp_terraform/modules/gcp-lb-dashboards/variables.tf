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

variable "forwarding_rules_names" {
    type = map(string)
}

variable "loadbalancer" {
    type = (string)
}

variable "resources_preffix" {
    type=string
}
