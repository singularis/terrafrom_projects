locals {
    query_list={
    "${var.team} [${var.studio} ${var.name}] Composer Unhealthy [${var.resources_preffix}]" = {
        query = "fetch cloud_composer_environment | metric 'composer.googleapis.com/environment/healthy' | filter (resource.environment_name == '${var.environment_name}') | group_by 5m, [value_healthy_count_true: count_true(value.healthy)] | every 5m | condition val() > ${var.default_thresholds.unhealthy_composers} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.unhealthy_composers ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] Composer tasks failed [${var.resources_preffix}]" = {
        query = "fetch cloud_composer_environment | metric 'composer.googleapis.com/environment/finished_task_instance_count' | filter (resource.environment_name == '${var.environment_name}') && (metric.state == 'failed') | group_by 5m, [row_count: row_count()] | every 5m | condition val() > ${var.default_thresholds.tasks_failed} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.tasks_failed ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] Composer workflow failed [${var.resources_preffix}]" = {
        query = "fetch cloud_composer_workflow | metric 'composer.googleapis.com/workflow/run_count' | filter (resource.workflow_name == '${var.workflow_name_reg}') && (metric.state == 'failed') | group_by 5m, [row_count: row_count()] | every 5m | condition val() > ${var.default_thresholds.workflow_failed} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.workflow_failed ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] Composer count of workers to low [${var.resources_preffix}]" = {
        query = "fetch cloud_composer_environment | metric 'composer.googleapis.com/environment/num_celery_workers' | filter (resource.environment_name == '${var.environment_name}') | group_by 5m, [value_num_celery_workers_aggregate: aggregate(value.num_celery_workers)] | every 5m | condition val() > ${var.default_thresholds.count_of_workers_to_low} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.count_of_workers_to_low ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] Composer database CPU usage to hight [${var.resources_preffix}]" = {
        query = "fetch cloud_composer_environment | metric 'composer.googleapis.com/environment/database/cpu/utilization' | filter (resource.environment_name == '${var.environment_name}') | group_by 5m, [value_utilization_max: max(value.utilization)] | every 5m | condition val() > ${var.default_thresholds.db_high_cpu} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.db_high_cpu ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] Composer database Disk usage to hight [${var.resources_preffix}]" = {
        query = "fetch cloud_composer_environment | metric 'composer.googleapis.com/environment/database/disk/utilization' | filter (resource.environment_name == '${var.environment_name}') | group_by 5m, [value_utilization_max: max(value.utilization)] | every 5m | condition val() > ${var.default_thresholds.db_high_disk} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.db_high_disk ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] Composer database unhealthy [${var.resources_preffix}]" = {
        query = "fetch cloud_composer_environment | metric 'logging.googleapis.com/user/${var.environment_name}-${var.gcp_region}-web-health' | filter (resource.environment_name == '${var.environment_name}') | group_by 5m, [row_count: row_count()] | every 5m | condition val() > ${var.default_thresholds.db_unhealthy} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.db_unhealthy ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] Composer pods evicted [${var.resources_preffix}]" = {
        query = "fetch cloud_composer_environment | metric 'composer.googleapis.com/environment/worker/pod_eviction_count' | filter (resource.environment_name == '${var.environment_name}') | group_by 5m, [value_pod_eviction_count_max: max(value.pod_eviction_count)] | every 5m | condition val() > ${var.default_thresholds.pods_evicted} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.db_high_disk ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] Composer Web Server RAM usage to hight [${var.resources_preffix}]" = {
        query = "fetch cloud_composer_environment | metric 'composer.googleapis.com/environment/web_server/memory/bytes_used' | filter (resource.environment_name == '${var.environment_name}') | group_by 5m, [value_utilization_max: max(value.bytes_used)] | every 5m | condition val() > ${var.default_thresholds.web_server_ram} 'By'",
        is_alert_enabled = var.is_individual_alerts_enabled.web_server_ram ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] Composer Web Server CPU usage time to hight [${var.resources_preffix}]" = {
        query = "fetch cloud_composer_environment | metric 'composer.googleapis.com/environment/web_server/cpu/usage_time' | filter (resource.environment_name == '${var.environment_name}') | group_by 5m, [value_utilization_max: max(value.usage_time)] | every 5m | condition val() > ${var.default_thresholds.web_server_cpu} 's'",
        is_alert_enabled = var.is_individual_alerts_enabled.web_server_cpu ? var.is_alerts_enabled : false
    },
    #Composer GKE cluster monitoring
    #Node level
    "${var.team} [${var.studio} ${var.name}] composer - CPU usage is too high on GKE node [${var.resources_preffix}]" = {
        query = "fetch k8s_node | metric 'kubernetes.io/node/cpu/allocatable_utilization' | filter (resource.cluster_name == '${var.gke_cluster_name}' && resource.node_name =~ '${var.gke_node_pool}') | group_by 1m, [value_allocatable_utilization_max: max(value.allocatable_utilization)] | every 1m | group_by [resource.node_name], [value_allocatable_utilization_max_max:  max(value_allocatable_utilization_max)] | condition val() > ${var.default_thresholds.cpu_gke_node} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.cpu_node_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] composer - RAM usage is too high on GKE node [${var.resources_preffix}]" = {
        query = "fetch k8s_node | metric 'kubernetes.io/node/memory/allocatable_utilization' | filter (resource.cluster_name == '${var.gke_cluster_name}' && resource.node_name =~ '${var.gke_node_pool}') && (metric.memory_type == 'non-evictable') | group_by 1m, [value_allocatable_utilization_max: max(value.allocatable_utilization)] | every 1m | group_by [resource.node_name], [value_allocatable_utilization_max_max:  max(value_allocatable_utilization_max)] | condition val() > ${var.default_thresholds.ram_gke_node} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.ram_node_enabled ? var.is_alerts_enabled : false
    },
    #Pod level
    "${var.team} [${var.studio} ${var.name}] composer - Volume usage is too high on GKE pod [${var.resources_preffix}]" = {
        query = "fetch k8s_pod | metric 'kubernetes.io/pod/volume/utilization' | filter (metadata.system_labels.node_name =~ '${var.gke_node_pool}') && (resource.cluster_name == '${var.gke_cluster_name}') | group_by 1m, [value_utilization_aggregate: aggregate(value.utilization)] | every 1m | group_by [], [value_utilization_aggregate_aggregate: aggregate(value_utilization_aggregate)] | condition val() > ${var.default_thresholds.volume_gke_pod} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.volume_pode_enabled ? var.is_alerts_enabled : false
    },
    #Container level
    #Application containers
    "${var.team} [${var.studio} ${var.name}] composer - CPU usage is too high on GKE application container [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/cpu/request_utilization' | filter (resource.cluster_name == '${var.gke_cluster_name}' && resource.namespace_name =~ '${var.gke_namespace_name_application_reg}') | group_by 1m, [value_request_utilization_max: max(value.request_utilization)] | every 1m | condition val() > ${var.default_thresholds.cpu_gke_app_container} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.cpu_application_container_enabled ? var.is_alerts_enabled : false

    },
    "${var.team} [${var.studio} ${var.name}] composer - RAM usage is too high on GKE application container [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/memory/limit_utilization' | filter (resource.cluster_name == '${var.gke_cluster_name}' && resource.namespace_name =~ '${var.gke_namespace_name_application_reg}') | group_by 1m, [value_limit_utilization_max: max(value.limit_utilization)] | every 1m | group_by [metric.memory_type], [value_limit_utilization_max_max: max(value_limit_utilization_max)] | condition val() > ${var.default_thresholds.ram_gke_app_container} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.ram_application_container_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] composer - GKE Count of pods is too high [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/uptime' | filter (resource.cluster_name == '${var.gke_cluster_name}' && resource.namespace_name =~ '${var.gke_namespace_name_application_reg}') | group_by 1m, [row_count: row_count()] | every 1m | group_by [], [row_count: row_count()] | condition val() > ${var.default_thresholds.gke_app_containers_count}  '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.pods_count_high_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] composer - GKE Container application restart [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/restart_count' | filter (resource.cluster_name == '${var.gke_cluster_name}' && resource.namespace_name =~ '${var.gke_namespace_name_application_reg}') | align delta(1m) | group_by [], [value_restart_count_max: max(value.restart_count)] | every 1m | condition val() > ${var.default_thresholds.gke_app_containers_restart} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.restart_application_container_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] composer - Error rate is too high on GKE container [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'logging.googleapis.com/log_entry_count' | filter (resource.cluster_name == '${var.gke_cluster_name}' && (metric.severity =~ 'ERROR')) | group_by 1m, [row_count: row_count()] | every 1m | group_by [resource.container_name], [row_count_aggregate: aggregate(row_count)] | condition val() > ${var.default_thresholds.gke_error_rate} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.error_rate_container_high_enabled ? var.is_alerts_enabled : false
    },
    #System containers
    "${var.team} [${var.studio} ${var.name}] composer - CPU usage is too high on GKE system services container [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/cpu/request_utilization' | filter (resource.cluster_name == '${var.gke_cluster_name}' && resource.namespace_name !~ '${var.gke_namespace_name_application_reg}') | group_by 1m, [value_request_utilization_max: max(value.request_utilization)] | every 1m | condition val() > ${var.default_thresholds.cpu_gke_system_container} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.cpu_system_container_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] composer - RAM usage is too high on GKE system services container [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/memory/limit_utilization' | filter (resource.cluster_name == '${var.gke_cluster_name}' && resource.namespace_name !~ '${var.gke_namespace_name_application_reg}') | group_by 1m, [value_limit_utilization_max: max(value.limit_utilization)] | every 1m | group_by [metric.memory_type], [value_limit_utilization_max_max: max(value_limit_utilization_max)] | condition val() > ${var.default_thresholds.ram_gke_system_container} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.ram_system_container_enabled ? var.is_alerts_enabled : false
    },
    "${var.team} [${var.studio} ${var.name}] composer - GKE Container system services restart [${var.resources_preffix}]" = {
        query = "fetch k8s_container | metric 'kubernetes.io/container/restart_count' | filter (resource.cluster_name == '${var.gke_cluster_name}' && resource.namespace_name !~ '${var.gke_namespace_name_application_reg}') | align delta(1m) | group_by [], [value_restart_count_max: max(value.restart_count)] | every 1m | condition val() > ${var.default_thresholds.gke_system_containers_restart} '1'",
        is_alert_enabled = var.is_individual_alerts_enabled.restart_system_container_enabled ? var.is_alerts_enabled : false
    },
    }
    log_base_metric_title = "${var.studio}_${var.team}_${var.composeres_log_base_preffix}_${var.name}_${var.resources_preffix}"
}