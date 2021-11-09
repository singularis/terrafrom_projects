#Nottification channel section is commented until will be solved issue with multiply channels
data "google_monitoring_notification_channel" "notification_channels" {
  for_each = toset(var.notification_channels)
  display_name = (each.value)
}
locals {
  notification_channels_ids = [for notification_channel in data.google_monitoring_notification_channel.notification_channels: notification_channel.id]
}

resource "google_monitoring_alert_policy" "alert_policy" {
    combiner = "OR"
    enabled = var.is_alerts_enabled
    display_name = (var.name)
        conditions {
            display_name = (var.name)
            condition_monitoring_query_language { 
            query = (var.query)
            duration = (var.default_duration)
            }
        }
    documentation {
        content = (var.documentation)
    } 
    notification_channels = local.notification_channels_ids
}