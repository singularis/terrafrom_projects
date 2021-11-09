resource "google_monitoring_dashboard" "gcp-lb-dashboards" {
    dashboard_json = <<EOF
{
  "displayName": "${var.team} [${var.studio}] Load balancer ${var.loadbalancer} [${var.resources_preffix}]",
  "gridLayout": {
    "columns": "${var.column_count}",
    "widgets": [
      %{ for index, widget in local.dashboards_query_list_of_widgets_timeSeriesQueryLanguage}
      {
        "title": "${widget.title}",
        "xyChart": {
          "dataSets": [{ 
            "timeSeriesQuery": {
              "timeSeriesQueryLanguage": "${widget.query}"
            },
            "plotType": "LINE",
            "targetAxis": "Y1"
          }],
          "timeshiftDuration": "0s",
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      }
      %{ if (index) != length(local.dashboards_query_list_of_widgets_timeSeriesQueryLanguage) }${format("%s", ",")}%{ endif }
      %{ endfor }
      %{ for index, widget in local.final_dashboard_of_widgets_filtered}
      {
        "title": "${widget.title}",
        "xyChart": {
          "dataSets": [{ 
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "${widget.query}",
                "aggregation": {
                  "alignmentPeriod": "${local.alignmentPeriod_default}",
                  "perSeriesAligner": "${widget.aligner}",
                  "crossSeriesReducer": "${widget.crossSeriesReducer}"
                }
              },
              "unitOverride": "1"
            },
            "plotType": "LINE",
            "targetAxis": "Y1"
          }],
          "timeshiftDuration": "0s",
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      }
      %{ if (index + 1) != length(local.final_dashboard_of_widgets_filtered) }${format("%s", ",")}%{ endif }
      %{ endfor }
    ]
  }
}
EOF
}