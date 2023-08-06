import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ['toggleable'];
  static values = {
    enable: Boolean
  }

  trigger() {
    if (this.enableValue) {
      this.toggleableTargets.forEach(element => {
        element.classList.toggle('hidden');
      });
    }
  }
}
