import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['property', "value"];

  connect() {
    this.propertySelect = this.propertyTarget;
    this.valueSelect = this.valueTarget.slim;
    this.propertySelect.addEventListener("change", (event) => {
      if(event.target.value) {
      }
    })
  }

}
