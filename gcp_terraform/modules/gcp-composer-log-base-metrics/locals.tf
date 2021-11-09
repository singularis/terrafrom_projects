locals {
    unit                        = "1"
    metric_kind                 = "DELTA"
    value_type                  = "INT64"

    description        = "Severity WARNING, ERROR, CRITICAL for ${var.name}"

    title = "${var.studio}_${var.team}_${var.composeres_log_base_preffix}_${var.name}_${var.resources_preffix}"

    log_base_query = "resource.type=\"cloud_composer_environment\" resource.labels.job_name=~\"job_name\" logName:\"projects/${var.gcp_project_id}/logs/airflow-worker\" textPayload:\"ERROR: NOC - ALERT\" AND NOT textPayload:\"ERROR - Received SIGTERM. Terminating subprocesses.\" AND NOT textPayload:\"Failed on pre-execution callback using <function default_action_log at\" AND NOT (labels.workflow:\"Model_fact_village_activities_hist\" AND textPayload:\"Data too long for column 'value' at row 1\")"
}