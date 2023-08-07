import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter--item"
export default class extends Controller {
  static values = {
    modal: String
  };

  openModal() {
    document.getElementById(this.modalValue).showModal()
  }
}
