import { Controller } from '@hotwired/stimulus';
import { getCSS, externalTooltipHandler, dateFormatter, metricFormatter } from 'helpers/chart_utils';

const calculatePercentageDifference = function(oldValue, newValue) {
  if(!oldValue) { return false }
  if (oldValue == 0 && newValue > 0) {
    return 100
  } else if (oldValue == 0 && newValue == 0) {
    return 0
  } else {
    return Math.round((newValue - oldValue) / oldValue * 100)
  }
}

const footer = (tooltipItems) => {
  let sum = 0;

  tooltipItems.forEach(function(tooltipItem) {
    sum += tooltipItem.parsed.y;
  });
  return 'Sum: ' + sum;
};

export default class extends Controller {
  static values = {
    current: Object,
    comparedTo: Object,
    interval: String,
    label: String,
    metric: String,
    comparison: String
  }

  connect() {
    const onClick = (e) => {
      if(drag) { return }
      const element = this.chart.getElementsAtEventForMode(e, 'index', { intersect: false })[0];
      const searchParams = new URLSearchParams(window.location.search);

      searchParams.delete('period')
      searchParams.delete('start_date')
      searchParams.delete('end_date')
      searchParams.delete('compare_to_start_date')
      searchParams.delete('compare_to_end_date')
      searchParams.set('date', Object.keys(this.currentValue)[element.index])

      Turbo.visit(window.location.pathname + "?" + searchParams.toString())
    }
    const datasets = [
      {
        label: Object.keys(this.currentValue),
        data: Object.values(this.currentValue),
        borderColor: getCSS('--a'),
        backgroundColor: getCSS('--a'),
        color: getCSS('--bc'),
        yAxisID: 'y',
      }
    ]

    if(this.hasComparedToValue) {
      datasets.push({
        label: Object.keys(this.comparedToValue),
        data: Object.values(this.comparedToValue),
        borderColor: getCSS('--s', 0.8),
        backgroundColor: getCSS('--s', 0.8),
        color: getCSS('--bc'),
        yAxisID: 'yComparison',
      })
    }

    const calculateMaximumY = function(dataset) {
      if (dataset) {
        return Math.max(Object.values(dataset))
      } else {
        return 1
      }
    }

    const typeForDate = this.comparisonValue === 'year' ? 'long' : "short"
    const options = {
        type: 'line',
        data: {
          labels: Object.keys(this.currentValue),
          datasets: datasets
        },
        options: {
          onClick: onClick,
          responsive: true,
          maintainAspectRatio: false,
          interaction: {
            intersect: false,
            mode: 'index',
          },
          plugins: {
            legend: false,
            tooltip: {
              enabled: false,
              position: 'nearest',
              external: externalTooltipHandler(this)
            }
          },
          scales: {
            y: {
              min: 0,
              suggestedMax: calculateMaximumY(this.currentValue),
              ticks: {
              },
              grid: {
                zeroLineColor: 'transparent',
                drawBorder: false,
              }
            },
            yComparison: {
              min: 0,
              suggestedMax: calculateMaximumY(this.currentValue),
              display: false,
              grid: { display: false },
            },
            x: {
              ticks: {
                grid: { display: false },

                color: getCSS('--bc'),
                callback: (val, idx) => {
                  if(idx % 2 == 0) {
                    const date = Object.keys(this.currentValue)[val];
                    return dateFormatter[this.intervalValue](date, typeForDate)
                  } else {
                    return ""
                  }

                }
              }
            }
          },
          elements: {
            point: {
              radius: 0
            }
          }
        }
      }
    this.chart = new Chart(this.element, options);


    var canvas = this.element;
    var overlay = document.getElementById('overlay');
    var startIndex = 0;
    overlay.width = canvas.width;
    overlay.height = canvas.height;
    var selectionContext = overlay.getContext('2d');
    var selectionRect = {
      w: 0,
      startX: 0,
      startY: 0
    };
    var drag = false;
    canvas.addEventListener('pointerdown', evt => {
      const points = this.chart.getElementsAtEventForMode(evt, 'index', {
        intersect: false
      });

      startIndex = points[0].index;
      const rect = canvas.getBoundingClientRect();
      selectionRect.startX = evt.clientX - rect.left;
      selectionRect.startY = this.chart.chartArea.top;
      drag = true;
    });
    canvas.addEventListener('pointermove', evt => {
      const rect = canvas.getBoundingClientRect();
      if (drag) {

        const rect = canvas.getBoundingClientRect();
        selectionContext.fillStyle = getCSS('--p')
        selectionRect.w = (evt.clientX - rect.left) - selectionRect.startX;
        selectionContext.globalAlpha = 0.5;
        selectionContext.clearRect(0, 0, canvas.width, canvas.height);
        selectionContext.fillRect(selectionRect.startX,
          selectionRect.startY,
          selectionRect.w,
          this.chart.chartArea.bottom - this.chart.chartArea.top);
      } else {
        selectionContext.clearRect(0, 0, canvas.width, canvas.height);
        var x = evt.clientX - rect.left;
        if (x > this.chart.chartArea.left) {
          selectionContext.fillStyle = getCSS('--p')
          selectionContext.fillRect(x,
            this.chart.chartArea.top,
            1,
            this.chart.chartArea.bottom - this.chart.chartArea.top);
        }
      }
    });
    canvas.addEventListener('pointerup', evt => {
      const points = this.chart.getElementsAtEventForMode(evt, 'index', {
        intersect: false
      });
      const dates = [options.data.labels[startIndex], options.data.labels[points[0].index]].sort()
      const searchParams = new URLSearchParams(window.location.search);
      searchParams.set('start_date', dates[0])
      searchParams.set('end_date', dates[1])
      searchParams.delete('period')
      searchParams.delete('compare_to_start_date')
      searchParams.delete('compare_to_end_date')
      Turbo.visit(window.location.pathname + "?" + searchParams.toString())
    });
  }

