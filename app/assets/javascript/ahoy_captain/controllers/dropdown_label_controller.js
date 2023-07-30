import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label"]

  setLabel(event) {
    this.labelTarget.innerText = event.target.innerText;
  }
}
