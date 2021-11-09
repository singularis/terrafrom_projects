locals {
  #Default trasholds
  alignmentPeriod_default= "60s"
}

locals {
    #!!!Important. Always use \\\ for shealding, instead of \!!!
    widgets = {
      list_of_widgets_secondaryAggregation = [
      {
        "title": "Container restarts application [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/restart_count\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "container_name",
        "perSeriesAligner": "ALIGN_DELTA",
        "second_perSeriesAligner": "ALIGN_MAX"
      },
      {
        "title": "Error events on containers [SUM]",
        "query": format("metric.type=\\\"logging.googleapis.com/log_entry_count\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" metric.label.\\\"severity\\\"=monitoring.regex.full_match(\\\"WARNING|ERROR\\\")", var.gke_cluster_name),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "container_name",
        "perSeriesAligner": "ALIGN_SUM",
        "second_perSeriesAligner": "ALIGN_SUM"
      },
      {
        "title": "Error events on pod [SUM]",
        "query": format("metric.type=\\\"logging.googleapis.com/log_entry_count\\\" resource.type=\\\"k8s_pod\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" metric.label.\\\"severity\\\"=monitoring.regex.full_match(\\\"WARNING|ERROR\\\")", var.gke_cluster_name),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "pod_name",
        "perSeriesAligner": "ALIGN_SUM",
        "second_perSeriesAligner": "ALIGN_SUM"
      },
      {
        "title": "Container restarts system [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/restart_count\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"!=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "container_name",
        "perSeriesAligner": "ALIGN_DELTA",
        "second_perSeriesAligner": "ALIGN_MAX"
      },
      {
        "title": "Total traffic in cluster [RATE]",
        "query": format("metric.type=\\\"kubernetes.io/pod/network/received_bytes_count\\\" resource.type=\\\"k8s_pod\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "gke_cluster_name",
        "perSeriesAligner": "ALIGN_RATE",
        "second_perSeriesAligner": "ALIGN_SUM"
      },
      {
        "title": "Total traffic out cluster [RATE]",
        "query": format("metric.type=\\\"kubernetes.io/pod/network/sent_bytes_count\\\" resource.type=\\\"k8s_pod\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "gke_cluster_name",
        "perSeriesAligner": "ALIGN_RATE",
        "second_perSeriesAligner": "ALIGN_SUM"
      },
  ]

  list_of_widgets_filters = [
      {
        "title": "Dag failure [SUM]",
        "query": format("metric.type=\\\"logging.googleapis.com/user/%s\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", local.log_base_metric_title, var.environment_name),
        "aligner": "ALIGN_SUM"
      },
      {
        "title": "DB health [COUNT]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/database_health\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_COUNT"
      },
      {
        "title": "Environment health [COUNT]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/healthy\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_COUNT"
      },
      {
        "title": "WebServer health [COUNT]",
        "query": format("metric.type=\\\"logging.googleapis.com/user/%s-%s-web-health\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name, var.gcp_region, var.environment_name),
        "aligner": "ALIGN_COUNT"
      },
      {
        "title": "Worflow failed [SUM]",
        "query": format("metric.type=\\\"composer.googleapis.com/workflow/run_count\\\" resource.type=\\\"cloud_composer_workflow\\\" metric.label.\\\"state\\\"=\\\"failed\\\" resource.label.\\\"workflow_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.workflow_name_reg),
        "aligner": "ALIGN_SUM"
      },
      {
        "title": "Tasks failed [SUM]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/finished_task_instance_count\\\" resource.type=\\\"cloud_composer_environment\\\" metric.label.\\\"state\\\"=\\\"failed\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_SUM"
      },

      #Application container monitoring
      {
        "title": "RAM Utilization per container application [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/memory/limit_utilization\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "CPU Utilization per container application [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/cpu/request_utilization\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Database CPU usage [MAX]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/database/cpu/usage_time\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Database memory usage [MAX]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/database/memory/bytes_used\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Database disk usage [MAX]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/database/disk/bytes_used\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "WebServer CPU usage [MAX]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/web_server/cpu/usage_time\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "WebServer RAM usage [MAX]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/web_server/memory/bytes_used\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Active workers [SUM]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/num_celery_workers\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_SUM"
      },
      {
        "title": "Pods evicted [COUNT]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/worker/pod_eviction_count\\\" resource.type=\\\"cloud_composer_environment\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_COUNT"
      },
      {
        "title": "Tasks completed [SUM]",
        "query": format("metric.type=\\\"composer.googleapis.com/environment/finished_task_instance_count\\\" resource.type=\\\"cloud_composer_environment\\\" metric.label.\\\"state\\\"=\\\"success\\\" resource.label.\\\"environment_name\\\"=\\\"%s\\\"", var.environment_name),
        "aligner": "ALIGN_SUM"
      },
      {
        "title": "DAGs completed [SUM]",
        "query": format("metric.type=\\\"composer.googleapis.com/workflow/run_count\\\" resource.type=\\\"cloud_composer_workflow\\\" metric.label.\\\"state\\\"=\\\"success\\\" resource.label.\\\"workflow_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.workflow_name_reg),
        "aligner": "ALIGN_SUM"
      },

      {
        "title": "Volume utilization per container application [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/ephemeral_storage/used_bytes\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Active Container application [COUNT]",
        "query": format("metric.type=\\\"kubernetes.io/container/uptime\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "aligner": "ALIGN_COUNT"
      },
      {
        "title": "Incoming Bytes per second per pod application [RATE]",
        "query": format("metric.type=\\\"kubernetes.io/pod/network/received_bytes_count\\\" resource.type=\\\"k8s_pod\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "aligner": "ALIGN_RATE"
      },
      {
        "title": "Outcoming Bytes per second per pod application [RATE]",
        "query": format("metric.type=\\\"kubernetes.io/pod/network/sent_bytes_count\\\" resource.type=\\\"k8s_pod\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "aligner": "ALIGN_RATE"
      },
      {
        "title": "CPU Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/cpu/allocatable_utilization\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.gke_cluster_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "RAM Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/memory/allocatable_utilization\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.gke_cluster_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Volume Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/ephemeral_storage/used_bytes\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.gke_cluster_name),
        "aligner": "ALIGN_MAX"
      },
       {
        "title": "CPU Utilization per container system [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/cpu/request_utilization\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"!=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "RAM Utilization per container system [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/memory/limit_utilization\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"!=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Volume utilization per container system [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/ephemeral_storage/used_bytes\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"!=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Active Container system [COUNT]",
        "query": format("metric.type=\\\"kubernetes.io/container/uptime\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"!=monitoring.regex.full_match(\\\"%s\\\")", var.gke_cluster_name, var.gke_namespace_name_application_reg),
        "aligner": "ALIGN_COUNT"
      },
      {
        "title": "CPU Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/cpu/allocatable_utilization\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.gke_cluster_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "RAM Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/memory/allocatable_utilization\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.gke_cluster_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Volume Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/ephemeral_storage/used_bytes\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.gke_cluster_name),
        "aligner": "ALIGN_MAX"
      },
    ]
    }
    log_base_metric_title = "${var.studio}_${var.team}_${var.composeres_log_base_preffix}_${var.name}_${var.resources_preffix}"

}