import { Controller } from '@hotwired/stimulus';
import { getCSS, externalTooltipHandler } from './charts/chart_utils';

const footer = (tooltipItems) => {
  debugger;
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
    label: String
  }

  connect() {
    this.chart = new Chart(this.element,
      {
        type: 'line',
        data: {
          labels: Object.keys(this.currentValue),
          datasets: [
            {
              label: Object.keys(this.currentValue),
              data: Object.values(this.currentValue),
              borderColor: getCSS('--a'),
              backgroundColor: getCSS('--a'),
              color: getCSS('--bc')
            },
            {
              label: Object.keys(this.comparedToValue),
              data: Object.values(this.comparedToValue),
              borderColor: getCSS('--a', 0.3),
              backgroundColor: getCSS('--a', 0.3),
              color: getCSS('--bc')
            }
          ]
        },
        // plugins: {
        //   colors: {
        //     forceOverride: true
        //   },
        //   legend: {
        //     display: false
        //   },
        //   tooltip: {
        //     callbacks: {
        //       footer: footer,
        //     }
        //   }
        // },
        options: {
          interaction: {
            intersect: false,
            mode: 'index',
          },
          plugins: {
            tooltip: {
              enabled: false,
              position: 'nearest',
              external: externalTooltipHandler
            }
          },
          scales: {
            y: {
              stacked: true,
              ticks: {
                color: getCSS('--bc')
              }
            },
            x: {
              ticks: {
                color: getCSS('--bc'),
                callback: (val, idx) => {
                  const date = Object.keys(this.currentValue)[val]
                  return idx % 2 == 0 ? new Date(date).toLocaleString(
                    'en-US', 
                    { month: 'short', day: 'numeric' }
                  ) : "";
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
