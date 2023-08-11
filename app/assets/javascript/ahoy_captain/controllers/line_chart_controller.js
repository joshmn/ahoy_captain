import { Controller } from '@hotwired/stimulus';
import { getCSS, externalTooltipHandler, dateFormatter } from './charts/chart_utils';

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
    label: String
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
        borderColor: getCSS('--a', 0.3),
        backgroundColor: getCSS('--a', 0.3),
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

    this.chart = new Chart(this.element,
      {
        type: 'line',
        data: {
          labels: Object.keys(this.currentValue),
          datasets: datasets
        },
        options: {
          onClick: onClick,
          scale: {
            ticks: { precision: 0, maxTicksLimit: 8 }
          },
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
              stacked: true,
              ticks: {
                color: getCSS('--bc')
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
                color: getCSS('--bc'),
                callback: (val, idx) => {
                  if(idx % 2 == 0) {
                    const date = Object.keys(this.currentValue)[val];
                    return dateFormatter[this.intervalValue](date)
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