  formatLabel(label) {
    return dateFormatter[this.intervalValue](label, 'long')
  }

  formatMetric(value) {
    return metricFormatter[this.metricValue](value)
  }

  resize() { this.chart.resize() };

  extractTooltipData(tooltip) {
    const data = this.chart.config.data.datasets.find((set) => set.yAxisID == "y")
    const comparisonData = this.chart.config.data.datasets.find((set) => set.yAxisID == "yComparison");
    const dataIndex = this.chart.config.data.datasets.indexOf(data)
    const comparisonDataIndex = this.chart.config.data.datasets.indexOf(comparisonData);

    const tooltipData = tooltip.dataPoints.find((dataPoint) => dataPoint.datasetIndex == dataIndex)
    const label = data.label[tooltipData.dataIndex];
    let comparisonLabel = false
    let comparisonValue = false
    let comparisonLabelBackgroundColor = false
    if(this.hasComparedToValue) {
      const tooltipComparisonData = tooltip.dataPoints.find((dataPoint) => dataPoint.datasetIndex == comparisonDataIndex);
      comparisonLabel = comparisonData.label[tooltipComparisonData.dataIndex];
      comparisonValue = tooltip.dataPoints.find((dataPoint) => dataPoint.datasetIndex == comparisonDataIndex)?.raw || 0
      comparisonLabelBackgroundColor = comparisonData.backgroundColor
    }

    const value = tooltip.dataPoints.find((dataPoint) => dataPoint.datasetIndex == dataIndex)?.raw || 0

    return {
      comparison: this.hasComparedToValue,
      comparisonDifference: calculatePercentageDifference(comparisonValue, value),
      metric: this.labelValue,
      label: this.formatLabel(label),
      labelBackgroundColor: data.backgroundColor,
      formattedValue: this.formatMetric(value),
      comparisonLabel: this.formatLabel(comparisonLabel),
      comparisonLabelBackgroundColor: comparisonLabelBackgroundColor,
      formattedComparisonValue: this.formatMetric(comparisonValue)
    }
  }
}
