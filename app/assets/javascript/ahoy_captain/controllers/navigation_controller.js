import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.queryString = new URLSearchParams(window.location.search);
    this.baseURL = window.location.pathname.replace(/\/$/, '');
  }

  navigate() {
    const url = `${this.baseURL}?${this.queryString.toString()}`;
    Turbo.visit(url, { action: 'replace' });
  }

  addQueryParam({ detail: { paramKey, paramValue } }) {
    this.queryString.append(paramKey, paramValue);
  }

  removeQueryParam({ detail: { paramKey, paramValue } }) {
    if (!this.queryString.has(paramKey)) {
      paramKey += '[]';
    }
    this.queryString.delete(paramKey, paramValue);
    this.navigate();
  }
}
