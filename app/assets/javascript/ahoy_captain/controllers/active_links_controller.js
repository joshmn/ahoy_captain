import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ["link"]
  static values = {
    classes: { type: Array, default: ["text-primary", "font-semibold"] }
  }

  connect() {
    this.handleLinkClick = (event) => {
      this.linkTargets.forEach(link => this.classesValue.forEach(klass => link.classList.remove(klass)))
      this.classesValue.forEach(klass => event.target.classList.add(klass))
    }
    this.linkTargets.forEach(link => {
      link.addEventListener('click', this.handleLinkClick)
    })
  }
}
