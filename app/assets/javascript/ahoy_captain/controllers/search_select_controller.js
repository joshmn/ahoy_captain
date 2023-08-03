import {Controller} from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

export default class extends Controller {
  static values = {
    query: String,
    url: String,
    selected: Array
  }

  connect() {
    this.search = this.search.bind(this)
    this.select = new SlimSelect({
      select: this.element,
      data: [],
      settings: {
        contentPosition: 'relative',
        contentLocation: this.element.closest('fieldset'),
        searchText: 'Sorry, no results found',
        searchPlaceholder: 'Type to populate results',
        placeholderText: `Search`,
        searchHighlight: true
      },
      events: {
        search: this.search
      }
    });

    if(this.selectedValue.length) {
      this.select.setData(this.selectedValue.map(item => ({ "text": item, "value": item })))
      this.select.setSelected(this.selectedValue)
    }
  }

  async search(query) {
    const searchParams = new URLSearchParams(window.location.search);
    const formData = new FormData(this.element.form);

    let deleted = [];
    for (const [key, value] of formData) {
      if(!deleted.includes(key)) {
        searchParams.delete(key)
        deleted.push(key)
      }

      searchParams.append(key, value)
    }

    searchParams.delete(this.element.name);
    searchParams.set(this.queryValue, query);

    const response = await fetch(`${this.urlValue}?${searchParams.toString()}`);
    const data = await response.json();
    return data;
  }

}
