locals {
    unit                        = "1"
    metric_kind                 = "DELTA"
    value_type                  = "INT64"

    description        = "Severity WARNING, ERROR, CRITICAL for ${var.name}"

    title = "${var.studio}_${var.team}_${var.dataflow_log_base_preffix}_${var.name}_${var.resources_preffix}"

    log_base_query = "resource.type=\"dataflow_step\" resource.labels.job_name=~\"job_name\" logName:\"projects/${var.gcp_project_id}/logs/dataflow.googleapis.com%2Fworker\" severity>=WARNING"
}