locals {
  #Default trasholds
  alignmentPeriod_default= "60s"
}

locals {
    #!!!Important. Always use \\\ for shealding, instead of \!!!
    widgets = {
      list_of_widgets_secondaryAggregation = [
      {
        "title": "Elements Produced (after pubsub batch) [RATE]",
        "query": format("metric.type=\\\"dataflow.googleapis.com/job/elements_produced_count\\\" resource.type=\\\"dataflow_job\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"job_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gcp_project_id, var.job_name),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "job_name",
        "perSeriesAligner": "ALIGN_RATE",
        "second_perSeriesAligner": "ALIGN_MAX"
      }
      ]
  list_of_widgets_filters = [
      {
        "title": "System lag for event-processing [SUM]",
        "query": format("metric.type=\\\"dataflow.googleapis.com/job/system_lag\\\" resource.type=\\\"dataflow_job\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"job_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gcp_project_id, var.job_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Data watermark lag for event-processing [MAX]",
        "query": format("metric.type=\\\"dataflow.googleapis.com/job/data_watermark_age\\\" resource.type=\\\"dataflow_job\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"job_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gcp_project_id, var.job_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Dataflow errors during events processing [SUM]",
        "query": format("metric.type=\\\"logging.googleapis.com/user/%s\\\" resource.type=\\\"dataflow_job\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"job_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", local.log_base_metric_title, var.gcp_project_id, var.job_name),
        "aligner": "ALIGN_SUM"
      },
      {
        "title": "Failed Dataflow jobs [SUM]",
        "query": format("metric.type=\\\"dataflow.googleapis.com/job/is_failed\\\" resource.type=\\\"dataflow_job\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"job_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gcp_project_id, var.job_name),
        "aligner": "ALIGN_SUM"
      },
      {
        "title": "Current number of vCPUs in use [SUM]",
        "query": format("metric.type=\\\"dataflow.googleapis.com/job/current_num_vcpus\\\" resource.type=\\\"dataflow_job\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"job_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gcp_project_id, var.job_name),
        "aligner": "ALIGN_SUM"
      },
      {
        "title": "Elapsed time for job [MAX]",
        "query": format("metric.type=\\\"dataflow.googleapis.com/job/elapsed_time\\\" resource.type=\\\"dataflow_job\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"job_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gcp_project_id, var.job_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Job throughput [RATE]",
        "query": format("metric.type=\\\"dataflow.googleapis.com/job/elements_produced_count\\\" resource.type=\\\"dataflow_job\\\" resource.label.\\\"project_id\\\"=\\\"%s\\\" resource.label.\\\"job_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gcp_project_id, var.job_name),
        "aligner": "ALIGN_RATE"
      }
    ]
    }
      log_base_metric_title = "${var.studio}_${var.team}_${var.dataflow_log_base_preffix}_${var.name}_${var.resources_preffix}"
}