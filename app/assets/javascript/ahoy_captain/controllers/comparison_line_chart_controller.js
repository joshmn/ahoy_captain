import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    current: Object,
    comparedTo: Object,
    label: String
  }

  connect() {
    const getCSS = (varname) => {
      return `hsl(${getComputedStyle(document.documentElement).getPropertyValue(varname)})`
    }

    this.chart = new Chart(this.element,
      {
        type: 'line',
        data: {
          labels: Object.keys(this.currentValue),
          datasets: [
            {
              label: "Current",
              data: Object.values(this.currentValue),
              borderColor: getCSS('--s'),
              backgroundColor: getCSS('--sc'),
              color: getCSS('--sf')
            },
            {
              label: "Compared",
              data: Object.values(this.comparedToValue),
              borderColor: getCSS('--a'),
              backgroundColor: getCSS('--ac'),
              color: getCSS('--af')
            }
          ]
        },
        plugins: {
          colors: {
            forceOverride: true
          }
        }
      },
    );

    window.addEventListener('resize', () => { this.chart.resize() })

    this.element.addEventListener('click', evt => {
      const activePoint = this.chart.getElementsAtEventForMode(evt, 'nearest', { intersect: true }, true);
      if(activePoint[0]) {
        const date = Object.keys(this.dataValue)[activePoints[0].index];
        // do something
      }
    })

  }
}
