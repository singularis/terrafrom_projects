locals {
   query_list = [    #Topic level
    {
        title = "${var.team} [${var.studio} %s] - Cloud Pub/Sub Subscription - Unacked messages [${var.resources_preffix}]",
        query = "fetch pubsub_subscription | metric 'pubsub.googleapis.com/subscription/num_undelivered_messages' | filter (resource.subscription_id == '%s') | group_by 1m, [value_num_undelivered_messages_aggregate: aggregate(value.num_undelivered_messages)]  | every 1m | condition val() > ${var.default_trasholds.subscriptions_unacked_messages} '1'",
        is_alert_enabled = "%t"
    },
    {
        title = "${var.team} [${var.studio} %s] - Cloud Pub/Sub Subscription - Acknowledge message operations [${var.resources_preffix}]",
        query = "fetch pubsub_subscription | metric 'pubsub.googleapis.com/subscription/pull_ack_message_operation_count' | filter (resource.subscription_id == '%s') | group_by 1m, [value_pull_ack_message_operation_count: aggregate(value.pull_ack_message_operation_count)]  | every 1m | condition val() < ${var.default_trasholds.acknowledge_message_operations} '1'",
        is_alert_enabled = "%t"
    },
    {
        title = "${var.team} [${var.studio} %s] - Cloud Pub/Sub Subscription - Dead letter message [${var.resources_preffix}]",
        query = "fetch pubsub_subscription | metric 'pubsub.googleapis.com/subscription/dead_letter_message_count' | filter (resource.subscription_id == '%s') | group_by 1m, [value_dead_letter_message_count: aggregate(value.dead_letter_message_count)]  | every 1m | condition val() > ${var.default_trasholds.dead_letter_message} '1'", 
        is_alert_enabled = "%t"
    },
    {
         title = "${var.team} [${var.studio} %s] - Cloud Pub/Sub Subscription - Errors[${var.resources_preffix}]", 
         query = "fetch pubsub_subscription | metric 'logging.googleapis.com/user/${var.studio}_${var.team}_${var.pub_sub_log_base_preffix}_%s_${var.resources_preffix}' | group_by 1m  | every 1m | condition val() > ${var.default_trasholds.errors} '1'",
         is_alert_enabled = "%t" 
    }
    ]
    final_queries = flatten([ for subscription_id, is_enabled in var.subscriptions_id:
     [ for alert in local.query_list:
       { title = format(alert.title ,subscription_id), query = format(alert.query, subscription_id), is_enabled= tobool(format(alert.is_alert_enabled, is_enabled))} 
     ]
   ])
}