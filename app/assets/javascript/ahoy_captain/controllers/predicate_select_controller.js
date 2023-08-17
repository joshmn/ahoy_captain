import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  handleChange(event) {
    this.selectTarget.name = event.target.value
  }
}
