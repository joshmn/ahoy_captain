import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['property', "value"];

  connect() {
    this.found = [];
    const init = () => {
      console.log("init")
      this.propertySelect = this.propertyTarget;
      this.valueSelect = this.valueTarget;
      this.propertySelect.addEventListener("change", (event) => {
        if(event.target.value) {
          event.target.dataset.column = event.target.value;
          this.valueSelect.name = `q[properties.${event.target.value}_i_cont]`
          this.valueSelect.slim.setData([])
          this.valueSelect.slim.setSelected(null)
        }
      })
      this.valueSelect.addEventListener("change", (event) => {
        if(event.target.value.length > 0) {
          this.valueSelect.name = `q[properties.${this.propertySelect.dataset.column}_in]`
        }
      })
    }
    window.addEventListener('slim:init', (event) => {
      if(event.detail.id === "property-value" || event.detail.id === "property-name") {
        this.found.push(event.detail.id);
      }

      console.log(this.found)
      if(this.found.length === 2) {
        init()
      }
    })

  }

}
