import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  handleChange(event) {
    const url = new URL(event.target.form.action);
    const interval = event.target.value;
    url.searchParams.set('interval', interval);
    event.target.closest('turbo-frame').src = url.href;
    document.querySelectorAll('a[data-turbo-frame="chart"]').forEach(el => {
      const url = new URL(el.href);
      url.searchParams.set('interval', interval);
      el.href = url.href
    })
  }
}
