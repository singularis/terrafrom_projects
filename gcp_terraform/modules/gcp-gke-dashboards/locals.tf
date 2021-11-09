locals {
  #Default trasholds
  alignmentPeriod_default= "60s"
}

locals {
    #!!!Important. Always use \\\ for shealding, instead of \!!!
    dasboards = {
      pods = {
      list_of_widgets_secondaryAggregation = [
      {
        "title": "Container restarts application [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/restart_count\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "container_name",
        "perSeriesAligner": "ALIGN_DELTA",
        "second_perSeriesAligner": "ALIGN_MAX"
      },
      {
        "title": "Error events on containers [SUM]",
        "query": format("metric.type=\\\"logging.googleapis.com/log_entry_count\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" metric.label.\\\"severity\\\"=monitoring.regex.full_match(\\\"WARNING|ERROR\\\")", var.cluster_name),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "container_name",
        "perSeriesAligner": "ALIGN_SUM",
        "second_perSeriesAligner": "ALIGN_SUM"
      },
      {
        "title": "Error events on pod [SUM]",
        "query": format("metric.type=\\\"logging.googleapis.com/log_entry_count\\\" resource.type=\\\"k8s_pod\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" metric.label.\\\"severity\\\"=monitoring.regex.full_match(\\\"WARNING|ERROR\\\")", var.cluster_name),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "pod_name",
        "perSeriesAligner": "ALIGN_SUM",
        "second_perSeriesAligner": "ALIGN_SUM"
      },
      {
        "title": "Container restarts system [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/restart_count\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"!=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "container_name",
        "perSeriesAligner": "ALIGN_DELTA",
        "second_perSeriesAligner": "ALIGN_MAX"
      },
  ]

  list_of_widgets_filters = [
      #Application container monitoring
      {
        "title": "RAM Utilization per container application [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/memory/limit_utilization\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "CPU Utilization per container application [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/cpu/request_utilization\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Volume utilization per container application [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/ephemeral_storage/used_bytes\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Active Container application [COUNT]",
        "query": format("metric.type=\\\"kubernetes.io/container/uptime\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "aligner": "ALIGN_COUNT"
      },
      {
        "title": "Incoming Bytes per second per pod application [RATE]",
        "query": format("metric.type=\\\"kubernetes.io/pod/network/received_bytes_count\\\" resource.type=\\\"k8s_pod\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "aligner": "ALIGN_RATE"
      },
      {
        "title": "Outcoming Bytes per second per pod application [RATE]",
        "query": format("metric.type=\\\"kubernetes.io/pod/network/sent_bytes_count\\\" resource.type=\\\"k8s_pod\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "aligner": "ALIGN_RATE"
      },
      {
        "title": "CPU Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/cpu/allocatable_utilization\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.cluster_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "RAM Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/memory/allocatable_utilization\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.cluster_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Volume Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/ephemeral_storage/used_bytes\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.cluster_name),
        "aligner": "ALIGN_MAX"
      },
       {
        "title": "CPU Utilization per container system [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/cpu/request_utilization\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"!=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "RAM Utilization per container system [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/memory/limit_utilization\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"!=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Volume utilization per container system [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/container/ephemeral_storage/used_bytes\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"!=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Active Container system [COUNT]",
        "query": format("metric.type=\\\"kubernetes.io/container/uptime\\\" resource.type=\\\"k8s_container\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"!=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "aligner": "ALIGN_COUNT"
      },
    ]
    },
    nodes = {
      list_of_widgets_secondaryAggregation = [
      {
        "title": "Total traffic in cluster [RATE]",
        "query": format("metric.type=\\\"kubernetes.io/pod/network/received_bytes_count\\\" resource.type=\\\"k8s_pod\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "cluster_name",
        "perSeriesAligner": "ALIGN_RATE",
        "second_perSeriesAligner": "ALIGN_SUM"
      },
      {
        "title": "Total traffic out cluster [RATE]",
        "query": format("metric.type=\\\"kubernetes.io/pod/network/sent_bytes_count\\\" resource.type=\\\"k8s_pod\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\" resource.label.\\\"namespace_name\\\"=monitoring.regex.full_match(\\\"%s\\\")", var.cluster_name, var.namespace_name_application_reg),
        "crossSeriesReducer": "REDUCE_SUM",
        "groupByFields": "cluster_name",
        "perSeriesAligner": "ALIGN_RATE",
        "second_perSeriesAligner": "ALIGN_SUM"
      },
  ]

  list_of_widgets_filters = [
      #Application container monitoring
      {
        "title": "CPU Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/cpu/allocatable_utilization\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.cluster_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "RAM Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/memory/allocatable_utilization\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.cluster_name),
        "aligner": "ALIGN_MAX"
      },
      {
        "title": "Volume Utilization per node [MAX]",
        "query": format("metric.type=\\\"kubernetes.io/node/ephemeral_storage/used_bytes\\\" resource.type=\\\"k8s_node\\\" resource.label.\\\"cluster_name\\\"=\\\"%s\\\"", var.cluster_name),
        "aligner": "ALIGN_MAX"
      },
    ]
    }
    }
}