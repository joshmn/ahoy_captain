import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    data: Object,
    label: String
  }
  connect() {
    new Chart(this.element,
      {
        type: 'line',
        data: {
          labels: Object.keys(this.dataValue),
          datasets: [
            {
              label: this.labelValue,
              data: Object.values(this.dataValue)
            }
          ]
        }
      }
      )
  }
}
