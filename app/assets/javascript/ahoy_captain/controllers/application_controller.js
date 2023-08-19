import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    window.comboboxConnected = 0;
    if (new URLSearchParams(window.location.search).get('period') === 'realtime') {
      this.element.querySelectorAll('turbo-frame').forEach((frame) => {
        setInterval(() => {
          frame.reload();
        }, 1000 * 30);
      });
    }

    document.querySelectorAll('a[data-turbo-frame]').forEach(link => {
      const frameSelector = link.dataset.turboFrame;
      const frame = document.querySelector(`turbo-frame#${frameSelector}`);
      if(frame) {
        const src = frame.src;
        if(link.href.includes(src)) {
          link.classList.add('text-primary', 'font-semibold')
        }
      }

    })
  }

  comboboxInit(event) {
    if(event.detail.combobox.selectTarget.id === "property-name" || event.detail.combobox.selectTarget.id === "property-value") {
      window.comboboxConnected += 1;
    }
  }

}
