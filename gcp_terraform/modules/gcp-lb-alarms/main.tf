module "forwarding_rules-alarms" {
    source                    = "../gcp-alarms-generic"
    gcp_project_id            = var.gcp_project_id
    for_each                  = {for query in local.final_queries: query.title => query}
    name                      = (each.value.title)
    query                     = (each.value.query)
    is_alerts_enabled         = (each.value.is_enabled ? var.is_alerts_enabled : false) 
    default_duration          = var.default_trasholds.default_duration
    documentation             = var.documentation
    notification_channels     = var.notification_channels 
}