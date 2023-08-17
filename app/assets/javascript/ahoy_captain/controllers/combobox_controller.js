import { Controller } from "@hotwired/stimulus";
import "classnames"

const debounce = (func, delay) => {
  let debounceTimer
  return function() {
    const context = this
    const args = arguments
    clearTimeout(debounceTimer)
    debounceTimer = setTimeout(() => func.apply(context, args), delay)
  }
}

export default class extends Controller {
  static targets = ["input", "list", "option", "container", "select", "highlighted", "box", "selected"];
  static classes = ["boxOpen"]
  static values = {
    options: Array,
    isLoading: Boolean,
    isOpen: Boolean,
    input: String,
    highlightedIndex: Number,
    singleOption: Boolean,
    freeChoice: Boolean,
    selected: Array,
    url: String,
    query: String
  };

  connect() {
    this.isLoadingValue = false;
    this.isOpenValue = false;
    this.inputValue = '';
    this.highlightedIndexValue = 0;

    this.inputTarget.addEventListener('keydown', this.onKeyDown.bind(this))
    this.debouncedFetchOptions = debounce(this.fetchOptions.bind(this), 250);
    this.checkDisabledState();
    if(this.singleOptionValue) {
      this.selectTarget.removeAttribute('multiple')
    } else {
      this.selectTarget.multiple = true
    }
  }

  checkDisabledState() {
    if (this.isDisabledValue) {
      this.containerTarget.classList.add('opacity-30', 'cursor-default', 'pointer-events-none');
    }
  }

  onInput(event) {
    this.inputValue = event.target.value;
    this.debouncedFetchOptions(this.inputValue);
  }

  fetchOptions(query) {
    this.isLoadingValue = true;
    this.isOpenValue = true;

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

    fetch(`${this.urlValue}?${searchParams.toString()}`).then(resp => resp.json()).then(loadedOptions => {
      this.isLoadingValue = false;
      this.highlightedIndexValue = 0;
      this.optionsValue = loadedOptions.map(option => ({ text: option.text, value: option.text }));
    });
  }

  highlight(element) {
    const index =  parseInt(element.target.dataset.index);
    this.highlightIndex(index)
  }

  scrollToOption(index) {
    const optionElement = this.listTarget.querySelector(`[data-index="${index}"]`);
    if (optionElement) {
      optionElement.scrollIntoView({ block: 'center' });
    }
  }

  highlightIndex(index) {
    this.highlightedIndexValue = index;
    this.scrollToOption(index);
  }

  onKeyDown(event) {
    switch (event.key) {
      case 'Enter':
        if (!this.isOpenValue || this.isLoadingValue || this.optionTargets.length === 0) return;
        const option = this.listTarget.querySelector(`[data-index="${this.highlightedIndexValue}"]`);
        if(option) {
          this.selectOption(option);
        }

        event.preventDefault();
        break;
      case 'Escape':
        if (!this.isOpenValue || this.isLoadingValue) return;
        this.isOpenValue = false;
        this.inputTarget.focus();
        event.preventDefault();
        break;
      case 'ArrowDown':
        if(this.isOpenValue) {
          this.highlightIndex(this.highlightedIndexValue + 1)
        } else {
          this.isOpenValue = true
        }
        break;
      case 'ArrowUp':
        if(this.isOpenValue) {
          this.highlightIndex(this.highlightedIndexValue - 1)
        } else {
          this.isOpenValue = true
        }
        break;
    }
  }

  selectOption(selected) {
    let value = null;
    if(selected.tagName) {
      value = selected.dataset.value;
      if(value === undefined) {
        value = selected.parentElement.dataset.value
      }
    } else {
      value = selected.target.dataset.value;
      if(value === undefined) {
        value = selected.target.parentElement.dataset.value
      }
    }

    const option = this.optionsValue.filter(option => option.value === value)[0];
    if(this.singleOptionValue) {
      console.log("only one")
      this.selectedValue = [option]
    } else {
      this.selectedValue = [...this.selectedValue, option]
    }
    this.isOpenValue = false;
    this.inputValue = '';
    this.highlightedIndexValue = 0
  }

  toggleOpen() {
    if (!this.isOpenValue) {
      this.debouncedFetchOptions(this.inputValue);
      this.inputTarget.focus();
    } else {
      this.inputValue = '';
      this.isOpenValue = false;
    }
  }

  isOpenValueChanged(current) {
    if(current) {
      this.boxTarget.classList.add(...this.boxOpenClasses)
    } else {
      this.boxTarget.classList.remove(...this.boxOpenClasses)

    }
    this.listTarget.style.display = current ? 'block' : 'none';
  }

