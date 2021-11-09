resource "google_monitoring_dashboard" "gcp-gke-dashboards_new" {
    dashboard_json = <<EOF
{
  "displayName": "${var.team} [${var.studio}] Dataflow job ${var.name} [${var.resources_preffix}]",
  "gridLayout": {
    "columns": "${var.column_count}",
    "widgets": [
      %{ for index, widget in local.widgets.list_of_widgets_secondaryAggregation}
       {
        "title": "${widget.title}",
        "xyChart": {
          "dataSets": [{ 
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "${widget.query}",
                "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "${widget.crossSeriesReducer}",
                      "groupByFields": [
                        "resource.label.\"${widget.groupByFields}\""
                      ],
                      "perSeriesAligner": "${widget.second_perSeriesAligner}"
                    },
                "aggregation": {
                  "alignmentPeriod": "${local.alignmentPeriod_default}",
                  "perSeriesAligner": "${widget.perSeriesAligner}"
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
      %{ if (index) != length(local.widgets.list_of_widgets_secondaryAggregation) }${format("%s", ",")}%{ endif }
      %{ endfor }
      %{ for index, widget in local.widgets.list_of_widgets_filters}
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
      %{ if (index + 1) != length(local.widgets.list_of_widgets_filters) }${format("%s", ",")}%{ endif }
      %{ endfor }
    ]
  }
}
EOF
}