import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ["link", "alt"]
  static values = {
    classes: { type: Array, default: ["text-primary", "font-semibold"] }
  }

  // sometimes the target is not the link itself but a child element, and we want to highlight something other than the
  // link itself.
  // this can be bettered
  connect() {
    this.handleLinkClick = (event) => {
      let link = null;
      if(event.target.tagName === "A") {
        link = event.target;
      } else {
        link = (event.target.closest('a').querySelector('[data-active-links-target="link"]'))
      }
      this.linkTargets.forEach(link => this.classesValue.forEach(klass => link.classList.remove(klass)))
      this.classesValue.forEach(klass => link.classList.add(klass))
    }
    this.linkTargets.forEach(link => {
      link.addEventListener('click', this.handleLinkClick)
    })
    this.altTargets.forEach(target => {
      target.addEventListener('click', this.handleLinkClick)
    })
  }
}
