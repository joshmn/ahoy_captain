import {Controller} from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

export default class extends Controller {
  static values = {
    query: String,
    url: String,
    selected: Array
  }

  connect() {
    this.loadedInitialData = false;
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
        beforeOpen: async () => {
          if (!this.loadedInitialData) {
            const data = await this.search("");
            this.select.setData(data);
            this.loadedInitialData = true
          }
        },
        search: this.search
      }
    });

    window.dispatchEvent(new CustomEvent('slim:init', { detail: { id: this.element.id } }))
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
    if(this.urlValue.includes("properties/values")) {
      searchParams.delete(`q[properties.${document.querySelector('#property-name').dataset.column}_in]`)
      searchParams.set(`q[properties.${document.querySelector('#property-name').dataset.column}_i_cont]`, query)
    } else {
      searchParams.set(this.queryValue || this.element.name, query);
    }
    console.log(searchParams.toString())
    const response = await fetch(`${this.urlValue}?${searchParams.toString()}`);
    const data = await response.json();
    return data;
  }

}
