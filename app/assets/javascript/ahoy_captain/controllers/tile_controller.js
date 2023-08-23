import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ["title"]
  connect() {
    this.frame = this.element.querySelector('turbo-frame');
    const targetNode = this.frame;
    const config = { attributes: true };

    const callback = (mutationList, observer) => {
      for (const mutation of mutationList) {
        if (mutation.type === "attributes") {
          this.handleFrameLoad(mutation.attributeName)
        }
      }
    };

    const observer = new MutationObserver(callback);
    observer.observe(targetNode, config);
  }

  handleFrameLoad(status) {
    if(!this.frame.hasAttribute('skeleton')) {
      if(status === 'busy') {
        this.frame.innerHTML = document.querySelector('#tile-loader-template').innerHTML;
      }
    }
  }

  setTitle(event) {
    this.titleTarget.innerHTML = event.target.title || event.target.text
  }
}
