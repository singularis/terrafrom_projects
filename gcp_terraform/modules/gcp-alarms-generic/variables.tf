variable "gcp_project_id" {
    type = string
}

variable "is_alerts_enabled" {
    type = bool
}
variable "name" {
    type = string
}
variable "query" {
    type = string
}

variable "default_duration" {
    type = string
}

variable "documentation" {
    type = string
}

variable "notification_channels" {
    type = list(string)
}

