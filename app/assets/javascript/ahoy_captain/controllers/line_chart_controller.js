import { Controller } from '@hotwired/stimulus';
import { getCSS, externalTooltipHandler, dateFormatter, metricFormatter } from './charts/chart_utils';

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
    this.chart = new Chart(this.element,
      {
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
      },
    );
  }

  resize() { this.chart.resize() };
}
