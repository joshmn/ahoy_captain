import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  handleChange(event) {
    this.selectTarget.dataset.predicate = event.target.value
    this.selectTarget.name = event.target.value
  }
}
