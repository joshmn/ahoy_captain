import {Controller} from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

export default class extends Controller {
  static values = {
    url: String,
    column: String
  };
  static targets = ["select"];

  connect() {
    this.selectTargets.forEach(async (target) => {
      const url = target.dataset.filterUrlValue;
      const optionsSearch = this.fetchOptions(url, target);
      const select = await new SlimSelect({
        select: target,
        data: [],
        settings: {
          contentPosition: 'relative',
          contentLocation: target.closest('fieldset'),
        },
        events: {
          beforeOpen: async () => {
            if (!this.#hasData(target) & !this.#hasSelections(target) ) {
              const data = await optionsSearch();
              target.slim.setData(data);
            }
          },
          search: async (search, currentData) => {
            const data = await optionsSearch(search);
            const filteredData = data.filter(item => !currentData.some((selectedItem) => selectedItem.text == item.text ))
            return filteredData;
          },
          beforeChange: this.#beforeChange(target, url),
        }
      });
    })
  }

  fetchOptions(url, target) {
    return async (search) => {
      const query = this.#buildQueryFilters(search, target);
      const response = await fetch(`${url}?${query.toString()}`);
      const data = await response.json();
      return data;
    }
  }

  #buildQueryFilters(search, target) {
    const query = new URLSearchParams(window.location.search);
    const otherFilters = this.selectTargets.filter(filter => filter != target);
    otherFilters.forEach(function(filter) {
      filter.slim.getSelected().forEach(val => {
        query.append(`${filter.name}[]`, val);
      })
    });
    query.set(`q[${target.dataset.filterColumnValue}_i_cont]`, search || "");
    return query;
  }

  #beforeChange(target, url) {
    return (newVal, oldVal) => {
        const otherFilters = this.selectTargets.filter(filter => filter != target);
        otherFilters.forEach(async target => {
          if (this.#hasData(target)) {
            target.slim.setData(target.slim.getSelected().map(text => ({ text })))
          }
        })
      return true;
    }
  }

  #hasData(target) {
    return target.slim.getData().length !== 0;
  }

  #hasSelections(target) {
    return target.slim.getSelected().length !== 0;
  }


}
