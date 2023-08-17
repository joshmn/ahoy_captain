import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['name', 'value'];

  connect() {
    this.init = this.init.bind(this)

    const interval = setInterval(() => {
      if(window.comboboxConnected === 2) {
        clearInterval(interval);
        this.init()
      }
    }, 100)
  }

  init() {

    if(this.nameTarget.value) {
      this.valueTarget.combobox.element.dataset.comboboxQueryValue = `q[properties.${this.nameTarget.value}_i_cont]`
    }

    this.nameTarget.addEventListener("change", (event) => {
      if(event.target.value) {
        event.target.dataset.column = event.target.value;
        this.valueTarget.combobox.element.dataset.comboboxQueryValue = `q[properties.${event.target.value}_i_cont]`
        this.valueTarget.combobox.setDisabled(false)
        this.valueTarget.combobox.isOpenValue = false
      } else {
        this.valueTarget.combobox.setSelected([])
        this.valueTarget.combobox.setDisabled(true)
      }
    })
    this.valueTarget.addEventListener("change", (event) => {
      if(event.target.value.length > 0) {
        this.valueTarget.name = `q[properties.${this.nameTarget.dataset.column}_in]`
      } else {
        this.valueTarget.name = null
        this.valueTarget.combobox.element.dataset.comboboxQueryValue = ""
      }
    })

  }

}
