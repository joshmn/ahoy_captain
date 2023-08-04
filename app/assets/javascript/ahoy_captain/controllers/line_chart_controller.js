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
    Chart.register(Chart.Colors)

    new Chart(this.element,
      {
        type: 'line',
        data: {
          labels: Object.keys(this.dataValue),
          datasets: [
            {
              label: this.labelValue,
              data: Object.values(this.dataValue),
              borderColor: getCSS('--p'),
              backgroundColor: getCSS('--af'),
              color: getCSS('--pc')
            }
          ]
        },
        plugins: {
          colors: {
            forceOverride: true
          }
        }
      },
    )
  }
}
