locals {
  #Default period
  alignmentPeriod_default= "60s"
}

locals {
    #!!!Important. Always use \\\ for shealding, instead of \!!!
      dashboards_query_list = [
      #Topic monitoring
      {
        "title": "Errors Subscription %s [RATE]",
        "query": "metric.type=\\\"logging.googleapis.com/user/${var.studio}_${var.team}_${var.pub_sub_log_base_preffix}_%s_${var.resources_preffix}\\\" resource.type=\\\"pubsub_subscription\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_SUM"
      },
      {
        "title": "Unacked messages %s [SUM]",
        "query": "metric.type=\\\"pubsub.googleapis.com/subscription/num_undelivered_messages\\\" resource.type=\\\"pubsub_subscription\\\" resource.label.\\\"subscription_id\\\"=\\\"%s\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_SUM"
      },
      {
        "title": "Oldest unacked message age %s [MAX]",
        "query": "metric.type=\\\"pubsub.googleapis.com/subscription/oldest_unacked_message_age\\\" resource.type=\\\"pubsub_subscription\\\" resource.label.\\\"subscription_id\\\"=\\\"%s\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Acknowledge messages operation %s [RATE]",
        "query": "metric.type=\\\"pubsub.googleapis.com/subscription/pull_ack_message_operation_count\\\" resource.type=\\\"pubsub_subscription\\\" resource.label.\\\"subscription_id\\\"=\\\"%s\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_RATE"
      },
    ]
    final_dashboard = flatten([ for subscription_id, status in var.subscriptions_id:
     [ for widget in local.dashboards_query_list:
       { title = format(widget.title ,subscription_id), query = format(widget.query, subscription_id, var.gcp_project_id), aligner=widget.aligner} 
     ]
   ])

}