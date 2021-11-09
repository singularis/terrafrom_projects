locals {
    query_list={
    #Node level
    "${var.team} [${var.studio} ${var.name}] - CPU usage is too high on GKE node [${var.resources_preffix}]" = {
        query = "fetch k8s_node | metric 'kubernetes.io/node/cpu/allocatable_utilization' | filter (resource.cluster_name == '${var.cluster_name}' && resource.node_name =~ '${var.node_pool_reg}') | group_by 1m, [value_allocatable_utilization_max: max(value.allocatable_utilization)] | every 1m | group_by [resource.node_name], [value_allocatable_utilization_max_max:  max(value_allocatable_utilization_max)] | condition val() > ${var.default_trasholds.cpu_gke_node} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.cpu_node_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - RAM usage is too high on GKE node [${var.resources_preffix}]" = {
        query = "fetch k8s_node | metric 'kubernetes.io/node/memory/allocatable_utilization' | filter (resource.cluster_name == '${var.cluster_name}' && resource.node_name =~ '${var.node_pool_reg}') && (metric.memory_type == 'non-evictable') | group_by 1m, [value_allocatable_utilization_max: max(value.allocatable_utilization)] | every 1m | group_by [resource.node_name], [value_allocatable_utilization_max_max:  max(value_allocatable_utilization_max)] | condition val() > ${var.default_trasholds.ram_gke_node} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.ram_node_enabled ? var.is_alerts_enabled : false
    },
    #Pod level
    "${var.team} [${var.studio} ${var.name}] - Volume usage is too high on GKE pod [${var.resources_preffix}]" = {
        query = "fetch k8s_pod | metric 'kubernetes.io/pod/volume/utilization' | filter (metadata.system_labels.node_name =~ '${var.node_pool_reg}') && (resource.cluster_name == '${var.cluster_name}') | group_by 1m, [value_utilization_aggregate: aggregate(value.utilization)] | every 1m | group_by [], [value_utilization_aggregate_aggregate: aggregate(value_utilization_aggregate)] | condition val() > ${var.default_trasholds.volume_gke_pod} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.volume_pode_enabled ? var.is_alerts_enabled : false
    },
    #Container level
    #Application containers
    "${var.team} [${var.studio} ${var.name}] - CPU usage is too high on GKE application container [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/cpu/request_utilization' | filter (resource.cluster_name == '${var.cluster_name}' && resource.namespace_name =~ '${var.namespace_name_application_reg}') | group_by 1m, [value_request_utilization_max: max(value.request_utilization)] | every 1m | condition val() > ${var.default_trasholds.cpu_gke_app_container} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.cpu_application_container_enabled ? var.is_alerts_enabled : false

    },
    "${var.team} [${var.studio} ${var.name}] - RAM usage is too high on GKE application container [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/memory/limit_utilization' | filter (resource.cluster_name == '${var.cluster_name}' && resource.namespace_name =~ '${var.namespace_name_application_reg}') | group_by 1m, [value_limit_utilization_max: max(value.limit_utilization)] | every 1m | group_by [metric.memory_type], [value_limit_utilization_max_max: max(value_limit_utilization_max)] | condition val() > ${var.default_trasholds.ram_gke_app_container} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.ram_application_container_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - GKE Count of pods is too high [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/uptime' | filter (resource.cluster_name == '${var.cluster_name}' && resource.namespace_name =~ '${var.namespace_name_application_reg}') | group_by 1m, [row_count: row_count()] | every 1m | group_by [], [row_count: row_count()] | condition val() > ${var.default_trasholds.gke_app_containers_count}  '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.pods_count_high_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - GKE Container application restart [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/restart_count' | filter (resource.cluster_name == '${var.cluster_name}' && resource.namespace_name =~ '${var.namespace_name_application_reg}') | align delta(1m) | group_by [], [value_restart_count_max: max(value.restart_count)] | every 1m | condition val() > ${var.default_trasholds.gke_app_containers_restart} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.restart_application_container_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - Error rate is too high on GKE container [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'logging.googleapis.com/log_entry_count' | filter (resource.cluster_name == '${var.cluster_name}' && (metric.severity =~ 'ERROR')) | group_by 1m, [row_count: row_count()] | every 1m | group_by [resource.container_name], [row_count_aggregate: aggregate(row_count)] | condition val() > ${var.default_trasholds.gke_error_rate} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.error_rate_container_high_enabled ? var.is_alerts_enabled : false
    },
    #System containers
    "${var.team} [${var.studio} ${var.name}] - CPU usage is too high on GKE system services container [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/cpu/request_utilization' | filter (resource.cluster_name == '${var.cluster_name}' && resource.namespace_name !~ '${var.namespace_name_application_reg}') | group_by 1m, [value_request_utilization_max: max(value.request_utilization)] | every 1m | condition val() > ${var.default_trasholds.cpu_gke_system_container} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.cpu_system_container_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - RAM usage is too high on GKE system services container [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/memory/limit_utilization' | filter (resource.cluster_name == '${var.cluster_name}' && resource.namespace_name !~ '${var.namespace_name_application_reg}') | group_by 1m, [value_limit_utilization_max: max(value.limit_utilization)] | every 1m | group_by [metric.memory_type], [value_limit_utilization_max_max: max(value_limit_utilization_max)] | condition val() > ${var.default_trasholds.ram_gke_system_container} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.ram_system_container_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] - GKE Container system services restart [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/restart_count' | filter (resource.cluster_name == '${var.cluster_name}' && resource.namespace_name !~ '${var.namespace_name_application_reg}') | align delta(1m) | group_by [], [value_restart_count_max: max(value.restart_count)] | every 1m | condition val() > ${var.default_trasholds.gke_system_containers_restart} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.restart_system_container_enabled ? var.is_alerts_enabled : false
    },
    }
}