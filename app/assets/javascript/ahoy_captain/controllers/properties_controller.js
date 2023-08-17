import {Controller} from "@hotwired/stimulus"

export default class extends Controller {

  handleChange(event) {
    document.querySelector('turbo-frame#goals').src = event.target.value
  }
}
