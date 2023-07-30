import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label", "close"]

  setLabel(event) {
    this.labelTarget.innerText = event.target.innerText;
    this.closeTarget.classList.add('hidden');
  }

  removeHidden(event) {
    this.closeTarget.classList.remove('hidden');
  }
}
