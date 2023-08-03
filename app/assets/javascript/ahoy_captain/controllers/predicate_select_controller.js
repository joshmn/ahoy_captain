import {Controller} from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

export default class extends Controller {
  static targets = ["select"]

  handleChange(event) {
    this.selectTarget.name = event.target.value
  }
}
