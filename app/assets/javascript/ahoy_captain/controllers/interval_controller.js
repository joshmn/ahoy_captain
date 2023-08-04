import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  handleChange(event) {
    const url = new URL(event.target.form.action);
    const interval = event.target.value;
    url.searchParams.set('interval', interval);
    event.target.closest('turbo-frame').src = url.href;
  }
}
