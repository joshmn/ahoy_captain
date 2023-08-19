import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ["link", "alt"]
  static values = {
    classes: { type: Array, default: ["text-primary", "font-semibold"] }
  }

  connect() {
    this.element.addEventListener('click', () => {
      const frame = this.element.dataset.turboFrame;
      const otherLinks = document.querySelectorAll(`[data-turbo-frame="${frame}"]`);
      otherLinks.forEach(link => {
        link.classList.remove('text-primary', 'font-semibold');
      })

      this.element.classList.add("text-primary", "font-semibold")
    })
  }
}
