import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  handleReset(event) {
    event.preventDefault();
    const openModal = document.querySelector('dialog.modal[open]');
    openModal.querySelectorAll('input, select').forEach(element => {
      element.value = ""
    });
    openModal.close()
    this.element.requestSubmit()
  }
}
