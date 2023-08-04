import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    if (new URLSearchParams(window.location.search).get('period') === 'realtime') {
      this.element.querySelectorAll('turbo-frame').forEach((frame) => {
        setInterval(() => {
          frame.reload();
        }, 1000 * 30);
      });
    }
  }
}
