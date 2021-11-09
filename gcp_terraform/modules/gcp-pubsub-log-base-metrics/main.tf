resource "google_logging_metric" "log_base_errors" {
  for_each        = {for log_base_query in local.final_log_base_set: log_base_query.title => log_base_query}
  name            = each.value.title
  description     = each.value.description
  filter          = each.value.log_base_query
  metric_descriptor {
    unit          = local.unit
    metric_kind   = local.metric_kind
    value_type    = local.value_type
  }
}