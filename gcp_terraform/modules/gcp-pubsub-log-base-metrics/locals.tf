locals {
    unit                        = "1"
    metric_kind                 = "DELTA"
    value_type                  = "INT64"
    description_template        = "Severity WARNING, ERROR, CRITICAL for"
    
    log_base_data_list = [
        {
           title = "${var.studio}_${var.team}_${var.pub_sub_log_base_preffix}_%s_${var.resources_preffix}"
           log_base_query       = "resource.type=\"pubsub_subscription\" resource.labels.subscription_id=\"projects/%s/subscriptions/%s\" severity>=WARNING"
           description          = "${local.description_template} %s" 
        }
    ]
    final_log_base_set = flatten([ for subscription_id, alert in var.subscriptions_id:
     [ for metric in local.log_base_data_list:
       { title = format(metric.title ,subscription_id), log_base_query = format(metric.log_base_query, var.gcp_project_id, subscription_id), description=format(metric.description, subscription_id)} 
     ]
   ])
}