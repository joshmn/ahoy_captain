import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["delete"];
  static values = {
    columnPredicate: String,
    category: String
  }

  remove(event) {
    event.preventDefault();
    this.dispatch('remove', {detail: {
      paramKey: `q[${this.columnPredicateValue}]`,
      paramValue: this.categoryValue
    }})
  }
}
