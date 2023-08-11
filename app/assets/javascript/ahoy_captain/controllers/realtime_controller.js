import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['label'];
  static values = {
    interval: Number
  }
  connect() {
    this.reload = this.reload.bind(this);
    this.setLabel = this.setLabel.bind(this);
    this.labelCount = 0;
    this.reloadInterval = setInterval(this.reload, 1000 * this.intervalValue);
    this.labelInterval = setInterval(this.setLabel, 1000);
  }

  reload() {
    this.element.reload();
    this.labelCount = 0;
  }

  setLabel() {
    this.labelTarget.title = `Last updated ${this.labelCount} seconds ago`;
    this.labelCount += 1;
  }

  disconnect() {
    clearInterval(this.labelInterval);
    clearInterval(this.reloadInterval);
  }
}
