import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    data: Object,
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
          labels: Object.keys(this.dataValue),
          datasets: [
            {
              label: this.labelValue,
              data: Object.values(this.dataValue),
              borderColor: getCSS('--s'),
              backgroundColor: getCSS('--sc'),
              color: getCSS('--sf')
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
