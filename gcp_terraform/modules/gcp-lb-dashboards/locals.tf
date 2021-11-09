locals {
  #Default trasholds
  alignmentPeriod_default= "60s"
}

locals {
    #!!!Important. Always use \\\ for shealding, instead of \!!!
    dashboards_query_list_of_widgets_filtered = [
      {
        "title": "Request Count %s rule [SUM]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/request_count\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_SUM"
        "crossSeriesReducer": "REDUCE_SUM"
      },
      {
        "title": "Total Latency %s rule [DELTA]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/total_latencies\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_DELTA"
        "crossSeriesReducer": "REDUCE_MEAN"
      },
      {
        "title": "Request Bytes %s rule [DELTA]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/request_bytes_count\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_RATE"
        "crossSeriesReducer": "REDUCE_SUM"
      },
      {
        "title": "Response Bytes %s rule [DELTA]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/response_bytes_count\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_RATE"
        "crossSeriesReducer": "REDUCE_SUM"
      },
      {
        "title": "Frontend RTT %s rule [DELTA]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/frontend_tcp_rtt\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_DELTA"
        "crossSeriesReducer": "REDUCE_MEAN"
      },
      {
        "title": "Backend Request Count %s rule [DELTA]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/backend_request_count\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_RATE"
        "crossSeriesReducer": "REDUCE_SUM"
      },
      {
        "title": "Backend Request Byte %s rule [DELTA]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/backend_request_bytes_count\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_RATE"
        "crossSeriesReducer": "REDUCE_SUM"
      },
      {
        "title": "Backend Responce Byte %s rule [DELTA]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/backend_response_bytes_count\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_RATE"
        "crossSeriesReducer": "REDUCE_SUM"
      },
      {
        "title": "Backend Latency %s rule [DELTA]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/backend_latencies\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\"",
        "aligner": "ALIGN_DELTA"
        "crossSeriesReducer": "REDUCE_MEAN"
      },
      {
        "title": "4XX and 5XX responce codes %s rule [SUM]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/request_count\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\" metric.label.\\\"response_code_class\\\"!=\\\"0\\\" metric.label.\\\"response_code\\\"!=\\\"200\\\"",
        "aligner": "ALIGN_SUM"
        "crossSeriesReducer": "REDUCE_MAX"
      },
      {
        "title": "Response 2xx  %s rule [SUM]",
        "query": "metric.type=\\\"loadbalancing.googleapis.com/https/request_count\\\" resource.type=\\\"https_lb_rule\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"forwarding_rule_name\\\"=\\\"%s\\\" metric.label.\\\"response_code\\\"=\\\"200\\\"",
        "aligner": "ALIGN_SUM"
        "crossSeriesReducer": "REDUCE_MAX"
      },
    ]

    final_dashboard_of_widgets_filtered = flatten([ for forwarding_rule, status in var.forwarding_rules_names:
     [ for widget in local.dashboards_query_list_of_widgets_filtered:
       { title = format(widget.title, forwarding_rule), query = format(widget.query, var.gcp_project_id, forwarding_rule), aligner=widget.aligner, crossSeriesReducer=widget.crossSeriesReducer} 
     ]
   ])

   dashboards_query_list_of_widgets_timeSeriesQueryLanguage = [
      {
        "title": "5XX Response Ratio by Backend Service",
        "query": format("fetch https_lb_rule::loadbalancing.googleapis.com/https/request_count | filter resource.url_map_name = '%s' && resource.project_id = '%s' | {t_0: filter resource.backend_target_type = 'BACKEND_BUCKET' | map update[resource.backend_name: resource.backend_target_name] | align delta() | filter_ratio_by [resource.url_map_name, resource.project_id, resource.backend_name, resource.backend_target_name], metric.response_code_class = 500; t_1:filter resource.backend_target_type = 'BACKEND_SERVICE' | align delta() | filter_ratio_by [resource.url_map_name, resource.project_id, resource.backend_name, resource.backend_target_name], metric.response_code_class = 500 }| union", var.loadbalancer, var.gcp_project_id),
      },
      {
        "title": "4XX Response Ratio by Backend Service",
        "query": format("fetch https_lb_rule::loadbalancing.googleapis.com/https/request_count | filter resource.url_map_name = '%s' && resource.project_id = '%s' | {t_0: filter resource.backend_target_type = 'BACKEND_BUCKET' | map update[resource.backend_name: resource.backend_target_name] | align delta() | filter_ratio_by [resource.url_map_name, resource.project_id, resource.backend_name, resource.backend_target_name], metric.response_code_class = 400; t_1:filter resource.backend_target_type = 'BACKEND_SERVICE' | align delta() | filter_ratio_by [resource.url_map_name, resource.project_id, resource.backend_name, resource.backend_target_name], metric.response_code_class = 400 }| union", var.loadbalancer, var.gcp_project_id),
      },
   ]
}

