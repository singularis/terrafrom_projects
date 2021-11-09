locals {
    query_list= [
    #Topic level
    {
        title = "${var.team} [${var.studio} %s] - Forwarding rule - Hight rate of 2xx code [${var.resources_preffix}]",
        query = "fetch https_lb_rule | metric 'loadbalancing.googleapis.com/https/request_count' | filter (resource.forwarding_rule_name == '%s') && (metric.response_code_class == 200) | group_by 1m, [value_request_count_mean: mean(value.request_count)]  | every 1m | group_by [metric.response_code], [value_request_count_mean_aggregate: aggregate(value_request_count_mean)] | condition val() > ${var.default_trasholds.high_rate_2xx_rule} '1'" 
        is_alert_enabled = "%t"
    },
    {
        title = "${var.team} [${var.studio} %s] - Forwarding rule - Low rate of 2xx code [${var.resources_preffix}]",
        query = "fetch https_lb_rule | metric 'loadbalancing.googleapis.com/https/request_count' | filter (resource.forwarding_rule_name == '%s') && (metric.response_code_class == 200) | group_by 1m, [value_request_count_mean: mean(value.request_count)]  | every 1m | group_by [metric.response_code], [value_request_count_mean_aggregate: aggregate(value_request_count_mean)] | condition val() < ${var.default_trasholds.low_rate_2xx_rule} '1'" 
        is_alert_enabled = "%t"
    },
    {
        title = "${var.team} [${var.studio} %s] - Forwarding rule - Hight rate of 4xx and !404 code [${var.resources_preffix}]",
        query = "fetch https_lb_rule | metric 'loadbalancing.googleapis.com/https/request_count' | filter (resource.forwarding_rule_name == '%s') && (metric.response_code != 404 && metric.response_code_class == 400) | group_by 1m, [value_request_count_mean: mean(value.request_count)]  | every 1m | group_by [metric.response_code], [value_request_count_mean_aggregate: aggregate(value_request_count_mean)] | condition val() > ${var.default_trasholds.high_4xx_not_404_rule} '1'" 
        is_alert_enabled = "%t"
    },
    {
        title = "${var.team} [${var.studio} %s] - Forwarding rule - Hight rate of 4xx [${var.resources_preffix}]",
        query = "fetch https_lb_rule | metric 'loadbalancing.googleapis.com/https/request_count' | filter (resource.forwarding_rule_name == '%s') && (metric.response_code == 404) | group_by 1m, [value_request_count_mean: mean(value.request_count)]  | every 1m | group_by [metric.response_code], [value_request_count_mean_aggregate: aggregate(value_request_count_mean)] | condition val() > ${var.default_trasholds.high_4xx_rule} '1'" 
        is_alert_enabled = "%t"
    },
    {
        title = "${var.team} [${var.studio} %s] - Forwarding rule - Hight rate of 5xx code [${var.resources_preffix}]",
        query = "fetch https_lb_rule | metric 'loadbalancing.googleapis.com/https/request_count' | filter (resource.forwarding_rule_name == '%s') && (metric.response_code_class == 500) | group_by 1m, [value_request_count_mean: mean(value.request_count)]  | every 1m | group_by [metric.response_code], [value_request_count_mean_aggregate: aggregate(value_request_count_mean)] | condition val() > ${var.default_trasholds.high_rate_5xx_rule} '1'" 
        is_alert_enabled = "%t"
    },
    ]
    final_queries = flatten([ for fw_rule, is_enabled in var.forwarding_rules_names:
     [ for alert in local.query_list:
       { title = format(alert.title ,fw_rule), query = format(alert.query, fw_rule), is_enabled= tobool(format(alert.is_alert_enabled, is_enabled))} 
     ]
   ])
}
