locals {
    query_list={
    #Node level
    "${var.team} [${var.studio} ${var.name}] - Dataflow - high system lag [${var.resources_preffix}]" = {
        query = "fetch dataflow_job | metric 'dataflow.googleapis.com/job/system_lag' | filter resource.job_name =~ '${var.job_name}' | group_by 1m, [value_system_lag_max: max(value.system_lag)] | every 1m | condition val() > ${var.default_thresholds.high_system_lag} 's'",
        is_alert_enabled = var.is_individual_alerts_enabled.high_system_lag ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - Dataflow - high watermark lag [${var.resources_preffix}]" = {
        query = "fetch dataflow_job | metric 'dataflow.googleapis.com/job/data_watermark_age' | filter resource.job_name =~ '${var.job_name}' | group_by 1m, [value_data_watermark_age_max: max(value.data_watermark_age)] | every 1m | condition val() > ${var.default_thresholds.high_watermark_lag} 's'",
        is_alert_enabled = var.is_individual_alerts_enabled.high_watermark_lag ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - Dataflow - high vCPU count [${var.resources_preffix}]" = {
        query = "fetch dataflow_job | metric 'dataflow.googleapis.com/job/current_num_vcpus' | filter resource.job_name =~ '${var.job_name}' | group_by 1m, [value_current_num_vcpus_max: max(value.current_num_vcpus)] | every 1m | condition val() > ${var.default_thresholds.high_vCPU_count} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.high_vCPU_count ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - Dataflow - low vCPU count [${var.resources_preffix}]" = {
        query = "fetch dataflow_job | metric 'dataflow.googleapis.com/job/current_num_vcpus' | filter resource.job_name =~ '${var.job_name}' | group_by 1m, [value_current_num_vcpus_max: max(value.current_num_vcpus)] | every 1m | condition val() < ${var.default_thresholds.low_vCPU_count} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.low_vCPU_count ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - Dataflow - job failed [${var.resources_preffix}]" = {
        query = "fetch dataflow_job | metric 'dataflow.googleapis.com/job/is_failed' | filter resource.job_name =~ '${var.job_name}' | group_by 1m, [value_is_failed_aggregate: aggregate(value.is_failed)] | every 1m | condition val() > ${var.default_thresholds.jobs_failed} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.jobs_failed ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - Dataflow - job errors during event processing [${var.resources_preffix}]" = {
        query = "fetch dataflow_job | metric 'logging.googleapis.com/user/${local.log_base_metric_title}' | filter (resource.job_name =~ '${var.job_name}') | group_by 1m | every 1m | condition val() > ${var.default_thresholds.errors_during_eventprocess} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.errors_during_eventprocess ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - Dataflow - high elapsed time [${var.resources_preffix}]" = {
        query = "fetch dataflow_job | metric 'dataflow.googleapis.com/job/elapsed_time' | filter resource.job_name =~ '${var.job_name}' | group_by 1m, [value_elapsed_time_max: aggregate(value.elapsed_time)] | every 1m | condition val() > ${var.default_thresholds.high_elapsed_time} 's'",
        is_alert_enabled = var.is_individual_alerts_enabled.high_elapsed_time ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - Dataflow - low elements produced [${var.resources_preffix}]" = {
        query = "fetch dataflow_job | metric 'dataflow.googleapis.com/job/elements_produced_count' | filter resource.job_name =~ '${var.job_name}' | group_by 1m, [row_count: row_count()] | every 1m | group_by [], [row_count_aggregate: aggregate(row_count)] | condition val() < ${var.default_thresholds.low_elements_produced} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.low_elements_produced ? var.is_alerts_enabled : false
    },
    }
      log_base_metric_title = "${var.studio}_${var.team}_${var.dataflow_log_base_preffix}_${var.name}_${var.resources_preffix}"
}