import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ["link"]
  connect() {
    this.handleLinkClick = (event) => {
      this.linkTargets.forEach(link => link.classList.remove('text-primary', 'font-semibold'))
      event.target.classList.add('text-primary', 'font-semibold')
    }
    this.linkTargets.forEach(link => {
      link.addEventListener('click', this.handleLinkClick)
    })
  }
}
