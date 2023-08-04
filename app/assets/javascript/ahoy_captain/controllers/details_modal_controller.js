import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    target: String,
  };

  connect() {
    this.modal = document.querySelector('#detailsModal');
    this.turboFrame = document.querySelector('#detailsModal turbo-frame');
  }

  openModal(e) {
    e.preventDefault();
    this.modal.showModal();
    this.turboFrame.src = document.querySelector(this.targetValue).src;
  }
}
