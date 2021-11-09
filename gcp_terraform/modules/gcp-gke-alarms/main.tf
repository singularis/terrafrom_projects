module "gcp-alarms" {
    source                    = "../gcp-alarms-generic"
    gcp_project_id            = var.gcp_project_id
    for_each                  = (local.query_list)
    name                      = (each.key)
    query                     = (each.value.query)
    is_alerts_enabled         = (each.value.is_alert_enabled)
    default_duration          = var.default_trasholds.default_duration
    documentation             = var.documentation
    notification_channels     = var.notification_channels 
}