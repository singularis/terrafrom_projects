#Email notification topics
resource "google_monitoring_notification_channel" "gcp_email_channel" {
  for_each = (var.gcp_all_notification_channels_mail)
  display_name = each.key
  type         = each.value.type
  labels = {
    email_address =each.value.email_address
  }
}

#For topics with auth keys
resource "google_monitoring_notification_channel" "gcp_auth_channel" {
  for_each = (var.gcp_all_notification_channels_with_auth)
  display_name = each.key
  type         = each.value.type
  labels = {
    "channel_name" = each.value.display_name
  }
  sensitive_labels {
    auth_token = each.value.auth_token
  }
}