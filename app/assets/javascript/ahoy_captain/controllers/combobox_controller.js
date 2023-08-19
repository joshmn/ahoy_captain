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
    disabled: Boolean,
    input: String,
    highlightedIndex: Number,
    singleOption: Boolean,
    freeChoice: { type: Boolean, default: false },
    selected: Array,
    url: String,
    query: String
  };

  connect() {
    this.isLoadingValue = false;
    this.isOpenValue = false;
    this.inputValue = '';
    this.highlightedIndexValue = 0;
    this.clickHandler = this.clickHandler.bind(this)

    this.inputTarget.addEventListener('keydown', this.onKeyDown.bind(this))
    this.debouncedFetchOptions = debounce(this.fetchOptions.bind(this), 250);
    this.checkDisabledState();
    if(this.singleOptionValue) {
      this.selectTarget.removeAttribute('multiple')
    } else {
      this.selectTarget.multiple = true
    }

    Object.defineProperty(this.selectTarget, "combobox", {
      enumerable: false,
      configurable: false,
      writable: false,
      value: this,
    });

    const targetNode = this.selectTarget;
    const config = { attributes: true };

    const callback = (mutationList, observer) => {
      for (const mutation of mutationList) {
        if (mutation.type === "attributes") {
          this.handleNameChange()
        }
      }
    };

    const observer = new MutationObserver(callback);
    observer.observe(targetNode, config);


    window.dispatchEvent(new CustomEvent('combobox:init', { detail: { combobox: this } }))
    this.search = new URLSearchParams(window.location.search);
    this.search.delete(this.selectTarget.name)
  }

  handleNameChange() {
    if(this.selectTarget.name.includes("_cont]")) {
      this.freeChoiceValue = true
    } else {
      this.freeChoiceValue = false
    }
  }
  checkDisabledState() {
    if (this.disabledValue) {
      this.element.classList.add('opacity-80', 'cursor-default', 'pointer-events-none');
    } else {
      this.element.classList.remove('opacity-80', 'cursor-default', 'pointer-events-none')
    }
  }

  onInput(event) {
    this.inputValue = event.target.value;
    this.debouncedFetchOptions(this.inputValue);
  }

  fetchOptions(query) {
    if(this.disabledValue) { return }

    if(this.freeChoiceValue) {
      this.isLoadingValue = false;
      this.highlightedIndexValue = 0;
      this.optionsValue = [{ text: query, value: query }];
      this.isOpenValue = true;

    } else {
      this.isLoadingValue = true;
      this.isOpenValue = true;

      const formData = new FormData(this.selectTarget.form);
      const searchParams = new URLSearchParams([...formData.entries()]);

      searchParams.delete(this.selectTarget.name);
      searchParams.delete(this.queryValue);
      searchParams.set(this.queryValue, query);

      fetch(`${this.urlValue}?${searchParams.toString()}`).then(resp => resp.json()).then(loadedOptions => {
        this.isLoadingValue = false;
        this.highlightedIndexValue = 0;
        this.optionsValue = loadedOptions.map(option => ({ text: option.text, value: option.value }));
      });
    }
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

  setSelected(values) {
    this.selectedValue = values;
  }

  setDisabled(value) {
    this.disabledValue = value
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
      this.selectedValue = [option]
    } else {
      this.selectedValue = [...this.selectedValue, option]
    }
    this.isOpenValue = false;
    this.inputTarget.value = '';
    this.highlightedIndexValue = 0
  }

  toggleOpen() {
    if (!this.isOpenValue) {
      this.debouncedFetchOptions(this.inputValue);
      this.inputTarget.focus();
      document.addEventListener('click', this.clickHandler)
    } else {
      this.inputValue = '';
      this.isOpenValue = false;
      document.removeEventListener('click', this.clickHandler)
    }
  }

  clickHandler(event) {
    if(event.target.classList.contains('combobox-option')) {
      return
    } else {
      this.toggleOpen()
      return
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
        No matches found in the current dashboard. Try selecting a different time range or searching for something different.
      </div>`

  }
  renderOptions(options) {
    options.forEach((option, index) => {
      const optionElement = document.createElement("li");
      const isHighlighted = this.highlightedIndexValue === index;
      optionElement.innerHTML = `<span class="block truncate" data-index="${index}">${option.text}</span>`;
      optionElement.className = classNames('combobox-option relative cursor-pointer select-none py-2 px-3 hover:bg-primary-600 hover:text-white', {
        'text-accent-900': !isHighlighted,
        'bg-primary-600 text-white': isHighlighted,
      });

      if(isHighlighted) {
        optionElement.dataset.comboboxTarget = "option"
      }
      optionElement.dataset.action = "click->combobox#selectOption"
      optionElement.dataset.index = index;
      optionElement.dataset.value = option.value
      optionElement.id = `combobox-option-${index}`;

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
    this.selectedValue.forEach(value => {
      const option = document.createElement('option');
      option.text = value.text;
      option.value = value.value;
      option.setAttribute('selected', 'selected')
      this.selectTarget.appendChild(option)

      const el = document.createElement("div");
      el.classList.add('text-primary-content', 'bg-primary', 'flex', 'justify-between', 'w-full', 'rounded-sm', 'px-2', 'py-0.5', 'm-0.5', 'text-sm');
      el.innerHTML = `<span class="break-all">${option.text}</span><span class="cursor-pointer font-bold ml-1" data-action="click->combobox#removeOption" data-value="${option.value}" >×</span>`;
      this.selectedTarget.appendChild(el)
    })
    var event = new Event('change');
    this.selectTarget.dispatchEvent(event);
    if(this.selectedValue.length === 0) {
      this.selectedTarget.style.display = "none"
    } else {
      this.selectedTarget.style.display = ""
    }
  }

  freeChoiceValueChanged(current, prev) {
    if(this.selectedValue.filter(value => value.freeChoice).length) {
      console.log("free choice changed")
      this.setSelected([])
    }

  }
  disabledValueChanged(current) {
    if(current) {
      this.isOpenValue = false
      this.inputTarget.disabled = true
      this.checkDisabledState()
    } else {
      this.inputTarget.removeAttribute('disabled')
      this.checkDisabledState()
    }
  }
}
