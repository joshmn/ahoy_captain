import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ["title"]
  setTitle(event) {
    this.titleTarget.innerHTML = event.target.title || event.target.text
  }

}
