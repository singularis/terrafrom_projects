variable "gcp_all_notification_channels_mail" {
  description = "List of emails and data for notifaction channels"
  type = map(object({
    display_name = string
    type = string
    email_address = string
  }))
}

variable "gcp_all_notification_channels_with_auth" {
  description = "List of auth and data for notifaction channels"
  type = map(object({
    display_name = string
    type = string
    auth_token = string
  }))
}