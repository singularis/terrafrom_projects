resource "google_logging_metric" "log_base_errors" {
  name            = local.title
  description     = local.description
  filter          = local.log_base_query
  metric_descriptor {
    unit          = local.unit
    metric_kind   = local.metric_kind
    value_type    = local.value_type
  }
}