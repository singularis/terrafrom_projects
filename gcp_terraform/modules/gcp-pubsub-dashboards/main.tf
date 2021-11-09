resource "google_monitoring_dashboard" "pubSub-dashboards" {
    dashboard_json = <<EOF
{
  "displayName": "${var.team} [${var.studio}] Pub/Sub ${var.topic_id} [${var.resources_preffix}]",
  "gridLayout": {
    "columns": "${var.column_count}",
    "widgets": [
      %{ for index, widget in local.final_dashboard}
      {
        "title": "${widget.title}",
        "xyChart": {
          "dataSets": [{ 
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "${widget.query}",
                "aggregation": {
                  "alignmentPeriod": "${local.alignmentPeriod_default}",
                  "perSeriesAligner": "${widget.aligner}"
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
      %{ if (index + 1) != length(local.final_dashboard) }${format("%s", ",")}%{ endif }
      %{ endfor }
    ]
  }
}
EOF
}