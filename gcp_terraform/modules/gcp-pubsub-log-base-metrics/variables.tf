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

variable "topic_id" {
    type = string
}

variable "subscriptions_id" {
    type = map(string)
}

variable "resources_preffix" {
    type=string
}

variable "pub_sub_log_base_preffix" {
  type=string
}