  highlightedIndexValueChanged(current, previous) {
    const prev = this.listTarget.querySelector(`[data-index="${previous}"]`)
    if(prev) {
      prev.classList.remove('bg-primary-600', 'text-white')
    }
    const now = this.listTarget.querySelector(`[data-index="${current}"]`);
    if(now) {
      now.classList.add('bg-primary-600', 'text-white')
    }
  }

  renderDropDownContent() {
    this.listTarget.innerHTML = "";

    const visibleOptions = this.visibleOptions()
    const matchesFound = visibleOptions.length > 0 && visibleOptions.some(option => !this.isOptionDisabled(option))

    if (matchesFound) {
      return this.renderOptions(visibleOptions.filter(option => !this.isOptionDisabled(option)))
    }

    if(this.isLoadingValue) {
      this.listTarget.innerHTML = `<div>Is Loading..</div>`
      return
    }

    if(this.freeChoiceValue) {
      this.listTarget.innerHTML = `<div class="relative cursor-default select-none py-2 px-4 text-gray-700 dark:text-gray-300">Start typing to apply filter</div>`
      return
    }

    this.listTarget.innerHTML = `<div class="relative cursor-default select-none py-2 px-4 text-gray-700 dark:text-gray-300">
        No matches found in the current dashboard. Try selecting a different time range or searching for something different
      </div>`

  }
  renderOptions(options) {
    console.log("renddering sss")
    options.forEach((option, index) => {
      const optionElement = document.createElement("li");
      const isHighlighted = this.highlightedIndexValue === index;
      optionElement.innerHTML = `<span class="block truncate" data-index="${index}">${option.text}</span>`;
      optionElement.className = classNames('relative cursor-pointer select-none py-2 px-3 hover:bg-primary-600 hover:text-white', {
        'text-accent-900': !isHighlighted,
        'bg-primary-600 text-white': isHighlighted,
      });

      if(isHighlighted) {
        optionElement.dataset.comboboxTarget = "option"
      }
      optionElement.dataset.action = "click->combobox#selectOption mouseover->combobox#highlight"
      optionElement.dataset.index = index;
      optionElement.dataset.value = option.value
      optionElement.id = `plausible-combobox-option-${index}`;

      this.listTarget.appendChild(optionElement);
    });
  }
  optionsValueChanged(current, before) {
    this.renderDropDownContent()
  }

  isOptionDisabled(option) {
    const disabled = this.selectedValue.some((val) => val.value === option.value)

    return disabled
  }

  visibleOptions() {
    const visibleOptions = [...this.optionsValue]
    if (this.freeChoiceValue && this.inputTarget.length > 0 && this.optionsValue.every(option => option.value !== this.inputTarget.value)) {
      visibleOptions.push({value: this.inputTarget.value, label: this.inputTarget.value, freeChoice: true})
    }

    return visibleOptions
  }

  selectedValueChanged(current, prev) {
    this.renderSelectedValues()
    this.renderDropDownContent()
  }

  removeOption(e) {
    e.stopPropagation()
    console.log(e.target.dataset.value)
    const option = this.selectTarget.querySelector(`option[value="${e.target.dataset.value}"]`);
    option.remove()
    const newValues = [];
    this.selectTarget.querySelectorAll('option[selected]').forEach(option => {
      newValues.push({text: option.text, value: option.value })
    })
    this.selectedValue = newValues;
    this.isOpenValue = false
  }

  renderSelectedValues() {
    this.selectTarget.innerHTML = ""
    this.selectedTarget.innerHTML = ""
    console.log("rendering selected " , this.selectedValue)
    this.selectedValue.forEach(value => {
      console.log(value)
      const option = document.createElement('option');
      option.text = value.text;
      option.value = value.value;
      option.setAttribute('selected', 'selected')
      this.selectTarget.appendChild(option)

      const el = document.createElement("div");
      el.classList.add('bg-primary-100', 'flex', 'justify-between', 'w-full', 'rounded-sm', 'px-2', 'py-0.5', 'm-0.5', 'text-sm');
      el.innerHTML = `<span class="break-all">${option.text}</span><span class="cursor-pointer font-bold ml-1" data-action="click->combobox#removeOption" data-value="${option.value}" >×</span>`;
      this.selectedTarget.appendChild(el)
    })
    if(this.selectedValue.length === 0) {
      this.selectedTarget.style.display = "none"
    } else {
      this.selectedTarget.style.display = ""
    }
  }
}
