import { Controller } from '@hotwired/stimulus';

export default class extends Controller {

  // reverts the modal back to its original state if it was simply closed
  connect() {
    const targetNode = this.element;
    const config = { attributes: true, childList: false, subtree: false };
    const callback = (mutationList, observer) => {
      for (const mutation of mutationList) {
        if(mutation.attributeName === "open") {
          if(this.element.open) {
            if(!this.originalValues) {
              this.originalValues = {};
              const formElements = this.element.querySelectorAll('select');
              formElements.forEach(el => {
                if(el.combobox) {
                  this.originalValues[el.id] = el.combobox.selectedValue;
                } else {
                  this.originalValues[el.id] = el.value;
                }
              })
            }
          } else {
            const formElements = this.element.querySelectorAll('select');
            formElements.forEach(el => {
              if(this.originalValues[el.id]) {
                if(el.combobox) {
                  el.combobox.setSelected(this.originalValues[el.id])
                } else {
                  el.value = this.originalValues[el.id]
                }
              }
            })
          }
        }
      }
    };

    const observer = new MutationObserver(callback);
    observer.observe(targetNode, config);
  }


}
