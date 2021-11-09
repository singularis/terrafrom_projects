output "email_output" {
  #Output of JSON data for email channels
  value = google_monitoring_notification_channel.gcp_email_channel
}

output "auth_output" {
  #Output of JSON data for authls channels
  value = google_monitoring_notification_channel.gcp_auth_channel
}