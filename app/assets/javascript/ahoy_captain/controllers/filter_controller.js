import {Controller} from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

export default class extends Controller {
  static values = {
    url: String,
    column: String
  };
  static targets = ["select", 'predicate'];

  connect() {
    this.selectTargets.forEach(async (target) => {
      const url = target.dataset.filterUrlValue;
      const optionsSearch = this.fetchOptions(url, target);
      await new SlimSelect({
        select: target,
        data: [],
        settings: {
          contentPosition: 'relative',
          contentLocation: target.closest('fieldset'),
          searchText: 'Sorry, no results found',
          searchPlaceholder: 'Type to populate results',
          placeholderText: `Search for ${target.dataset.filterColumnValue}`,
          searchHighlight: true
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
    return () => {
      const otherFilters = this.selectTargets.filter(filter => filter != target);
      otherFilters.forEach(async target => {
        if (this.#hasData(target)) {
          const selected = target.slim.getSelected()
          target.slim.setData(selected.map(text => ({ text })))
          // setting data triggers a slim render, so need to also set selected again
          target.slim.setSelected(selected)
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

  #filtersForQuery() {
    const predicates = this.predicateTargets.map(el => ({name: el.name, column_predicate: el.value}));
    const filterValues = this.selectTargets.map(el => ({name: el.name, selections: el.slim.getSelected()}));
    const mergedData = predicates.map(predicate => {
      const matchingFilter = filterValues.find(filter => filter.name === predicate.name);
      if (matchingFilter.selections.length > 0) {
        return {...predicate, ...matchingFilter}
      }
    }).filter(el => el !== undefined);
    return mergedData;
  }

  applyFilters(e) {
    e.preventDefault();
    const searchParams = new URLSearchParams(window.location.search);
    const filters = this.#filtersForQuery();
    filters.forEach(filter => {
      filter.selections.forEach(selection => {
        searchParams.append(`q[${filter.column_predicate}][]`,selection);
      })
    });
    Turbo.visit(window.location.pathname.replace(/\/$/, "")  + `?${searchParams.toString()}`)
  }
}
