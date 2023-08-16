import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['property', "value"];

  connect() {
    this.propertySelect = this.propertyTarget;
    this.valueSelect = this.valueTarget;
    this.propertySelect.addEventListener("change", (event) => {
      if(event.target.value) {
        this.valueSelect.name = `q[properties.${event.target.value}_i_cont]`
        this.valueSelect.slim.setData([])
        this.valueSelect.slim.setSelected(null)
      }
    })

  }

}
